//
//  FetchPlacesClass.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import Combine

class FetchPlacesClass : ObservableObject
{
   
    
  @Published var searchText : String = ""
  private var resultPlacess : [SampleCass] = []
  @Published var results : [SampleCass] = []
  @Published var resultPlaces : [SampleCass] = []
    var placeList : [MKMapItem]?
    var boundingRegion: MKCoordinateRegion?
    private var localSearch: MKLocalSearch?
    private var places: [MKMapItem]?
    private var cancellableSet: Set<AnyCancellable> = []
    var locationManager : LocationManager = LocationManager()
    private var locations : AnyPublisher<[SampleCass], Never>
    {
        $searchText
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{
              input in
              print("\(input)")
               return self.search(for : input)
                
            
        }.eraseToAnyPublisher()
        
        
        
    }
  
    
    init() {
        
        
        locations
            .receive(on: RunLoop.main)
            .map{
                results in
                results
            }
        .assign(to: \.resultPlaces, on: self)
        .store(in: &cancellableSet)
        
    
    }
  
      
    func search(for queryString: String?) -> [SampleCass] {
        
        self.locationManager.requestLocation()
        
        resultPlaces = []
      //  self.locationManager.requestLocation()
        
        if let location = locationManager.currentLocation
        {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.boundingRegion = region
            print("Bouding Region is set.")
        }
        
        if let location = locationManager.currentLocation
        {
            print("Kerrant Location is \(location.coordinate.latitude)")
            
        }
        else
        {
            self.locationManager.requestLocation()
        }
           
           
           print("func search(for queryString: String?) - Line 145")
           let searchRequest = MKLocalSearch.Request()
           searchRequest.naturalLanguageQuery = queryString
           searchRequest.resultTypes = [.pointOfInterest, .address]
     
           let retuls = search(using: searchRequest)
            return retuls
       }
       
       /// - Tag: SearchRequest
          private func search(using searchRequest: MKLocalSearch.Request) -> [SampleCass] {
           
            print("func search(using searchRequest: MKLocalSearch.Request) - Line 154")
            
           // Confine the map search area to an area around the user's current location.
        
           if let region = boundingRegion {
               searchRequest.region = region
           }
           
           localSearch = MKLocalSearch(request: searchRequest)
                self.localSearch?.start {
                    
                            [weak self] (response, error) in
                               guard error == nil else {
                                
                                   return
                               }
                
                            self?.places = response?.mapItems
                            if let temPlaces = self?.places
                            {
                                
                                var sampletemp : SampleCass
                                self?.resultPlacess = []
                                for item in temPlaces
                                {
                                    sampletemp = SampleCass(title: item.name ?? "Nothing", subTitle: item.placemark.title ?? "SubNothing", lat: item.placemark.coordinate.latitude, lon: item.placemark.coordinate.longitude, ids: item.hash)
                                    //print("MapItem : \(item)")
                                    self?.resultPlacess.append(sampletemp)
                                
                                   
                                }
                             
                                self?.resultPlaces = self?.resultPlacess ?? []
                            }
                            
                               self?.boundingRegion = response?.boundingRegion
                               
                           }
            
           
        
        return resultPlacess

       }
    
    
}




class SampleCass : Identifiable, Hashable
{
    static func == (lhs: SampleCass, rhs: SampleCass) -> Bool {
        
        if lhs.hashValue == rhs.hashValue
        {return true}
        else
        {return false}
        
    }
    
    
    var title : String
    var subTitle : String
    var lat : Double
    var lon : Double
    var ids : Int
    
    init(title : String, subTitle : String, lat : Double , lon : Double, ids : Int) {
        
        self.title = title
        self.subTitle = subTitle
        self.lat = lat
        self.lon = lon
        self.ids = ids
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        hasher.combine(self.lat)
        hasher.combine(self.lon)
        hasher.combine(self.subTitle)
    }
    
}

