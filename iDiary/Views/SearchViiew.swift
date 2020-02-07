//
//  SearchViiew.swift
//  iDiary
//
//  Created by Bibin Benny on 05/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct SearchViiew: View {
    var diaries : FetchedResults<Diary>
    @State var contactList : [Contact] = []
    @State var locationList : [Location] = []
    @State var frequentContacts : [Contact] = []
    @State var filteredContacts : [Contact] = []
    
    @State var frequentLocations : [Location] = []
    @State var filteredLocations : [Location] = []
    @State var selectedSearchOption : Int = 0
    
    @State var searchOptions = ["pencil","person.crop.circle","mappin.and.ellipse" ]
    
    var body: some View {
        VStack
            {
                if (self.selectedSearchOption == 0)
                {FavSearchView(diaries: self.diaries)}
                else if(self.selectedSearchOption == 1)
                {ContactsSearchView(diaries: self.diaries)}
                else
                {LocationSearchView(diaries: self.diaries)}
                Spacer()
        }.overlay(VStack
            {
                Spacer().frame(height : 50)
                Picker(selection: $selectedSearchOption, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(0 ..< self.searchOptions.count)
                    {
                        Image(systemName: self.searchOptions[$0])
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.trailing, .leading])
                Spacer()
        })
        
    }
}

//struct SearchViiew_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchViiew()
//    }
//}

struct FavSearchView : View{
    @State var text : String = ""
    @State var captionTitle = "Favourite Entries"
    @State var image = "text.badge.star"
    var diaries : FetchedResults<Diary>
    @State var filteredList : [Diary] = []
    var body : some View
    {
        let binding = Binding<String>(get: {self.text}, set: {
            
            DispatchQueue.global(qos: .background).async {
                self.filteredList = self.diaries.filter({"\($0.title) \($0.entry)".lowercased().contains(self.text.lowercased())})
            }
            self.text = $0
        })
        
        return VStack{
            
            SearchBar(text: binding, placeHolder: "Search Entries")
            Spacer().frame(height : 70)
            List{
                
                if !self.filteredList.isEmpty
                {
                    ForEach(self.filteredList)
                    {
                        (diary : Diary) in
                        NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                        {
                            DiaryThumbnail(data: diary)
                            
                        }
                    }.onDelete(perform: delete)
                        .listRowInsets(EdgeInsets())
                }
                else
                {
                    VStack{
                        Spacer().frame(height : UIScreen.main.bounds.size.height / 20 )
                        EmptyIndication(caption: "No Favourited items.")
                    }
                }
                
                
            }
        }
         .onAppear()
            {
                self.filteredList = self.diaries.filter({$0.isFav})
        }
        
        
    }
    func delete(at offsets: IndexSet) {
        //Delete here
        print("Deleted")
    }
}

struct ContactsSearchView : View
{
    @State var text : String = ""
    @State var contactList : [Contact] = []
    @State var frequentContacts : [Contact] = []
    @State var isContactSheetPresented : Bool = false
    @State var pickedTempcontact : Contact = Contact()
    var diaries : FetchedResults<Diary>
    @State var filteredContacts : [Contact] = []
    @State var showFav : Bool = true
    @State var isLoading : Bool = true
    var body : some View
    {
        
        let binding = Binding<String>(get: {self.text}, set: {
            self.text = $0
            switch(self.text.isBlank)
            {
            case true:
                self.showFav = true
                self.filteredContacts = self.contactList
            case false:
                DispatchQueue.global(qos: .background).async {
                    self.filteredContacts = self.contactList.filter({$0.name.lowercased().contains(self.text.lowercased())})
                }
                self.showFav = false
                
            }
            
            
        })
        return VStack
            {
                if !self.isLoading{
                SearchBar(text: binding, placeHolder: "Search Contacts")
                Spacer().frame(height : 40)
                if !self.contactList.isEmpty
                {
                    if self.showFav{
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(spacing : 15)
                            {
                                VStack(alignment : .leading) {
                                    Text("Frequent")
                                        .fontWeight(.light)
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                        .lineLimit(1)
                                    
                                    Text("Contacts")
                                        .fontWeight(.medium)
                                        .font(.headline)
                                        .foregroundColor(Color(.systemOrange))
                                        .lineLimit(1)
                                }.padding()
                                
                                ForEach(self.frequentContacts)
                                {
                                    contact in
                                    Button(action : {
                                        self.pickedTempcontact = contact
                                        self.isContactSheetPresented.toggle()
                                    }){
                                        DiaryPageContactView(contact: contact)
                                    }}
                                
                            }.frame(height : 150)
                        }.listRowInsets(EdgeInsets())
                            .padding([.top, .bottom])
                            .animation(.default)
                            .background(Color(.tertiarySystemGroupedBackground))
                    }
                    
                    List
                        {
                            ForEach(self.filteredContacts)
                            {
                                (contact : Contact) in
                                Button(action : {
                                    self.pickedTempcontact = contact
                                    self.isContactSheetPresented.toggle()
                                })
                                {
                                    VStack(spacing : 4){
                                        ContactRow(name: contact.name , image: contact.imageDataAvailble ? Image(uiImage: UIImage(data: contact.imageData)!) : nil)
                                        Divider()
                                    }
                                }
                                
                            }
                    }.sheet(isPresented: self.$isContactSheetPresented)
                    {
                        ContactOverView(contact: self.pickedTempcontact, diaries: self.diaries)
                        
                    }
                }
                else
                {
                    VStack{
                        EmptyIndication(caption : "No Contacts")
                    }
                }
                }
                else
                {
                    VStack
                                           {
                                            HStack{Spacer()}
                                               Spacer().frame(height : UIScreen.main.bounds.size.height / 4)
                                               Text("Loading...")
                                                   .font(.subheadline)
                                                   .foregroundColor(.secondary)
                                               Spacer()
                                       }
                }
        }.animation(.default)
            .onAppear()
                {
                    
                    DispatchQueue.global(qos: .background).async {
                        self.contactList = []
                        for diary in self.diaries
                        {
                            self.contactList.append(contentsOf: diary.contacts)
                        }
                        let mappedItems = self.contactList.map { ($0.id, 1) }
                        let dict = Dictionary(mappedItems, uniquingKeysWith: +)
                        let byValue = {
                            (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
                            if elem1.val > elem2.val {
                                return true
                            } else {
                                return false
                            }
                        }
                        let sortedDict = dict.sorted(by :byValue)
                        
                        let sortedContactIds = sortedDict.map{$0.key}
                        self.contactList = self.contactList.unique(map: {$0.id})
                        self.frequentContacts = self.contactList.filter({sortedContactIds.prefix(4).contains($0.id)})
                        self.filteredContacts = self.contactList
                        self.isLoading = false
                    }
                    
        }
        
    }
}



