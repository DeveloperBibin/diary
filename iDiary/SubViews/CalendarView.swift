//
//  CalendarView.swift
//  iDiary
//
//  Created by Bibin Benny on 07/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct CalendarView : View{
    
    let calendar = Calendar.current
    var index : Int 
    let compo : DateComponents
    @State var monthData : [Int : [Int]] = [:]
    
   
    @State var tempDate : Date = Date()
    @State var isPeriodDate : Bool = true
    
    @Binding var mPeriodDates : [Int]
    let geo : GeometryProxy
    var mon : [Int : [Int]] = [:]
    var months = ["January", "February", "March","April","May","June","July","August","September","October","November","December"]
    @Binding var clickedDate : Date
    var onSelected : (Date) -> ()
    //var daysInMonth : [Int]
    
    init(monthIndex : Int, geo : GeometryProxy, mdates : Binding<[Int]>, clickedDate : Binding<Date>, onSeleted : @escaping (Date) -> Void) {
   
        // self._periodDates = dates
        self._clickedDate = clickedDate
        self.geo = geo
        self.index = monthIndex
        self._mPeriodDates = mdates
        self.onSelected = onSeleted
        
        let date = calendar.date(byAdding: .month, value: monthIndex, to: Date())
        var daysInMonth : [Int]
        {
            let year = calendar.component(.year, from: date!)
            
            if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
            {
                return [31,29,31,30,31,30,31,31,30,31,30,31]
            }
            else
            {
                return [31,28,31,30,31,30,31,31,30,31,30,31]
            }
        }
        
        self.compo = calendar.dateComponents([.year, .month], from: date!)
        let c = calendar.date(from: compo)
        let week = calendar.component(.weekday, from: c!)
        var days : [Int]
        
        days = Array(repeating: 0, count: week - 1)
        days.append(contentsOf: Array(1...daysInMonth[compo.month! - 1]))
        days.append(contentsOf: Array(repeating: 0, count: 15))
        
        self.mon[0] = Array(days[0...6])
        self.mon[1] = Array(days[7...13])
        self.mon[2] = Array(days[14...20])
        self.mon[3] = Array(days[21...27])
        self.mon[4] = Array(days[28...34])
        if(Array(days[35...41]).filter({$0 != 0})).count < 0
        {self.mon[5] = Array(days[35...41])}
        
        
        
        
    }
    
    var body: some View
    {
        
        VStack{
            
            
            VStack(spacing : UIScreen.main.bounds.size.height / 20) {
                
            
            
                ForEach(self.mon.keys.sorted(),id: \.self) {
                    key in
                    
                    HStack {
                        
                        ForEach(self.mon[key]!, id : \.self) { item in
                            
                            VStack {
                                
                                if item != 0 {
                                    VStack{
                                        
                                        Text((item == 0) ? "" : "\(item)")
                                            .font(.headline)
                                            .fontWeight(.light)
                                        .layoutPriority(1)
                                        .fixedSize()
                                            
                                            
                                            .onTapGesture {
                                                
                                                if self.mPeriodDates.contains(item)
                                                {
                                                    print("helo")
                                                var tempCompo = self.compo
                                                tempCompo.day = item
                                                let date = self.calendar.date(from: tempCompo)
                                                
                                                self.clickedDate = date!
                                                self.onSelected(date!)
                                                    
                                                }
                                                
                                                
                                        }
                                        
                                    }.padding(5)
                                        .frame(width : self.geo.size.width / 8.5)
                                        .background(Circle().fill(self.mPeriodDates.contains(item) ?
                                            Color(.systemBlue).opacity(0.6) : Color(.secondarySystemFill)))
                                    //                                            .background(Image(systemName : "heart.fill").font(.title).foregroundColor(.blue))
                                } else {
                                    Spacer().frame(width : self.geo.size.width / 8.5, height : 0)
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                
            }
           
        }.frame(width : self.geo.size.width)
        
    }
}


