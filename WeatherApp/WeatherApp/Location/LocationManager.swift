//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

import CoreLocation

enum LocationError: Error {
    case permissionDenied
    case unavailable
}

// MARK: - Protocol Definition

protocol LocationManagerType {

    func requestLocationPermission() async throws
    func getCurrentLocation() async throws -> CLLocationCoordinate2D
}

// MARK: - Location Manager Implementation

final class LocationManager: NSObject, LocationManagerType, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let manager = CLLocationManager()
    
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var permissionContinuation: CheckedContinuation<Void, Error>?

    // MARK: - Initialization

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: - Public Methods
    
    func requestLocationPermission() async throws {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return

        case .denied, .restricted:
            throw LocationError.permissionDenied

        case .notDetermined:
            try await withCheckedThrowingContinuation { continuation in
                self.permissionContinuation = continuation
                manager.requestWhenInUseAuthorization()
            }

        @unknown default:
            throw LocationError.permissionDenied
        }
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        guard manager.authorizationStatus == .authorizedWhenInUse else {
            throw LocationError.permissionDenied
        }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                manager.requestLocation()
            }
        } onCancel: {
            self.continuation?.resume(throwing: CancellationError())
            self.continuation = nil
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            permissionContinuation?.resume()
            permissionContinuation = nil

        case .denied, .restricted:
            permissionContinuation?.resume(throwing: LocationError.permissionDenied)
            permissionContinuation = nil

        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        continuation?.resume(returning: location.coordinate)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: LocationError.unavailable)
        continuation = nil
    }
}
