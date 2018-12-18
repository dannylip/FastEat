//
//  AppDelegate.swift
//  FastEat
//
//  Created by Danny LIP on 12/9/2018.
//  Copyright © 2018年 Danny LIP. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let googleApiKey = "AIzaSyBzvsgzmx_jULwExFst4y6NJ5c9tAzUnYU"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }
}

