//
//  DiaryPage.swift
//  iDiary
//
//  Created by Bibin Benny on 30/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct DiaryPage: View {
 
    @ObservedObject var data : Diary
    var diaryItems : FetchedResults<Diary>
    //@State var  entry : String
    @State var isImageSheetPresented : Bool = false
    
    @State var tempItemPressed : Int = 0
    
    @State var favouriteButtonPressed : Bool = false
    
    @State var disable : Bool = true
    
    var images : [Photo]
    {
        return Array(self.data.images)
    }
    
    var contacts : [Contact]
    {
        return Array(self.data.contacts)
    }
    
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    var components : DateComponents
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: data.date)
        return components
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
            return ""
        }
        
    }
    
    
    
    var ifStringisLong : Bool
    {
        if (data.entry.count > 450)
        {return true}
        else
        {return false}
    }
    
    var stringArray : [String]
    {
        
        if (ifStringisLong)
        {
            return splitString(string: self.data.entry)
        }
        else
        {return []}
    }
    
    
    var body: some View {
        
        
        ScrollView(showsIndicators : false)
        {
            
            VStack(alignment : .leading)
            {
                HStack(){Spacer()}
                
                Text("\(self.data.title.isBlank ? "Dear Diary" : self.data.title)")
                    .font(.system(.largeTitle, design: .serif))
                    .opacity(0.8)
                    .padding([.leading, .trailing])
                
                favouriteButton(isFav: self.$data.isFav)
                .padding([.leading, .trailing])
                
                Text("\(data.date.dayOfWeek() ?? "") \(self.month) \(self.components.day!),  \(String(self.components.year!))")
                    .font(.system(.caption, design: .default))
                    .padding(.top)
                    .opacity(0.9)
                .padding([.leading, .trailing])
                
                if (ifStringisLong)
                {
                    Text("\(self.stringArray[0])")
                        .font(.system(.subheadline, design: .serif))
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .opacity(0.8)
                        .layoutPriority(1)
                    .padding([.leading, .trailing])
                    
                    
                    if(!self.data.locations.isEmpty)
                    {
                        MapView(location: Array(self.data.locations))
                            .frame(height : 180)
                        
                    }
                    
                    Text("\(self.stringArray[1])")
                        .font(.system(.subheadline, design: .serif))
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .opacity(0.8)
                        .layoutPriority(1)
                    .padding([.leading, .trailing])
                }
                else
                {
                    Text("\(self.data.entry)")
                        .font(.system(.subheadline, design: .serif))
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .opacity(0.8)
                        .layoutPriority(1)
                    .padding([.leading, .trailing])
                    
                    if(!self.data.locations.isEmpty)
                    { MapView(location: Array(self.data.locations))
                        .frame(height : 180)
                        
                    }
                    
                    
                }
                
                if (!self.data.images.isEmpty)
                {
                    ImageView(images: Array(self.data.images))
                }
                
                
                if (!self.data.contacts.isEmpty)
                {
                    contactView(contacts: Array(self.data.contacts), diaryItems: self.diaryItems)
                    
                }
            }
           // .padding()
            //.background(Color(.systemGroupedBackground))
            Spacer()
                .frame(height : UIScreen.main.bounds.height / 10)
            
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
   
    }
}


struct favouriteButton : View
{
    @Binding var isFav : Bool
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    
    var body : some View
    {
        Button(action : {
            self.isFav.toggle()
            
        })
        {
            HStack
                {
                    Text(self.isFav ? "Favourited" : "Favourite ")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Image(systemName : "heart.circle")
                        .foregroundColor(self.isFav ? Red50400 : .primary)
                        .font(.caption)
                    
            }
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 2)
            .background(RoundedRectangle(cornerRadius: 3).stroke(Color.primary))
            .opacity(0.8)
            .animation(.default)
        }
    }
}

struct contactView : View
{
    
    var contacts : [Contact]
    @State var isContactSheetPresented : Bool = false
    var diaryItems : FetchedResults<Diary>
    @State var pickedTempcontact : Contact = Contact()
    var body : some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack(spacing : 15) {
                
                Text("Contacts")
                    .fontWeight(.bold)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding()
                
                ForEach(self.contacts)
                {
                  contact in
                    DiaryPageContactView(contact: contact)
                        .sheet(isPresented: self.$isContactSheetPresented)
                        {
//                            ContactOverView(contact: contact, diaryItems: self.diaryItems)
                            ContactOverView(contact: self.pickedTempcontact, diaries: self.diaryItems)
                            
                    }
                        .onTapGesture {
                            self.pickedTempcontact = contact
                            self.isContactSheetPresented.toggle()
                    }
                
                }
                
            }
            .frame(height : 100)

        }
        .padding([.top, .bottom])
            
        .background(Color(.quaternarySystemFill))
    }
}

struct ImageView : View
{
    
    var images : [Photo]
    
    var body : some View
    {
            ScrollView(.horizontal, showsIndicators: false)
            {
                HStack {
                    Text("Images")
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding()
                    
                    ForEach(self.images)
                    {
                        (image : Photo) in
                        
                        VStack{
                            Image(uiImage: UIImage(data: image.image)!).resizable()
                                
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius : 2)
                                .onTapGesture {
                                   
                                    
                            }
                        }
                        
                        
                    }  .padding(.leading)
                }
                    
                    
                .frame( height : 200)
                
                
                
                
                
            }
            .padding([.top, .bottom])
                
            .background(Color(.quaternarySystemFill))
        
    }
}

