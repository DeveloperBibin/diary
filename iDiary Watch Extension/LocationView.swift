//
//  LocationView.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

struct LocationView: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @State var loading : Bool = false
    @State var locationStatus : Bool = false
    @State var title : String = ""
    @State var subTitle : String = ""
    @ObservedObject var location = Location()
    @State var cllLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    @Environment(\.presentationMode) var presentation
    @ObservedObject var watch : Watch
    
    var tempData : [place] = [place(lat: 12.990194, lon: 75.330482, title: "Ujire", subTitle: "Some place is not good"),place(lat: 12.590194, lon: 74.330482, title: "Ernakulam", subTitle: "Best place on earth"), place(lat: 12.390194, lon: 75.630482, title: "Banglore", subTitle: "Some Stupid place is here."), place(lat: 12.930194, lon: 75.130482, title: "Mumbai", subTitle: "worst place on earth")]
    
    var body: some View {
        
        VStack {
            if !self.loading {
                
                WatchMapView(location: self.$cllLocation).cornerRadius(15)
                LocationNameView(title: self.$title, subTitle: self.$subTitle)
                ButtonsView(onCloseButtonPressed: {self.presentation.wrappedValue.dismiss()}, onRestartButtonPressed: {self.location.restartLocation()}, onAddButtonPressed: {
                    self.OnLocationAdd()
                    self.saveToCoreDate()
                    self.presentation.wrappedValue.dismiss()
                    
                })
            }
            else
            {
                LoadingView(locationStatus: self.$locationStatus)
            }
            
            
        }.onAppear()
            {
               // self.onAppearRoutine()
                //Testing Code
                let item = self.tempData.randomElement()
                self.title = item!.title
                self.subTitle = item!.subTitle
                self.cllLocation = CLLocationCoordinate2DMake(item!.lat, item!.lon)
        }.onReceive(location.objectWillChange)
        {
            location in
            self.cllLocation = CLLocationCoordinate2DMake(location.lat, location.lon)
            self.title = location.title
            self.subTitle = location.subTitle
            self.loading = false
        }
    .onDisappear()
        {
            self.location.endUpdatingLocation()
        }
    }
    
    func OnLocationAdd()
    {
        if self.watch.locations.contains(where: {$0.title == self.title && $0.subTitle == self.subTitle} )
        {
            //Title and Sub Title of the newLocation is already in today's added location List so Do Nothing.
            self.presentation.wrappedValue.dismiss()
        }
        else
        {//Datt should be added to list.
            
            let item = WatchLocation(context: self.managedObjectcontext)
            item.id = Int64("\(self.title)\(self.subTitle)".hashValue)
            item.lat = self.cllLocation.latitude
            item.lon = self.cllLocation.longitude
            item.title = self.title
            item.subTitle = self.subTitle
            self.watch.locations.insert(item)
            
            
            //if deleted item contains this, remove it from deleted item.
            if self.watch.deletdslocations.contains(where: {$0.title == self.title && $0.subTitle == self.subTitle})
            {
                self.watch.deletdslocations = self.watch.deletdslocations.filter({$0.title != self.title && $0.subTitle != self.subTitle})
            }
        }
    }
    func saveToCoreDate()
       {
           do {
               try self.managedObjectcontext.save()
           } catch {
               print(error)
           }
        sendDataToiPhone(self.watch)
       }
    
    func onAppearRoutine()
    {
        self.location.restartLocation()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.locationStatus = true
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(watch: Watch())
    }
}


struct LoadingView : View
{
    @Binding var locationStatus : Bool
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    @State private var isAnimating = false
    var body : some View
    {
        VStack{
            Image(systemName : "arrow.2.circlepath")
                .font(Font.headline.weight(.bold))
                .foregroundColor(.secondary)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0) )
                .animation(foreverAnimation)
                .onAppear {
                    self.isAnimating = true
            }
            
            Text("Loading ...")
                .foregroundColor(.secondary)
            
            if locationStatus{
                Text("Location Services are disabled")
                    .font(.footnote)
                    .foregroundColor(.red).opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        
    }
}

struct ButtonsView : View
{
    var onCloseButtonPressed : () -> Void
    var onRestartButtonPressed : () -> Void
    var onAddButtonPressed : () -> Void
    
    var body : some View
    {
        HStack {
            
            
            Button(action: {
                self.onCloseButtonPressed()
            }) {
                Image(systemName : "xmark")
                    .font(Font.headline.weight(.black))
            }.background(Color.red)
                .clipShape(Circle())
            
            Button(action: {
                self.onRestartButtonPressed()
            }) {
                Image(systemName : "arrow.clockwise")
                    .font(Font.headline.weight(.black))
                
            }.background(Color.secondary)
                .clipShape(Circle())
            Button(action: {
                self.onAddButtonPressed()
            }) {
                Image(systemName : "checkmark")
                    .font(Font.headline.weight(.black))
                
            }.background(Color.green)
                .clipShape(Circle())
            
        }
        
    }
}

struct LocationNameView : View
{
    @Binding var title : String
    @Binding var subTitle : String
    var body : some View
    {
        HStack{
            Text("\(self.title)")
                .font(.headline)
            Text("\(self.subTitle)")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}
