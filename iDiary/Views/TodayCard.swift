//
//  TodayCard.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct TodayCard: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @ObservedObject var diary : Diary
   // @ObservedObject var floatButtonData = FloatButtonData()
    @State var tempLocationData : SampleCass?
    @State var tempImagePicked : UIImage = UIImage(named: "empty")!
    @State var imagePicked : Bool = false
    
     @State var onLocationButtonClicked : Bool = false
     @State var onPersonButtonClicked : Bool = false
     @State var onPhtotoButtonClicked : Bool = false
     @State var onButtonClicked : Bool = false
    
    
    
    var body: some View {
        ZStack(alignment : .bottomTrailing){
            VStack
                {
                    Title(date: self.$diary.date)
                    WriteDiary(title: self.$diary.title, entry: self.$diary.entry)
            }
            .blur(radius: self.onButtonClicked ? 20 : 0)
            
            if self.onButtonClicked
            {
                
                AddedContectView(diary: self.diary)
                    .environment(\.managedObjectContext, self.managedObjectcontext)
                    .transition(.scaleAndFade)
            }
            
            
            
            HStack{
                Rectangle().fill(Color(.quaternarySystemFill).opacity(0.01))
                    .frame(height : 150)}
            FloatingButton(onLocationButtonClicked: self.$onLocationButtonClicked, onPersonButtonClicked: self.$onPersonButtonClicked, onPhtotoButtonClicked: self.$onPhtotoButtonClicked, onButtonClicked: self.$onButtonClicked).padding(40)
            
        }
        .onReceive(ImagePicker.shared.$image)
        {
            pickedImage in
            guard let image = pickedImage else {return}
             let photo = Photo(context: self.managedObjectcontext)
             //photo.caption = self.caption
             photo.id = UUID()
             photo.image = image.jpeg(.low)!
             self.diary.images.insert(photo)
            
        }
        .onAppear(){self.onButtonClicked = false}
            .background(EmptyView().sheet(isPresented: self.$onLocationButtonClicked, onDismiss:
                {
                    if self.tempLocationData != nil
                    {
                        self.addLocation()
                    }
            })
            {
                LocationSearch(dataPicked: self.$tempLocationData)
                }
        )
            
            .background(EmptyView().sheet(isPresented: self.$onPersonButtonClicked)
            {
                ContactSearch(diary: self.diary)
                    .environment(\.managedObjectContext, self.managedObjectcontext)
                
                }
        )
            .background(EmptyView().sheet(isPresented: self.$onPhtotoButtonClicked)
            {
                ImagePicker.shared.view
            })
           
           
    }
    
    func addLocation()
    {
        let location = Location(context: self.managedObjectcontext)
        location.id = Int64(self.tempLocationData!.ids)
        location.lat = self.tempLocationData!.lat
        location.lon = self.tempLocationData!.lon
        location.title = self.tempLocationData!.title
        location.subTitle = self.tempLocationData!.subTitle
        
        self.diary.locations.insert(location)
        
    }
    
}

struct TodayCard_Previews: PreviewProvider {
    static var previews: some View {
        TodayCard(diary: Diary())
    }
}

