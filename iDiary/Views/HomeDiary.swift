//
//  ContentView.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeDiary: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @FetchRequest(fetchRequest: Diary.getAllItems()) var diaries : FetchedResults<Diary>
    
    @State var showSearchView : Bool = false
    @State var settingsPageShown : Bool = false
    @State var selectedViewOptin : Int = 0
    @State var viewOptions = [ "list.bullet","calendar"]
    
    init() {
        
        UITableView.appearance().separatorStyle = .none
    }
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                if !self.showSearchView
                {
                    VStack{
                        if selectedViewOptin == 0
                        {
                            navigationView(diaries: self.diaries, showSearchView: self.$showSearchView)
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
                            .shadow(radius: 5)
                           
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
        HomeDiary()
    }
}


struct navigationView : View
{
    @State var todayCardIsShown : Bool = false
    @Environment(\.managedObjectContext) var managedObjectcontext
    var diaries : FetchedResults<Diary>
    @Binding var showSearchView : Bool
    var body : some View{
        
        
        VStack{
            
            List
                {
                    
                    TodayCardThumbnail(data: self.diaries.first!)
                        .onTapGesture {
                            self.todayCardIsShown.toggle()
                    }
                    
                    ListTitle(image: .constant("list.dash"), title: .constant("All Entries"))
                        .padding(.top)
                    ForEach(self.diaries)
                    {
                        (diary : Diary) in
                        if !diary.isEmpty
                        {NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                        {DiaryThumbnail(data: diary)}
                        }
                        
                        
                        
                    } .onDelete(perform: delete)
                        .listRowInsets(EdgeInsets())
                    
                    //.padding(.trailing, 10)
                    
                    
                    
            }
        }
        .background(EmptyView().sheet(isPresented: self.$todayCardIsShown, onDismiss: {
            
            do
            {
                if self.managedObjectcontext.hasChanges && !self.diaries.first!.isEmpty
                {
                    
                    
                    try self.managedObjectcontext.save()
                    print("Saved")
                    return
                }
                
                if self.diaries.first!.isEmpty && !(self.diaries.first?.objectID.isTemporaryID)! && self.managedObjectcontext.hasChanges
                {
                    try self.managedObjectcontext.save()
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
        //Delete here
        print("Deleted")
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
                Text("\(title.uppercased())")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                //.opacity(0.9)
            }
            Divider()
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
