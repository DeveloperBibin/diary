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
    @ObservedObject var floatButtonData = FloatButtonData()
    @State var tempLocationData : SampleCass?
    
    var body: some View {
        ZStack(alignment : .bottomTrailing){
            VStack
                {
                    Title(date: self.$diary.date)
                    WriteDiary(title: self.$diary.title, entry: self.$diary.entry)
            }
        .blur(radius: self.floatButtonData.onButtonClicked ? 20 : 0)
            
            if self.floatButtonData.onButtonClicked
            {
               
                
                AddedContectView(diary: self.diary)
                    .environment(\.managedObjectContext, self.managedObjectcontext)
                    .transition(.scaleAndFade)
                }
                
            
            
            HStack{
                Rectangle().fill(Color(.quaternarySystemFill).opacity(0.01))
                    .frame(height : 150)}
            FloatingButton(data: floatButtonData).padding(40)
        }.onAppear(){self.floatButtonData.onButtonClicked = false}
        .background(EmptyView().sheet(isPresented: self.$floatButtonData.onLocationButtonClicked, onDismiss:
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
                } .font(.callout)
                    .padding([.leading, .trailing])
            }
            
            if !(self.diary.locations.isEmpty)
            {
                HStack(alignment : .firstTextBaseline){
                    Image(systemName: "map")
                    Text("Locations")
                        .fontWeight(.bold)
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
                    //.animation(.default)
                    
                    
                }
                
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
