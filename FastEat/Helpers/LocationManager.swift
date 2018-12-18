//
//  LocationManager.swift
//  FastEat
//
//  Created by Danny LIP on 14/10/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    private override init() {
        super.init()
        
        manager.delegate = self
    }
    
    func reuqestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        reuqestAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            UIApplication.shared.keyWindow?.rootViewController?.present(
                UIAlertController(title: "無法取得當前位置", message: "請去設定開啟位置定位", preferredStyle: .alert), animated: true
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            NotificationCenter.default.post(name: NotificationName.didUpdateLocations, object: nil, userInfo: ["location": location])
        }
    }
}