struct AddedContectView : View
{
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    @ObservedObject var diary : Diary
    var body : some View
    {
        VStack(alignment : .leading)
        {
            if !(self.diary.images.isEmpty && self.diary.contacts.isEmpty && self.diary.locations.isEmpty)
            {
                VStack{
                    Spacer()
                        .frame(height : 40)
                    
                    
                    
                    if !(self.diary.images.isEmpty)
                    {
                        HStack(alignment : .firstTextBaseline){
                            Image(systemName: "photo.on.rectangle")
                            Text("Images")
                            Spacer()
                        } .font(.callout)
                            .padding([.leading, .trailing])
                        ScrollView(.horizontal, showsIndicators: false){
                           HStack(){
                               ForEach(Array(self.diary.images))
                               {
                                   (photo : Photo) in
                                  ImageThumbnailTodayCard(photo: photo)
                                 .environment(\.managedObjectContext, self.managedObjectcontext)
                               }
                               
                           }
                           .animation(.default)
                           .padding([.leading])
                     
                       }
                       .padding([ .bottom])
                    }
                    
                    if !(self.diary.contacts.isEmpty)
                    {
                        Divider()
                        HStack(alignment : .firstTextBaseline){
                            Image(systemName: "person.crop.square")
                            Text("Contacts")
                                .fontWeight(.bold)
                            Spacer()
                        } .font(.callout)
                            .padding([.leading, .trailing])
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(){
                                ForEach(Array(self.diary.contacts))
                                {
                                    (contact : Contact) in
                                    ContactThumbnailTodayCard(contact: contact)
                                        .environment(\.managedObjectContext, self.managedObjectcontext)
                                }
                                
                            }
                                .animation(.default)
                            .padding([.leading])
                      
                        }
                        .padding([ .bottom])
                        
                    }
                    
                    if !(self.diary.locations.isEmpty)
                    {
                        Divider()
                        HStack(alignment : .firstTextBaseline){
                            Image(systemName: "map")
                            Text("Locations")
                                .fontWeight(.bold)
                            Spacer()
                        } .font(.callout)
                            .padding([.leading, .trailing])
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(){
                                ForEach(Array(self.diary.locations))
                                {
                                    (location : Location) in
                                    LocationThumbailTodayCard(location: location)
                                }
                                
                            }
                            .padding([.leading])
                            .animation(.default)
                            
                            
                        }.padding([ .bottom])
                        
                    }
                    
                    Spacer()
                }
            }
            else
            {
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(.secondaryLabel).opacity(0.4))
                        Spacer()}
                    Spacer()
                    
                }
            }
        }
    }
    
}

struct WriteDiary : View
{
    
    @Binding var title : String
    @Binding var entry : String
    
    var body : some View
    {
        VStack{
            VStack(spacing : 3) {
                TextField("Dear diary,", text: self.$title)
                    .font(.system(.headline, design : .rounded))
                    .padding([.leading, .trailing])
                    .transition(.scale)
                    .opacity(0.7)
            }
            .padding([.top, .bottom], 10)
                
            .background(Color(.quaternarySystemFill))
            .cornerRadius(10)
            .padding([.leading,.trailing])
            .padding([ .bottom], 10)
            
            ZStack {
                TextView(text: self.$entry)
                    .padding([.leading, .trailing])
                    .transition(.scale)
                if (self.entry.isBlank)
                {
                    Image(systemName : "pencil")
                        .font(.system(.largeTitle, design : .rounded))
                        .foregroundColor(Color(.systemGray))
                        .transition(.scale)
                }
            }
            .padding(.bottom)
        }
    }
}


struct Title : View
{
    
    @Binding var date : Date
    
    var components : DateComponents
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return components
    }
    
    
    
    
    let calendar = Calendar.current
    
    var dateDesc : String
    {
        if calendar.isDateInYesterday(date)
        {return "Yesterday"}
        
        if calendar.isDateInToday(date)
        {
            return "Today"
        }
            
        else
        {
            return "Today"
        }
        
        
        
        
    }
    
    var month : String
    {
        switch components.month {
            
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
            
        default:
            return "Fuck"
        }
    }
    
    
    var body : some View
    {
        VStack{
            RoundedView()
            HStack(alignment : .lastTextBaseline)
            {
                
                Text("\(dateDesc)")
                    .font(.title)
                    .fontWeight(.bold)
                HStack(spacing : 4){
                    Text("\(self.components.day!)")
                        .font(.subheadline)
                        .foregroundColor(Blue50)
                        .fontWeight(.medium)
                    Text("\((self.date.dayOfWeek()?.prefix(3).uppercased())!)")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(Blue50)
                        .fontWeight(.bold)
                }.padding(5)
                    .background(Blue50400)
                    .cornerRadius(5)
                    .offset(y : -2)
                Spacer()
            } .padding([.top,.leading, .trailing])
            
        }
    }
}

struct RoundedView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 30,height : 4)
            .padding(.top, 10)
            .opacity(0.6)
            .padding(.bottom, 0)
            .transition(.opacity)
    }
}


extension AnyTransition {
    static var scaleAndFade: AnyTransition {
        let insertion = AnyTransition.scale(scale: 2, anchor: .center)
            .combined(with: .opacity)
        let removal =  AnyTransition.scale(scale: 2, anchor: .center)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
