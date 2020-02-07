//
//  LocatinOverView.swift
//  iDiary
//
//  Created by Bibin Benny on 05/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct LocatinOverView: View {
    
    var diaries : FetchedResults<Diary>
    var location : Location
    @State var mentions : Int = 0
    @State var lastMentioned : String = ""
    
    var body: some View {
        NavigationView {
            List() {
                
                
                    
                    LeftMapView(location: self.location)
                        .overlay(LocationTextOverlay(count: self.mentions, dateDesc: self.$lastMentioned))
                        .listRowInsets(EdgeInsets())
                        .frame(height : 150)
                
                
                
                ListTitle(image: .constant("list.dash"), title: .constant("All Entries"))
                    .padding(.top)
                ForEach(self.diaries.filter({$0.locations.contains(where: {$0.id == self.location.id})}))
                {
                    (diary : Diary) in
                    NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                    {DiaryThumbnail(data: diary)}
                    
                    
                }
                .onDelete(perform: delete)
                .padding(.trailing, 10)
                .listRowInsets(EdgeInsets())
                
                
                
            }.navigationBarTitle(Text(location.title), displayMode: .inline)
                .onAppear()
                    {
                        let temp = self.diaries.filter({$0.locations.contains(where: {$0.id == self.location.id})})
                        self.mentions = temp.count
                        self.lastMentioned = dateDesc(date: temp.first!.date)
                        
                        
                        
            }
            
        }
        
    }
    func delete(at offsets: IndexSet) {
        //Delete here
        print("Deleted")
    }
}

//struct LocatinOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocatinOverView(diaries: [], location: Location() )
//    }
//}


struct LocationTextOverlay: View {
    
    var count : Int
    @Binding var dateDesc : String
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.7),Color.black.opacity(0.5),Color.black.opacity(0.4),Color.black.opacity(0.1), Color.black.opacity(0)]),
            startPoint: .trailing,
            endPoint: .leading)
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Rectangle().fill(gradient)
            VStack(alignment : .trailing)
            {
                
                
                VStack(alignment : .trailing)
                {
                    
                    Text("\(count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    
                    Text("Mentions")
                        .font(.caption)
                        .foregroundColor(Color(.white))
                        .padding(.top, 4)
                    
                    Divider()
                        .padding(.leading, 100)
                    Text("\(dateDesc)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Last mentioned")
                        .font(.caption)
                        .foregroundColor(Color(.white))
                        .padding(.top, 4)
                    
                }
                
            }
            .padding()
        }
        .foregroundColor(.white)
        .allowsHitTesting(false)
    }
}
