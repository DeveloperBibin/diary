//
//  LocationManager.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    
    @Published  var locationstatus  : String?
        
    private var locationManagerObserver: NSKeyValueObservation?
    
    
    override init() {
      
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    func requestLocation() {
        
        print("request Location")
        guard CLLocationManager.locationServicesEnabled() else {
            
           
          //  displayLocationServicesDisabledAlert()
             DispatchQueue.main.async {
                self.locationstatus = "LSD"
                print("Services are not enabled")
               
            }
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        guard status != .denied else {
            
            DispatchQueue.main.async {
                self.locationstatus = "LSDD"
                print("Services are not denied")
                
            }
          
      
            return
        }
         print("request Location")
        locationManager.requestWhenInUseAuthorization()
       
        locationManager.requestLocation()
    }
    
    private func displayLocationServicesDisabledAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DISABLED", comment: "Location services are disabled")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default, handler: nil))
        displayAlert(alertController, message)
    }
    
    private func displayLocationServicesDeniedAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DENIED", comment: "Location services are denied")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        let settingsButtonTitle = NSLocalizedString("BUTTON_SETTINGS", comment: "Settings alert button")
        let openSettingsAction = UIAlertAction(title: settingsButtonTitle, style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                // Take the user to the Settings app to change permissions.
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelButtonTitle = NSLocalizedString("BUTTON_CANCEL", comment: "Location denied cancel button")
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
                
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)
        displayAlert(alertController, "Location Denied")
    }
    
    private func displayAlert(_ controller: UIAlertController, _ alert : String) {
//        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
//            fatalError("The key window did not have a root view controller")
//        }
//        viewController.present(controller, animated: true, completion: nil)
        
        print("Alert: \(alert)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.currentLocation = locations.last
            //print("Location is getting updated.")
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors returns from Location Services.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            
            break
        case .authorizedWhenInUse:
            self.locationstatus = "ok"
           // manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            self.locationstatus = "ok"
          //  manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            print("denied")
            self.locationstatus = "LSD"
            break
        
        default:
            break
        }
    }
    
    
}

