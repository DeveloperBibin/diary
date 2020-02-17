//
//  ContentView.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import UIKit
import WatchConnectivity

struct HomeDiary: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @FetchRequest(fetchRequest: Diary.getAllItems()) var diaries : FetchedResults<Diary>
    
    @State var showSearchView : Bool = false
    @State var settingsPageShown : Bool = false
    @State var selectedViewOptin : Int = 0
    @State var viewOptions = [ "list.bullet","calendar"]
    var session : WCSession
    
    
    init(session : WCSession) {
        
        UITableView.appearance().separatorStyle = .none
        self.session = session
    }
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                if !self.showSearchView
                {
                    VStack{
                        if selectedViewOptin == 0
                        {
                            navigationView(diaries: self.diaries, showSearchView: self.$showSearchView, session: self.session)
                                .transition(.move(edge: .leading))
                                .animation(.default)
                            
                        }
                        else
                        {
                            HomeCalendar(diaries : self.diaries)
                                .transition(.toRight)
                                .animation(.default)
                            
                        }
                    }
                    .transition(.move(edge: .leading))
                    .animation(.default)
                    .overlay(VStack
                        {
                            Spacer()
                            HStack{
                                Spacer()
                                Picker(selection: $selectedViewOptin, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                                    ForEach(0 ..< self.viewOptions.count)
                                    {
                                        Image(systemName: self.viewOptions[$0])
                                        
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                
                                Spacer()
                            } .padding()
                            
                    })
                }
                else
                {
                    SearchViiew(diaries: self.diaries)
                        .transition(.toRight)
                        .animation(.default)
                    
                }
            }.background(EmptyView() .sheet(isPresented: self.$settingsPageShown)
            {
                SettingsView(diaries: self.diaries)
            })
                
                .navigationBarTitle(self.showSearchView ? Text("Search") : Text("iDiary"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action : {self.settingsPageShown.toggle()})
                    {
                        Image(systemName : "person.crop.circle.fill")
                            .font(.headline)
                            .animation(.default).padding()
                    }
                    ,trailing: Button(action: {
                        
                        self.showSearchView.toggle()}) {
                            Image(systemName : self.showSearchView ? "xmark.circle.fill" : "magnifyingglass.circle")
                                .font(.headline)
                                .animation(.default).padding()
                })
        }
        
    }
}

struct HomeDiary_Previews: PreviewProvider {
    static var previews: some View {
        HomeDiary(session: WCSession.default)
    }
}


struct navigationView : View
{
    @State var todayCardIsShown : Bool = false
    @Environment(\.managedObjectContext) var managedObjectcontext
    var diaries : FetchedResults<Diary>
    @Binding var showSearchView : Bool
    @State var weekNumber : Double = 0
    @State var dayNumber : Int = 0
    @State var todayItemShwon = false
    var session : WCSession
    
    var body : some View{
        
        
        VStack{
            
            List
                {
                    
                    ListTitle(image: .constant("flame.fill"), title: .constant("Streaks"))
                        .padding(.top)
                    
                    HomeDiaryStreakView(weekNumber: self.$weekNumber, dayNumber: self.$dayNumber)
                        .frame(height : UIScreen.main.bounds.size.height / 6)
                    
                    
                    ListTitle(image: .constant("list.dash"), title: .constant("Diary Entries"))
                        .padding(.top)
                    
                    ForEach(self.diaries)
                    {
                        
                        (diary : Diary) in
                        if diary.date.isInToday
                        {
                            TodayCardThumbnail(data: self.diaries.first!)
                                .onTapGesture {
                                    self.todayCardIsShown.toggle()
                            }
                            .padding([.trailing, .leading], 8)
                            
                            
                            Divider().padding([.trailing, .leading], 8)
                            // .padding([ .bottom], 12)
                        }
                        else
                        {
                            if !diary.isEmpty
                            {NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                            {DiaryThumbnail(data: diary)
                                
                                }
                            }
                        }
                        
                        
                        
                    } .onDelete(perform: delete)
                        .listRowInsets(EdgeInsets())
                    
            }
            .onAppear()
                {
                    self.updateStreakValues()
                    
            }
            
        }
        .background(EmptyView().sheet(isPresented: self.$todayCardIsShown, onDismiss: {
            
            do
            {
                if self.managedObjectcontext.hasChanges && !self.diaries.first!.isEmpty
                {
                    
                    
                    try self.managedObjectcontext.save()
                    print("Saved")
                    self.updateStreakValues()
                    return
                }
                
                if self.diaries.first!.isEmpty && !(self.diaries.first?.objectID.isTemporaryID)! && self.managedObjectcontext.hasChanges
                {
                    try self.managedObjectcontext.save()
                    self.updateStreakValues()
                    print("Saved")
                }
            }
            catch let error as NSError
            {
                print("Errr from saving data. \(error)")
            }
        })
        {
            TodayCard(diary: self.diaries.first!)
                .environment(\.managedObjectContext, self.managedObjectcontext)
            
        })
        
    }
    
