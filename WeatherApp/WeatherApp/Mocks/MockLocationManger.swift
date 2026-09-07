//
//  MockLocationManger.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManagerType {
    
    var permissionShouldSucceed: Bool = true
    var locationShouldSucceed: Bool = true
    
    func requestLocationPermission() async throws {
        if !permissionShouldSucceed {
            throw MockError.permissionError
        }
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        if locationShouldSucceed {
            return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        } else {
            throw MockError.locationError
        }
    }
}
