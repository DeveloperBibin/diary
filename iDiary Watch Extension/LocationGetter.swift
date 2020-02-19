//
//  LocationGetter.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData
import MapKit
import Combine
import Contacts

class Location : NSObject, ObservableObject
{
    let geocoder = CLGeocoder()
    public let objectWillChange = PassthroughSubject<place,Never>()
   
    
    let locationManager : CLLocationManager
   
    
    
    
    public private(set) var location: place = place(lat: 0, lon: 0, title: "", subTitle: "") {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    public override init(){
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
       // locationManager.startUpdatingLocation()
        
    }
    func restartLocation()
    {
        self.locationManager.startUpdatingLocation()
    }
    func endUpdatingLocation()
    {
        self.locationManager.stopUpdatingLocation()
    }
}

extension Location : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let newLocation = locations.last else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        DispatchQueue.main.async {
            self.geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
                guard error == nil else {
                    print("\(String(describing: error))")
                    return
                }
                
                // Most geocoding requests contain only one result.
                if let firstPlacemark = placemarks?.first {
                    print("\(firstPlacemark.locality ?? "N/A")")
                    
                    var title : String
                    {
                        if firstPlacemark.name != nil
                        {
                            return firstPlacemark.name!
                        }
                        else
                        {return "---"}
                    }
                    var subTitle : String
                    {
                        var temp : String = ""
                        if firstPlacemark.subThoroughfare != nil
                        {
                            temp.append(", \(firstPlacemark.subThoroughfare!)")
                        }
                        if  firstPlacemark.thoroughfare != nil
                        {
                            temp.append(", \(firstPlacemark.thoroughfare!)")
                        }
                        
                        if firstPlacemark.subLocality != nil
                        {
                            temp.append(", \(firstPlacemark.subLocality!)")
                        }
                        if firstPlacemark.locality != nil
                        {
                            temp.append(", \(firstPlacemark.locality!)")
                        }
                        if temp.first == ","
                        {
                            temp = String(temp.dropFirst())
                        }
                        temp = temp.trim()
                        return temp
                    }
                    
                    self.location = place(lat: 0, lon: 0, title: title, subTitle: subTitle)
                    
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
        
        
        
    }
    
    
    
    
    
    
}


struct place
{
    var lat : Double
    var lon : Double
    var title : String
    var subTitle : String
}


extension String
{
    func trim() -> String
   {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
