//
//  MapView.swift
//  iDiary
//
//  Created by Bibin Benny on 30/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
        
        var location : [Location]

        func makeUIView(context: Context) -> MKMapView {
        
        var annotations : [MKPointAnnotation] = []

        for location in location
        {
            let annotation = MKPointAnnotation()
            annotation.title = "\(location.title)"
            annotation.coordinate = CLLocationCoordinate2DMake(location.lat, location.lon)
            annotations.append(annotation)
            print("From Map Annotation")


        }
    
        let mapview = MKMapView(frame: .zero)
        mapview.showAnnotations(annotations, animated: true)
        
        return mapview
        
        
        
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
  
    }

    
}




