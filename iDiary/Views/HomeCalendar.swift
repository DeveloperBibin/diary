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
    @State var showOnlyClickedItem : Bool = false
    @State var clickedDiaryDate : Date = Date()

    
    var months = ["January", "February", "March","April","May","June","July","August","September","October","November","December"]
    
    var body: some View {
        
        
        VStack{
            HStack(spacing : 2)
            {
                Button(action : {
                    self.index += -1
                    
                    self.tempDate = Calendar.current.date(byAdding: .month, value: -1, to: self.tempDate)!
                    self.dates = self.diaries.filter({$0.date.isInSameMonth(date: self.tempDate) && !$0.isEmpty}).map({Calendar.current.component(.day, from: $0.date)})
                    self.showOnlyClickedItem = false
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
                    self.showOnlyClickedItem = false
                })
                {
                    Image(systemName : "chevron.right.circle.fill")
                        .font(.title)
                        .padding()
                    
                }
            }
            GeometryReader{
                geo in
                CalendarView(monthIndex: self.index, geo: geo, mdates: self.$dates, clickedDate: self.$clickedDate, onSeleted : {date in
                    
                    self.clickedDiaryDate = date
                    self.showOnlyClickedItem = true
                })
            }
            if !(self.dates.isEmpty)
            {
                List{
                    
                    HomeCalendarListTitle(image: .constant("list.dash"), title: .constant("Diary entries"), showAll: self.$showOnlyClickedItem)
                        .padding(.top)
                    
                    ForEach(self.diaries.filter({$0.date.isInSameMonth(date: self.tempDate)}))
                    {
                        (diary : Diary) in
                        if !diary.isEmpty
                        {
                            if !self.showOnlyClickedItem || diary.date.isInSameDay(date: self.clickedDiaryDate)
                            {
                                NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                                {
                                    DiaryThumbnail(data: diary)
                                    
                                }
                            }
                        }
                    } .onDelete(perform: self.delete)
                        .listRowInsets(EdgeInsets())
                }.listRowBackground(Color(.red))
                
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
        }
        
    }
    func delete(at offsets: IndexSet) {
        //Delete here
        print("Deleted")
    }
}


struct HomeCalendarListTitle : View
{
    
    @Binding var image : String
    @Binding var title : String
    @Binding var showAll : Bool
    var body : some View
    {
        VStack( alignment : .leading,spacing : 10){
            HStack{
                Image(systemName : self.image)
                    .font(.callout)
                Text("\(title.uppercased())")
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Spacer()
                
                if self.showAll{
                Button(action : {
                    self.showAll = false
                })
                {
                    Text("SEE ALL")
                        .foregroundColor(.blue)
                        .font(.callout)
                }
                }
                //.opacity(0.9)
            }
            Divider()
                .padding(.bottom, 10)
        }
    }
}