struct LocationSearchView : View
{
    
    @State var text : String = ""
    @State var locationList : [Location] = []
    @State var frequentLocations : [Location] = []
    @State var isLocationSheetPresented : Bool = false
    @State var pickedTempLocation : Location = Location()
    var diaries : FetchedResults<Diary>
    @State var filteredLocations : [Location] = []
    @State var showFav : Bool = true
    @State var isLoading : Bool = true
    
    var body : some View
    {
        
        let binding = Binding<String>(get: {self.text}, set: {
            self.text = $0
            switch(self.text.isBlank)
            {
            case true:
                self.showFav = true
                self.filteredLocations = self.locationList
            case false:
                DispatchQueue.global(qos: .background).async {
                    self.filteredLocations = self.locationList.filter({$0.title.lowercased().contains(self.text.lowercased())})
                }
                self.showFav = false
                
            }
            
            
        })
        
        
        return VStack
            {
                if(!self.isLoading)
                {
                    SearchBar(text: binding, placeHolder: "Search Locations")
                    Spacer().frame(height : 40)
                    if !self.locationList.isEmpty
                    {
                        if self.showFav{
                            ScrollView(.horizontal, showsIndicators: false)
                            {
                                HStack(spacing : 15)
                                {
                                    VStack(alignment : .leading) {
                                        Text("Frequent")
                                            .fontWeight(.light)
                                            .font(.caption)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .lineLimit(1)
                                        Text("Locations")
                                            .fontWeight(.medium)
                                            .font(.headline)
                                            .foregroundColor(Color(.systemBlue))
                                            .lineLimit(1)
                                    }.padding()
                                    
                                    ForEach(self.frequentLocations)
                                    {
                                        location in
                                        Button(action : {
                                            self.pickedTempLocation = location
                                            self.isLocationSheetPresented.toggle()
                                        }){
                                            FrequentLocationViewSearch(location: location)
                                        }}
                                    
                                }.frame(height : 150)
                            }.listRowInsets(EdgeInsets())
                                .padding([.top, .bottom])
                                .animation(.default)
                                .background(Color(.tertiarySystemGroupedBackground))
                        }
                        
                        List
                            {
                                ForEach(self.filteredLocations)
                                {
                                    (location : Location) in
                                    Button(action : {
                                        self.pickedTempLocation = location
                                        self.isLocationSheetPresented.toggle()
                                    })
                                    {
                                        LocationResultModel(title: location.title, desc: location.subTitle)
                                    }
                                    
                                }
                        }.sheet(isPresented: self.$isLocationSheetPresented)
                        {
                            LocatinOverView(diaries: self.diaries, location: self.pickedTempLocation)
                            
                        }
                    }
                    else
                    {
                        VStack{
                            EmptyIndication(caption : "No Locations")
                        }
                    }
                }
                else
                {
                    VStack
                        {
                            HStack{Spacer()}
                            Spacer().frame(height : UIScreen.main.bounds.size.height / 4)
                            Text("Loading...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                    }
                }
        }.animation(.default)
            .onAppear()
                {
                    
                    DispatchQueue.global(qos: .background).async {
                        self.locationList = []
                        
                        for diary in self.diaries
                        {
                            
                            self.locationList.append(contentsOf: diary.locations)
                        }
          
                        let mappedItemsLocation = self.locationList.map {($0.id, 1)}
                        let dictLocation = Dictionary(mappedItemsLocation, uniquingKeysWith: +)
                        let byValueLocation = {
                            (elem1:(key: Int64, val: Int), elem2:(key: Int64, val: Int))->Bool in
                            if elem1.val > elem2.val {
                                return true
                            } else {
                                return false
                            }
                        }
                        
                        let sortedDictLocation = dictLocation.sorted(by : byValueLocation)
                        let sortedLocation = sortedDictLocation.map({$0.key})
                        
                        self.locationList = self.locationList.unique(map: {$0.id})
                        self.frequentLocations = self.locationList.filter({
                            sortedLocation.prefix(4).contains($0.id)
                        })
                        self.filteredLocations = self.locationList
                        self.isLoading = false
                    }
                    
        }
        
    }
}
