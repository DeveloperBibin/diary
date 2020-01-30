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
        
        VStack(alignment : .leading, spacing : 5) {
            
         
            HStack(alignment : .center) {
            
                
                //Text("Not an good day to start")
                Text(self.data.title.isBlank ? "Dear Diary" : self.data.title)
                    .foregroundColor(.primary)
                    .font(.system(.headline, design: .rounded))
  

                 Spacer()
                VStack {
                            // Text("December 13")
                    Text("\(dateDesc)")
                                 .font(.system(.caption, design: .rounded))
                                 .shadow(radius: 0.1)
                         }

                
               
            }
            
           
            
                
          
            if !(self.data.entry.isEmpty)
            {Text(self.data.entry)
               // Text(content)
                    .font(.system(.subheadline, design : .rounded))
                .fontWeight(.light)
                .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            
            HStack(spacing : 10) {
                
                if !(self.data.images.isEmpty)
                {ImageIcon().padding(4)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(5)}
                if !(self.data.contacts.isEmpty)
                {ContactIcon().padding(4)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(5)}
                if !(self.data.locations.isEmpty)
                {LocationIcon().padding(4)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(5)}
            }
            .padding(.top, 4)
            
    Divider()
        .padding(.top, 5)
        }.padding()
}
}



//struct DiaryThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//
//        DiaryThumbnail(data: DiaryItem())
//    }
//}
//













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


