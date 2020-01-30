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
    
    
    init() {
        
        UITableView.appearance().separatorStyle = .none
    }
    
    
    var body: some View {
        
        VStack{
            
            
            navigationView(diaries: self.diaries)
                .navigationBarTitle(Text("iDiary"))
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
    var body : some View{
        
        NavigationView
            {
                
                VStack{
                    
                    List
                        {
                            
                            TodayCardThumbnail(data: self.diaries.first!)
                                .onTapGesture {
                                    self.todayCardIsShown.toggle()
                            }
                            
                            if(self.diaries.dropFirst(1).count > 0)
                            {
                                AllEntriesTitle()
                                    .padding(.top)
                                ForEach(self.diaries.dropFirst(1))
                                {
                                    (diary : Diary) in
                                    if !diary.isEmpty
                                    {
                                        NavigationLink(destination : EmptyView())
                                        {DiaryThumbnail(data: diary)}
                                        
                                    }
                                    
                                }.onDelete(perform: delete)
                                     .padding(.trailing, 10)
                                    .listRowInsets(EdgeInsets())
                                   
                            }
                            else
                            {
                                EmptyIndication()
                                
                            }
                            
                    }
                    
                    
                    
                }
                .navigationBarTitle(Text("iDiary"))
        }.background(EmptyView().sheet(isPresented: self.$todayCardIsShown, onDismiss: {
            
            do
            {
                if self.managedObjectcontext.hasChanges && !self.diaries.first!.isEmpty
                {try self.managedObjectcontext.save()
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

struct AllEntriesTitle : View
{
    var body : some View
    {
        VStack( alignment : .leading,spacing : 10){
        HStack{
        Image(systemName : "list.dash")
        .foregroundColor(blueGray400)
        Text("All Entries")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(blueGray400)
        }
        Divider()
        }
    }
}

struct EmptyIndication : View
{
    var body : some View
    {
        HStack{
            Spacer()
            VStack{
                Spacer()
                    .frame(height : UIScreen.main.bounds.size.height / 10)
                Image("empty").resizable()
                    .frame(width :250, height : 250)
                Text("Past diaries will appear here.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(blueGray400)
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