    func delete(at offsets: IndexSet) {
        
        let index = offsets.first!
        let listItem = self.diaries[index]
        if listItem == self.diaries.first
        {
            self.emptyFirstItem()
            self.saveDiaryToCoreData()
            self.updateStreakValues()
        }
        else
        {
            self.deleteDiaryItem(item: listItem)
        }
        
    }
    
    func emptyFirstItem()
    {
        guard let diary = self.diaries.first else {return}
        diary.title = ""
        diary.entry = ""
        diary.contacts.forEach(self.managedObjectcontext.delete)
        diary.locations.forEach(self.managedObjectcontext.delete)
        diary.images.forEach(self.managedObjectcontext.delete)
        diary.isFav = false
    }
    
    func deleteDiaryItem(item : Diary)
    {
        self.managedObjectcontext.delete(item)
        self.saveDiaryToCoreData()
        self.updateStreakValues()
        
    }
    func saveDiaryToCoreData(){
        do
        {
            try self.managedObjectcontext.save()
        }
        catch let error as NSError
        {
            print("Error \(error)")
        }
    }
    
    func updateStreakValues()
    {
        DispatchQueue.global(qos: .background).async {
            self.weekNumber =  Double(self.diaries.filter({!$0.isEmpty && $0.date.isInSameWeek(date: Date())}).count)
            
            var tempItem = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            
            self.dayNumber = 0
            
            
            for item in self.diaries
            {
                tempItem = Calendar.current.date(byAdding: .day, value: -1, to: tempItem!)!
                if item.date.isInSameDay(date: tempItem!) && !item.isEmpty
                {
                    
                    self.dayNumber += 1
                    tempItem = item.date
                    print("Here \(self.dayNumber) \(item.date) \(item.isEmpty)")
                }
                else
                {
                    let message = ["dayNumber" : self.dayNumber.description, "WeeklyNumber" : self.weekNumber.description]
                               
                               if self.session.isReachable
                               {
                                   self.WcSendMessage(message: message)
                                   print("Send Message")
                               }
                               else
                               {
                                   self.WcUpdateContext(message: message)
                                   print("Send Message")
                               }
                    
                    return}
            }
            
           
            
            
        }
        
        
    }
    
    func WcSendMessage(message : [String : Any])
    {
        print("Sending message \(message["dayNumber"])")
        self.session.sendMessage(message, replyHandler: nil) { (error) in
        
        print(error.localizedDescription)
        
        }
    }
    func WcUpdateContext(message : [String : Any])
    {
        print("Sending update \(message["dayNumber"])")
        do{
            try self.session.updateApplicationContext(message)
        }catch let err as NSError
        {
            print("Error sending Context : \(err)")
        }
    }
}

struct ListTitle : View
{
    
    @Binding var image : String
    @Binding var title : String
    var body : some View
    {
        VStack( alignment : .leading,spacing : 10){
            HStack{
                Image(systemName : self.image)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(title.uppercased())")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                //.opacity(0.9)
            }
            .padding(.bottom, 10)
        }
    }
}

struct EmptyIndication : View
{
    var caption : String = "Past diaries will appear here."
    var body : some View
    {
        HStack{
            Spacer()
            VStack{
                Spacer()
                    .frame(height : UIScreen.main.bounds.size.height / 10)
                Image("emptycal").resizable()
                    .frame(width :250, height : 250)
                Text("\(self.caption)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(blueGray400)
            }
            Spacer()
        }
    }
}

struct EmptyIndicationSmall: View
{
    var caption : String = ""
    var body : some View
    {
        HStack{
            Spacer()
            VStack{
                Spacer()
                
                Image("emptycal").resizable()
                    .frame(width :150, height : 150)
                Text("\(self.caption)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(blueGray400)
                Spacer()
            }
            Spacer()
        }
        
    }
}
func CreteSSCEntryDiary()
{
    let activity = NSUserActivity(activityType: SiriShortCutsNames.writeDiary)
    activity.title = "Write diary entry today"
    activity.isEligibleForSearch = true
    activity.isEligibleForPrediction = true
    UIApplication.shared.userActivity = activity
    activity.becomeCurrent()
    
}
