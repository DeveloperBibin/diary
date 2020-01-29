//
//  LocationSearch.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//



import SwiftUI
import Combine

struct LocationSearch: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var fetchPlaces = FetchPlacesClass()
    
    @ObservedObject var locationManager = LocationManager()
    
    @State var editChanged : Bool = false
    
    @State var status : String = "Nothing"
    
    @State var location : [SampleCass] = []
    
    @Binding var dataPicked : SampleCass?
     
    
    var body: some View {
        
        return NavigationView {
            VStack {
                
                VStack {
                    HStack {
                        HStack{
                            
                            HStack {
                               
                                Image(systemName : "magnifyingglass")
                                    .foregroundColor(Color(.secondaryLabel))
                                TextField("Search", text: self.$fetchPlaces.searchText)
                                
                                if !self.fetchPlaces.searchText.isBlank {
                                    Button(action: {
                                        self.fetchPlaces.searchText = ""
                                    })
                                    {
                                        Image(systemName: "x.circle.fill")
                                            .foregroundColor(Color(.secondaryLabel))
                                        
                                    }
                                    .transition(.scale)
                                    
                                    
                                }
                                
                                
                                
                            }
                            .padding(7)
                        }
                            
                        .background(Color(.tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding([.leading], 9)
                        .padding(.trailing, self.fetchPlaces.searchText.isEmpty ? 9 : 0)
                        
                        
                        
                        
                    }
                    .animation(.interactiveSpring())
                    .padding(.top, 10)
                }
                
                
                if locationManager.locationstatus == "LSDD" || locationManager.locationstatus == "LSD"
                {
                    PermissionDenied(permissin: "Location")
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    
                }
                
                List(self.fetchPlaces.resultPlaces)
                {
                    location in
                    
                    Button(action: { print("Button Pressed")
                        
                        self.dataPicked = location
                        self.presentationMode.wrappedValue.dismiss()
                        
                        
                    })
                    {
                        LocationResultModel(title: location.title, desc: location.subTitle)
                            .padding([.top,.bottom], 10)
                    }
                }
                .navigationBarTitle(Text("Search places"), displayMode: .large)
                
                
                
                Spacer()
            }
                .onAppear()
                    {
                        self.dataPicked = nil
            }
        }
        
        
    }
    
}


struct LocationSearch_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearch(dataPicked: .constant(SampleCass(title: "", subTitle: "", lat: 10000, lon: 1000, ids: 1001)))
    }
}

