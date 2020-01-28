//
//  TodayCardButton.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import SwiftUI
import UIKit

struct TodayCardButton: View {
    
    var data : Diary
    
    
    var components : DateComponents
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.data.date)
        return components
    }
    
    var dayDesc : String
    {
        if self.data.date.isInToday
        {
            return "Today"
        }
        else if self.data.date.isInYesterday
        {
            return "Yesterday"
        }
        else
        {
            return "Today"
        }
    }
    
    
    var body: some View {
        
        
        HStack(alignment : .center ) {
            
            HStack{
                
                Image(systemName : "square.and.pencil")
                    .font(.headline)
                
                
                Text("\(self.dayDesc)")
                    .font(.system(.headline))
                    .layoutPriority(1)
            }.padding()
                .layoutPriority(1)
            
            HStack(spacing : 0) {
                
                Text("\(self.components.day!)")
                    
                    .font(.headline)
                    
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding([.leading, .trailing], 4)
                
                Text("\(String(self.data.date.dayOfWeek()!.prefix(3))  .uppercased())")
                    .fontWeight(.light)
                    .layoutPriority(1)
                    .font(.system(.caption, design : .rounded))
                    
                    .foregroundColor(Color.blue)
                
                
            }.padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(15)
            
        }
        .background(Color(.secondarySystemGroupedBackground)  .cornerRadius(15).shadow(radius: 10))
        
        
    }
}



struct TodayCardButton_Previews: PreviewProvider {
    static var previews: some View {
        TodayCardButton(data : Diary())
    }
}
