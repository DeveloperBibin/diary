//
//  HomeDiaryStreakView.swift
//  iDiary
//
//  Created by Bibin Benny on 12/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct HomeDiaryStreakView: View {
    
    @Binding var weekNumber : Double
    @Binding var dayNumber : Int
    
    var body: some View {
        VStack{
        GeometryReader {
            geo in
        HStack{
            WeeklyStreaks(weeklyNumber: self.$weekNumber,geo: geo)
           Spacer()
            DailyStreaks(dayNumber: self.$dayNumber, geo: geo)
         
            }
        
    }
        }
    }
}

struct HomeDiaryStreakView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDiaryStreakView(weekNumber: .constant(6), dayNumber: .constant(1))
    }
}

struct WeeklyStreaks : View
{
    @Binding var weeklyNumber : Double
    var geo : GeometryProxy
    var body : some View
    {
        VStack{
            HStack {
                Text("Weekly Streaks")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(Color(.secondaryLabel))
                    .padding([.leading, .top])
                Spacer()
            }
            
            GeometryReader{
                geo in
            HStack{
            
              Spacer()
                ProgressCircleView(value: self.$weeklyNumber, maxValue: 7, style: .line, foregroundColor: Color.green, lineWidth: 7)
                .layoutPriority(2)
                .padding()
                HStack{
                VStack(alignment : .leading)
                    {
                        Text("\(Int(self.weeklyNumber)) of 7")
                            .font(.headline)
                            .foregroundColor((self.weeklyNumber < 1) ? Color(.tertiaryLabel) : Color.green)
                            .fontWeight(.bold)
                        Text("Days")
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                }
                    Spacer()
                }
                .layoutPriority(2)
                Spacer()
                
            }
            Spacer()
            }
        }.frame(width : self.geo.size.width / 2.05, height : UIScreen.main.bounds.size.height / 6)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

struct DailyStreaks : View
{
    @Binding var dayNumber : Int
    var geo : GeometryProxy
    var body : some View
    {
        VStack{
           HStack {
               Text("Day Streaks")
                   .font(.system(.caption, design: .rounded))
                   .foregroundColor(Color(.secondaryLabel))
                   .padding([.leading, .top])
                    Spacer()
           }
            
    
                HStack() {
                    Spacer()
                    Image(systemName : "flame.fill").resizable().aspectRatio(contentMode: .fit)
                        .padding(8)
                        .foregroundColor((self.dayNumber < 1) ? Color(.tertiaryLabel) : Color.orange)
                      
                    VStack {
                        Text("\(self.dayNumber) Day")
                        .font(.headline)
                         .foregroundColor((self.dayNumber < 1) ? Color(.tertiaryLabel) : Color.orange)
                            .fontWeight(.bold)
                        Text("Streak")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    }
                     
                    Spacer()
                   
                }
                    
               
            
            Spacer()
        }.frame(width : self.geo.size.width / 2.05, height : UIScreen.main.bounds.size.height / 6)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
}
