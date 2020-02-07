//
//  MapThumbNailView.swift
//  iDiary
//
//  Created by Bibin Benny on 06/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import SwiftUI
import MapKit

struct MapThumbNailView: UIViewRepresentable {
    
     var location : Location

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
        let center = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.title = "\(location.title)"
        annotation.coordinate = CLLocationCoordinate2DMake(location.lat, location.lon)
        
        view.addAnnotation(annotation)
        
        view.setRegion(region, animated: true)
        view.isZoomEnabled = false
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
    }
}

struct BoxMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapThumbNailView(location: Location())
    }
}
