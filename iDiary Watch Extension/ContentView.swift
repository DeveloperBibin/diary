//
//  ContentView.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 13/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var streaksData : StreaksData
    var managedObjectContext = (WKExtension.shared().delegate as!
        ExtensionDelegate).persistentContainer.viewContext
    var body: some View {
        VStack{
            
            
            List{
                NavigationLink(destination : AddItemView().environment(\.managedObjectContext, managedObjectContext))
                {
                    QuickAdd()
                    
                }
                
                DailyStreakWatch(dailyNumber : self.$streaksData.dailyNumber)
                // .frame(height : geo.size.height / 2)
                
                WeeklyStreakWatch(weeklyNumber: self.$streaksData.weeklyNumber)
                //.frame(height : geo.size.height / 2)
                
                
            }.listStyle(CarouselListStyle())
                .onAppear()
                    {
                        let defaults = UserDefaults.standard
                        self.streaksData.dailyNumber = defaults.integer(forKey: "dailyNumber")
                        self.streaksData.weeklyNumber = defaults.double(forKey: "weeklyNumber")
                        
                        //
                        do{
                            
                            if let items = try self.managedObjectContext.fetch(Watch.getAllItems()) as? [Watch]
                            {
                                if items.isEmpty
                                {
                                    let watch = Watch(context: self.managedObjectContext)
                                    watch.date = Calendar.current.startOfDay(for: Date())
                                }
                                else
                                {
                                    
                                    if !Calendar.current.isDateInToday(items.first!.date)
                                    {
                                        items.first?.date = Calendar.current.startOfDay(for: Date())
                                        items.first?.contacts.forEach(self.managedObjectContext.delete)
                                        items.first?.deleteds.forEach(self.managedObjectContext.delete)
                                        //contacts.forEach(self.managedObjectcontext.delete)
                                    }
                                }
                                
                                if self.managedObjectContext.hasChanges
                                {try self.managedObjectContext.save()}
                                
                            }
                        } catch {print("error")}
                        
                        
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(streaksData: StreaksData())
    }
}

struct WeeklyStreakWatch: View {
    
    @Binding var weeklyNumber : Double
    var body: some View {
        VStack {
            Text("Weekly Streaks")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack{
                Spacer()
                ProgressCircleView(value: self.$weeklyNumber, maxValue: 7, style: .line, foregroundColor: Color.green, lineWidth: 8)
                    .padding(3)
                    .frame(height : 60)
                    .layoutPriority(2)
                
                HStack{
                    VStack(alignment : .center)
                    {
                        Text("\(Int(self.weeklyNumber)) of 7")
                            .font(.callout)
                            .foregroundColor(Color.green)
                            .fontWeight(.bold)
                        Text("Days")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                .layoutPriority(2)
                Spacer()
                
            }
        }.padding()
    }
}

struct DailyStreakWatch: View {
    
    @Binding var dailyNumber : Int
    var body: some View {
        VStack {
            Text("Daily Streaks")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack{
                Spacer()
                Image(systemName : "flame.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.orange)
                    .padding()
                    .layoutPriority(2)
                
                HStack{
                    VStack(alignment : .center)
                    {
                        Text("\(self.dailyNumber) Day")
                            .font(.callout)
                            .foregroundColor(Color.orange)
                            .fontWeight(.bold)
                        Text("Streak")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
                .layoutPriority(2)
                Spacer()
                
            }
        }.padding()
    }
}

struct QuickAdd : View
{
    var body : some View
    {
        HStack
            {
                Spacer()
                Image(systemName : "plus.circle.fill")
                    .foregroundColor(.green)
                Text("Add to today")
                Spacer()
        }.padding()
    }
}
