//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation

let globalModel : BCModel = BCModel()

final class BCModel {
    
    private var arrayOfLocations = [CLLocation]()
    private let archivePath = pathToFileInDocumentsFolder("locations")
    private let archiveKey = "LocationArray"
    
    private let queue : dispatch_queue_t = dispatch_queue_create("uk.ac.plymouth.bc", DISPATCH_QUEUE_SERIAL)
    
    private init() {
        //Phase 1 init - nothing to do!

        //super.init()
        
        //Phase 2
        if let m = NSKeyedUnarchiver.unarchiveObjectWithFile(self.archivePath) as? [CLLocation] {
            arrayOfLocations = m
        }

    }
    
    //Asynchronous API
    func addRecord(record: CLLocation, done: ()->()) {
        dispatch_async(queue) {
            self.arrayOfLocations.append(record)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }
    
    /// Add an array of records
    // A Swift array of immutable references is also thread safe
    func addRecords(records : [CLLocation], done : ()->() ) {
        dispatch_async(queue){
            for r in records {
                self.arrayOfLocations.append(r)
            }
            //Call back on main thread (posted to main runloop)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }
    
    /// Erase all data (serialised on a background thread)
    func erase(done done : ()->() ) {
        dispatch_async(queue) {
            self.arrayOfLocations.removeAll()
            //Call back on main thread (posted to main runloop)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }

    // get array
    func getArray(done done : (array : [CLLocation]) -> () ) {
        dispatch_async(queue) {
            let copyOfArray = self.arrayOfLocations
            dispatch_sync(dispatch_get_main_queue()) {
                done(array: copyOfArray)
            }
        }
    }
    
    /// Save the array to persistant storage (simple method) serialised on a background thread
    func save(done done : ()->() ) {
        dispatch_async(queue) {
            NSKeyedArchiver.archiveRootObject(self.arrayOfLocations, toFile: self.archivePath)
            //Call back on main thread (posted to main runloop)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }
    
    func isEmpty(done done : (isEmpty : Bool) ->() ) {
        dispatch_async(queue) {
            let result = self.arrayOfLocations.count == 0
            dispatch_sync(dispatch_get_main_queue()) {
                done(isEmpty: result)
            }
        }
    }
    
    
}
