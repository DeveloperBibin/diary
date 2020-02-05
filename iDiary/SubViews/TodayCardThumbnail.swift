//
//  TodayCardThumbnail.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct TodayCardThumbnail: View {
    
   @ObservedObject var data : Diary
    
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
    
    
    var body: some View {
        VStack(alignment : .leading, spacing : 6) {
            
            HStack(alignment : .firstTextBaseline,spacing : 4)
                    {
                        Image(systemName : "square.and.pencil")
                            .foregroundColor(Color(.systemGreen))
                            .offset(x: 0, y: -2.5)
                        Text("\(self.dateDesc)")
                        .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        Text("\(self.components.day!)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("\((self.data.date.dayOfWeek()?.prefix(3).uppercased())!)")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(blueGray600)
                            .fontWeight(.bold)
                }
            
            if data.isEmpty {
                HStack(alignment : .firstTextBaseline) {
                    
                    
                    
                  
                    Image(systemName : "pencil.circle")
                        .font(.headline)
                        .foregroundColor(Color(.systemBlue))
                    Text("Tap to write")
                                 .font(.headline)
                                     .foregroundColor(Color(.secondaryLabel))
                        .padding(.top, 6)
                    
                    Spacer()
                   
                                           
                }
            }
            else
            {
                Text(self.data.title.isBlank ? "Dear Diary" : self.data.title)
                    .font(.headline)
                 .padding(.top, 6)
                if !(self.data.entry.isEmpty)
                {Text(self.data.entry)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .opacity(0.7)
                .lineLimit(2)
                }
                else
                {
                    EmptyView()
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
                
            }
              
               // .padding(5)
    
            }
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(10)
   // .shadow(radius: 5)
    //.padding()
    }
}

struct TodayCardThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        TodayCardThumbnail(data: Diary())
    }
}
