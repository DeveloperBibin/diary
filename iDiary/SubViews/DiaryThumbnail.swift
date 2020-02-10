//
//  DiaryThumbnail.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//


import SwiftUI

struct DiaryThumbnail: View {
    
    @ObservedObject var data : Diary
    
    //@Binding var fav : Bool
    
    var components : DateComponents
       {
           let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: data.date)
           return components
       }
       
    
    
    
    let calendar = Calendar.current
    
    var dateDesc : String
    {
        if calendar.isDateInYesterday(data.date)
        {return "Yesterday"}
        
        if calendar.isDateInToday(data.date)
        {
            return "Today"
        }
        
        if (data.date.isInThisWeek)
        {
            return data.date.dayOfWeek() ?? month
            
        }
        
    else
        {return "\(month) \(components.day!)"}
        
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
    
    
    var body: some View {
        VStack(alignment : .leading){
            Text("\(self.dateDesc)")
                .font(.system(size: 10))
            .fontWeight(.light)
        
           // .padding(.top, 5)
            //.offset(y : -2.5)
            
            Text("\(self.data.title.isBlank ? "Dear Diary" : self.data.title)")
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.top, 5)
            
            if !(self.data.entry.isBlank)
            {
                
                Text("\(data.entry)")
                .font(.caption)
                .fontWeight(.light)
                .lineLimit(2)
                .padding(.top, 10)
               // .foregroundColor(Color(.secondaryLabel))
            }
            else
            {EmptyView()}
            HStack(alignment : .bottom)
            {
                VStack(alignment : .leading){
                    
                    HStack{
                 
                        if !(self.data.contacts.isEmpty)
                        {
                            Image(systemName : "person.crop.circle.fill.badge.checkmark")
                           .font(.caption)
                           //.foregroundColor(Blue50400)
                        }
                        else
                        {EmptyView()}

                        if !(self.data.images.isEmpty)
                        {Image(systemName : "photo")
                           .font(.caption)
                           //.foregroundColor(Blue50400)
                        }
                        else
                        {EmptyView()}
                   
                        if !(self.data.locations.isEmpty)
                        {Image(systemName : "map")
                           .font(.caption)
                           //.foregroundColor(Blue50400)
                        }
                        else
                        {EmptyView()}
                        Spacer()
                   
               }
                
                }
                
                Spacer()
                if(self.data.isFav)
                {Image(systemName :  "heart.circle.fill")
                    .foregroundColor(Red50A200)
                }
                
                
            }
           
            
            Divider()
                .padding([.bottom,.top], 10)
        }
        .padding([.leading, .trailing])
        
        
}
}





let content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip"

struct ImageIcon: View {
    
    var colors2 : [Color]
    {
    [Color(UIColor(hexString: "#d4fc79")), Color(UIColor(hexString: "#96e6a1"))]
    }
    var gradient: LinearGradient {
             LinearGradient(gradient: Gradient(colors: colors2),
                            startPoint: .top , endPoint: .bottom)
         }
    var body: some View {
        HStack(spacing : 3) {
            
          //  Rectangle().fill(gradient).frame(width : 2, height : 14)
            
            
            Image(systemName : "photo")
                .font(.caption)
                .foregroundColor(Color(.systemOrange))
               // .scaleEffect(0.7)
            Text("Image")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            
            
        }
        
    }
}

struct ContactIcon: View {
    
    var colors2 : [Color]
    {
    [Color(UIColor(hexString: "#f6d365")), Color(UIColor(hexString: "#fda085"))]
    }
    var gradient: LinearGradient {
             LinearGradient(gradient: Gradient(colors: colors2),
                            startPoint: .top , endPoint: .bottom)
         }
    var body: some View {
        HStack(alignment : .center, spacing : 3) {
            
           // Rectangle().fill(gradient).frame(width : 2, height : 14)
            
            
            Image(systemName : "person.circle")
                .font(.caption)
                .foregroundColor(Color(.systemBlue))
               // .scaleEffect(0.8)
            Text("Contact")
                .font(.system(.caption, design: .rounded))
                .fontWeight(.regular)
                .foregroundColor(.secondary)
            
        }
    }
}

struct LocationIcon: View {
    
    var colors2 : [Color]
    {
    [Color(UIColor(hexString: "#4481eb")), Color(UIColor(hexString: "#04befe"))]
    }
    var gradient: LinearGradient {
             LinearGradient(gradient: Gradient(colors: colors2),
                            startPoint: .top , endPoint: .bottom)
         }
    var body: some View {
        HStack(alignment : .center, spacing : 3) {
            
            //Rectangle().fill(gradient).frame(width : 2, height : 14)
            
            
            Image(systemName : "map")
                .font(.caption)
                .foregroundColor(Color(.systemTeal))
                //.scaleEffect(0.8)
            Text("Location")
                .font(.system(.caption, design: .rounded))

                .foregroundColor(.secondary)
            
        }
    }
}


