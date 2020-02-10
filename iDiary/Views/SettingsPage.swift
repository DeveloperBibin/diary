//  SettingsPage.swift
//  iDiaryPro
//
//  Created by Bibin Benny on 15/12/19.
//
//  Copyright © 2019 Bibin Benny. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var diaries : FetchedResults<Diary>
    @State  var selectedTime = 0
    @State  var times = ["12 AM Default", "2 AM", "8 AM"]
    
  var maxValue : Double = 7
    @State var currentValue : Double = 0
    
    @State var check : Int?
    
    @State var check2 : Int?
    
   
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    
    
    var checkTime : Bool
    {
        let now = Date()
        let calendar = Calendar.current
        let twoAm = calendar.date(bySettingHour: 8, minute: 00, second: 00, of: Date())
        let start = calendar.startOfDay(for: Date())
        
        if now >= start && now <= twoAm!
        {
            return true
        }
        return false
    }
    
    
    @State var memoryWeekly : Bool = true
    @State var memoryMonthly : Bool = true
    @State var memoryThreeMonhts : Bool = true
    @State var memorySixMonths : Bool = true
    @State var memoryYearly : Bool = true
    
    @State var lockDiary : Bool = false
    
    
    
    @State var contactIds : [String] = []
    @State var placeIds : [Int64] = []
    @State var imageIds : [UUID] = []
    @State var daysInWeek : Double = 0
    
    @State var numberOfImages : Int = 0
    @State var numberOfentries : Int = 0
    @State var numberofLocations : Int = 0
    @State var numberOfContacts : Int = 0
    
    @State var streakDataShown : Bool = false
    
    @State var animationDone : Bool = false
    
    @State var progressBarValue : Double = 0
    
    var body: some View {
        NavigationView
            {
                
                Form(){
        
                    Section(header : Text("Weekly Streaks"))
                    {
                        
                        
                        HStack {
                            Spacer()
                            ZStack {
                                
                                
                                ProgressCircleView(value: self.$progressBarValue,
                                                   maxValue: self.maxValue,
                                                   style: .line,
                                                   foregroundColor: Color(.systemGreen),
                                                   lineWidth: 10)
                                    
                                    .frame(width : 70 ,height: 70)
                                    .padding()
                                if self.daysInWeek == 7 {
                                    if (self.animationDone)
                                    {
                                        VStack{
                                            
                                            
                                            
                                            Image(systemName : "checkmark.seal.fill")
                                                .foregroundColor(Color(.systemGreen))
                                                .font(.title)
                                            
                                        }.animation(.spring())
                                            .transition(.opacity)
                                    }
                                    
                                }
                            }
                            .onAppear()
                                {
                                    
                                    //
                                    if(self.check2 == nil)
                                    {
                                        
                                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
                                            timer in
                                            self.progressBarValue += 0.5
                                            if (self.progressBarValue >= self.daysInWeek) {
                                                timer.invalidate()
                                                withAnimation()
                                                    {self.animationDone = true}
                                                
                                                
                                            }
                                        }
                                    }
                                    
                                    self.check2 = 0
                                    
                            }
                            VStack(alignment : .leading) {
                                HStack(alignment : .firstTextBaseline ) {
                                    Text("\(self.daysInWeek.cleanValue)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                    
                                    Text("of")
                                    Text("\(self.maxValue.cleanValue)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                    Text("days")
                                }
                                
                                Text("of diary entry this week")
                                    .font(.caption)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            .animation(Animation.easeInOut(duration: 2))
                            .transition(.opacity)
                            
                            
                            
                            Spacer()
                        }
                        
                        
                    }
                    
                    
                    Section(header : Text("Stats"))
                    {
                        VStack {
                            
                            VStack(alignment : .center, spacing: 0)
                            {
                                HStack (spacing : 5){
                                    
                                    
                                    Text("\(self.numberOfentries)")
                                        .font(.system(.title, design : .rounded))
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(.greatestFiniteMagnitude)
                                        .foregroundColor(Color(.systemTeal))
                                    
                                    Image(systemName : "calendar")
                                        .font(.headline)
                                        .foregroundColor(Color(.systemTeal))
                                }
                                // .padding(5)
                                
                                Text("Entries")
                                    .font(.caption)
                                    .foregroundColor(Color(.secondaryLabel))
                                Divider()
                                    .padding([.top], 10)
                            }
                            
                            
                            HStack(spacing : 20) {
                                // Spacer()
                                VStack(alignment : .center, spacing: 0)
                                {
                                    HStack(spacing : 5) {
                                        Text("\(numberofLocations)")
                                            .font(.system(.headline, design : .rounded))
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(.leastNormalMagnitude)
                                            .foregroundColor(Color(.systemYellow))
                                        
                                        Image(systemName : "map.fill")
                                            .font(.system(.subheadline, design : .rounded))
                                            .foregroundColor(Color(.systemYellow))
                                    }
                                    Text("Locations")
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                                
                                
                                
                                Divider()
                                VStack(alignment : .center, spacing: 0)
                                {
                                    HStack (spacing : 5){
                                        Text("\(self.numberOfContacts)")
                                            .font(.system(.headline, design : .rounded))
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(.leastNormalMagnitude)
                                            .foregroundColor(Color(.lightGray))
                                        Image(systemName : "person.2.fill")
                                            .font(.system(.subheadline, design : .rounded))
                                            .foregroundColor(Color(.lightGray))
                                    }
                                    // .padding(5)
                                    
                                    Text("People")
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                                
                                Divider()
                                VStack(alignment : .center, spacing: 0)
                                {
                                    HStack (spacing :5){
                                        Text("\(numberOfImages)")
                                            .font(.system(.headline, design : .rounded))
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(.leastNormalMagnitude)
                                            .font(.system(.subheadline, design : .rounded))
                                            .foregroundColor(Color(.systemOrange))
                                        
                                        Image(systemName : "photo")
                                            .foregroundColor(Color(.systemOrange))
                                    }
                                    Text("Images")
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                                
                                
                                //  Spacer()
                                
                            }.padding([.bottom,.top], 10)
                        }.padding([.top], 10)
                        
                    }
                    Section(header : Text("Diary Settings"),footer : Text("The today item will be reset at 12 AM everyday by default")){
                        
                        
                        Picker(selection: $selectedTime, label:
                            
                            HStack {
                                Image(systemName : "clock.fill")
                                    .foregroundColor(Color.orange)
                                Text("Diary Reset time")
                            })
                        {
                            ForEach(0 ..< times.count, id: \.self) {
                                Text(self.times[$0]).tag($0)
                            }
                        }.pickerStyle(DefaultPickerStyle())
                        
                        // Text("Daily diary")
                        
                        
                        
                    }.disabled(self.checkTime)
                    
                    Section()
                        {
                            NavigationLink(destination :
                                
                                Form()
                                    {
                                        Toggle(isOn: self.$memoryWeekly) {
                                            Text("One week ago")
                                        }
                                        
                                        
                                        Toggle(isOn: self.$memoryMonthly) {
                                            Text("One month ago")
                                        }
                                        
                                        Toggle(isOn: self.$memoryThreeMonhts) {
                                            Text("Three Months ago")
                                        }
                                        
                                        Toggle(isOn: self.$memorySixMonths) {
                                            Text("Six months ago")
                                        }
                                        
                                        Toggle(isOn: self.$memoryYearly) {
                                            Text("One year ago")
                                        }
                                        
                                        
                                }
                                
                                
                                
                            ) {
                                HStack {
                                    Image(systemName : "timelapse")
                                        .foregroundColor(Color.green)
                                    Text("Memories")
                                }
                            }
                            
                    }
                    
                    
                    Section(header : Text("Privacy"), footer : Text("Lock iDiary with Touch ID / Face ID"))
                    {
                        HStack
                            {
                                Image(systemName : self.lockDiary ? "lock.fill" : "lock.open.fill")
                                    .foregroundColor( self.lockDiary ? Color(.systemIndigo) : Color.gray)
                                Toggle(isOn: self.$lockDiary) {
                                    Text("Lock diary")
                                }
                        }
                    }
                    
                    Section
                        {
                            HStack
                                {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(Color.blue)
                                    Text("Version")
                                    Spacer()
                                    Text("1.0")
                                        .foregroundColor(Color.secondary)
                            }
                    }
                    
                    
                }
                    
                .onDisappear()
                    {
                        
                        
                        DispatchQueue.main.async {
                            self.onDisppearRoutine()
                        }
                        
                        
                        
                        
                }
                    
                    
                .onAppear()
                    {
                        
                        
                        
                        if(self.check == nil)
                        {
                            DispatchQueue.main.async {
                                self.onAppearRoutine()
                            }
                            
                        }
                        
                        
                        
                        
                } .navigationBarTitle(Text("My Diary"))
                
        } .navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
//    struct SettingsPage_Previews: PreviewProvider {
//        static var previews: some View {
//            //        SettingsPage(memoryWeekly: .constant(true), memoryMonthly: .constant(true), memoryThreeMonhts: .constant(true), memorySixMonths: .constant(true), memoryYearly: .constant(true)).preferredColorScheme( .dark)
//            //SettingsPage(diaries: ).preferredColorScheme( .dark)
//
//        }
//    }
    
        func onDisppearRoutine()
        {
    
            let usData = UserDefaults.standard
    
                             //Settings reset time
                             usData.set(self.selectedTime, forKey: "reset_time")
    
                             //Settings Memories
    
                             usData.set(self.memoryWeekly, forKey: "memory_weekly")
                             usData.set(self.memoryMonthly, forKey: "memory_monthly")
                             usData.set(self.memoryThreeMonhts, forKey: "memory_three_months")
                             usData.set(self.memorySixMonths, forKey: "memory_six_months")
                             usData.set(self.memoryYearly, forKey: "memory_yearly")
    
    
                             usData.set(self.lockDiary, forKey: "lock_diary")
    
    
//                             if(self.data.memoryItem != nil)
//                             {
//                                 if !(self.memoryWeekly)
//                                 {
//                                     if(self.data.memoryDescrption == "1 Week ago")
//                                     {
//                                         self.data.memoryItem = nil
//                                     }
//                                 }
//
//                                 if !(self.memoryMonthly)
//                                {
//                                    if(self.data.memoryDescrption == "1 Month ago")
//                                    {
//                                        self.data.memoryItem = nil
//                                    }
//                                }
//
//                                if !(self.memoryThreeMonhts)
//                                {
//                                    if(self.data.memoryDescrption == "3 Months ago")
//                                    {
//                                        self.data.memoryItem = nil
//                                    }
//                                }
//
//                                if !(self.memorySixMonths)
//                              {
//                                  if(self.data.memoryDescrption == "6 Months ago")
//                                  {
//                                      self.data.memoryItem = nil
//                                  }
//                              }
//
//
//                                if !(self.memorySixMonths)
//                              {
//                                  if(self.data.memoryDescrption == "1 Year ago")
//                                  {
//                                      self.data.memoryItem = nil
//                                  }
//                              }
//
//
//
//                             }
    
        }
    
    
    func onAppearRoutine()
    {
        
        self.check = 0
        
        let ddata = UserDefaults.standard
        
        self.memoryWeekly = ddata.bool(forKey: "memory_weekly")
        self.memoryMonthly = ddata.bool(forKey: "memory_monthly")
        self.memoryThreeMonhts = ddata.bool(forKey: "memory_three_months")
        self.memorySixMonths = ddata.bool(forKey: "memory_six_months")
        self.memoryYearly = ddata.bool(forKey: "memory_yearly")
        
        
        self.selectedTime = ddata.integer(forKey: "reset_time")
        
        self.lockDiary = ddata.bool(forKey: "lock_diary")
        
        
        
        //let tempData : [DiaryModel]
        
        
        
        for diary in self.diaries
            
        {
            //   print(diary.date.description)
            
            if !diary.isEmpty
            {
                if diary.date.isInThisWeek
                {  self.daysInWeek += 1
                    
                    
                }
                
                self.numberOfentries += 1
            }
            
            
            
            if !diary.locations.isEmpty
            {
                diary.locations.map({self.placeIds.append($0.id)})
            }
            
            if !diary.images.isEmpty
            {
                diary.images.map({self.imageIds.append($0.id)})
            }
            
            if !diary.contacts.isEmpty
            {
                diary.contacts.map({self.contactIds.append($0.id)})
            }
            
            
            
            
        }
        self.placeIds = Array(Set(self.placeIds))
        self.numberofLocations = self.placeIds.count
        
        self.imageIds = Array(Set(self.imageIds))
        self.numberOfImages = self.imageIds.count
        
        self.contactIds = Array(Set(self.contactIds))
        self.numberOfContacts = self.contactIds.count
    }
    
}
