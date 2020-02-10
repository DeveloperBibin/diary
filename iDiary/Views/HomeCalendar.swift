//
//  HomeCalendar.swift
//  iDiary
//
//  Created by Bibin Benny on 07/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct HomeCalendar: View {
    
    @State var index : Int = 0
    var diaries : FetchedResults<Diary>
    @State var mdates : [Int: [Diary]] = [:]
    @State var clickedDate : Date = Date()
    @State var dates : [Int] = []
    @State var tempDate : Date = Date()
   
    var months = ["January", "February", "March","April","May","June","July","August","September","October","November","December"]
    
    var body: some View {
        
      
            VStack{
                HStack(spacing : 2)
                    {
                        Button(action : {self.index += -1
                            
                            self.tempDate = Calendar.current.date(byAdding: .month, value: -1, to: self.tempDate)!
                            self.dates = self.diaries.filter({$0.date.isInSameMonth(date: self.tempDate)}).map({Calendar.current.component(.day, from: $0.date)})
                            
                           
                        })
                        {
                            Image(systemName : "chevron.left.circle.fill")
                                .font(.title)
                            .padding()
                        }
                        Spacer()
                        Text(self.months[Calendar.current.component(.month, from: self.tempDate) - 1])
                            .font(.headline)
                        Text(String(Calendar.current.component(.year, from: self.tempDate)))
                        .font(.headline)
                                           .fontWeight(.thin)
                        
                        Spacer()
                        Button(action : {self.index += 1
                            self.tempDate = Calendar.current.date(byAdding: .month, value: 1, to: self.tempDate)!
                            self.dates = self.diaries.filter({$0.date.isInSameMonth(date: self.tempDate)}).map({Calendar.current.component(.day, from: $0.date)})
                        })
                        {
                            Image(systemName : "chevron.right.circle.fill")
                                .font(.title)
                            .padding()
                            
                        }
                }
                GeometryReader{
                    geo in
                    CalendarView(monthIndex: self.index, geo: geo, mdates: self.$dates, clickedDate: self.$clickedDate)
                }
                if !(self.dates.isEmpty)
                {
                List{
                    //ListTitle(image: .constant("list.dash"), title: .constant("Diary entries"))
                    
                    ForEach(self.diaries.filter({$0.date.isInSameMonth(date: self.tempDate)}))
                               {
                                   (diary : Diary) in
                                   if !diary.isEmpty
                                   {NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                                   {DiaryThumbnail(data: diary)}
                                   }
                                   
                                   
                                   
                } .onDelete(perform: self.delete)
                                   .listRowInsets(EdgeInsets())
                }
                               
                }
                else
                {
                    EmptyIndicationSmall(caption: "No items.")
                    
                }
                
                Spacer()
            }
        .onAppear()
            {
                self.dates = self.diaries.filter({$0.date.isInSameMonth(date: Date())}).map({Calendar.current.component(.day, from: $0.date)})
                print(self.dates.count)
        }
        
    }
   func delete(at offsets: IndexSet) {
            //Delete here
            print("Deleted")
        }
}

