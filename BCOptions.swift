//
//  BCOptions.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct BCOptions {
    
    static let defaultsDictionary : [String : AnyObject] = {
        let fp = NSBundle.mainBundle().pathForResource("factoryDefaults", ofType: "plist")
        return NSDictionary(contentsOfFile: fp!) as! [String : AnyObject]
    }()
    
    static let defaults : NSUserDefaults = {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.registerDefaults(BCOptions.defaultsDictionary)
        ud.synchronize()
        return ud
    }()
    
    lazy var backgroundUpdates : Bool = BCOptions.defaults.boolForKey("backgroundUpdates")
    lazy var headingAvailable : Bool  = CLLocationManager.headingAvailable()
    lazy var headingUP : Bool         = {
        return self.headingAvailable && BCOptions.defaults.boolForKey("headingUP")
    }()
    var userTrackingMode : MKUserTrackingMode {
        mutating get {
            return self.headingUP ? .FollowWithHeading : .Follow
        }
    }
    lazy var showTraffic : Bool = BCOptions.defaults.boolForKey("showTraffic")
    lazy var distanceBetweenMeasurements : Double = BCOptions.defaults.doubleForKey("distanceBetweekMeasurements")
    lazy var gpsPrecision : Double = BCOptions.defaults.doubleForKey("gpsPrecision")
    
    mutating func updateDefaults() {
        BCOptions.defaults.setBool(backgroundUpdates, forKey: "backgroundUpdates")
        BCOptions.defaults.setBool(headingUP, forKey: "headingUP")
        BCOptions.defaults.setBool(showTraffic, forKey: "showTraffic")
        BCOptions.defaults.setDouble(distanceBetweenMeasurements, forKey: "distanceBetweenMeasurements")
        BCOptions.defaults.setDouble(gpsPrecision, forKey: "gpsPrecision")
    }
    
    static func commit() {
        BCOptions.defaults.synchronize()
    }
}