//
//  ContactOverView.swift
//  iDiary
//
//  Created by Bibin Benny on 01/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct ContactOverView: View {
    
    var contact : Contact
    var image : Image?
    {
        return self.contact.imageDataAvailble ? Image(uiImage: UIImage(data: self.contact.imageData)!) : nil
    }
    var name : String
    {return self.contact.name}
    var diaries : FetchedResults<Diary>
    @State var lastMentioned : String = ""
    @State var  mentions : Int = 0
    
    var body : some View
    {
        NavigationView {
            List() {
                
                titleBarView(image : self.image, name : self.name, mention: self.mentions, lastMentioned: self.lastMentioned)
                .listRowInsets(EdgeInsets())
                
               
                ListTitle(image: .constant("list.dash"), title: .constant("All Entries"))
                    .padding(.top)
                ForEach(self.diaries.filter({$0.contacts.contains(where: {$0.id == self.contact.id})}))
                {
                    (diary : Diary) in
                    NavigationLink(destination : DiaryPage(data: diary, diaryItems: self.diaries))
                        {DiaryThumbnail(data: diary)}
                    
                    
                }.onDelete(perform: delete)
                    .padding(.trailing, 10)
                    .listRowInsets(EdgeInsets())
                
                
             
            }.navigationBarTitle(Text(self.contact.name), displayMode: .inline)
            .onAppear()
                {
                    
                    let temp = self.diaries.filter({$0.contacts.contains(where: {$0.id == self.contact.id})})
                    self.mentions = temp.count
                    print("Counr is \(temp.count)")
                    self.lastMentioned = dateDesc(date: temp.first!.date)
                    
               }
           
        }
    }
    func delete(at offsets: IndexSet) {
        //Delete here
        print("Deleted")
    }
   }

//struct ContactOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactOverView(contact: Contact(), image :Image("bibin")
//            ,name: "Lans remex christopher", diaries: [])
//    }
//}

struct titleBarView : View
{
    var image : Image?
    var name : String
    
    var mention : Int
    var lastMentioned : String
    
    var body : some View
    {
        VStack
                     {
                         //Spacer().frame(height : 50)
                         HStack{
                        GeometryReader
                         {geo in
                             VStack{
                             if self.image != nil
                             {self.image?.resizable().aspectRatio(contentMode: .fill)}
                             else
                             {
                                 Text("\(self.name.first!.description)")
                                     .font(.largeTitle)
                                     .fontWeight(.bold)
                             }
                             }
                                
                            
                             }.frame(width : 100, height : 100)
                            .background(Color(.quaternarySystemFill))
                            .overlay(Circle().stroke(Color(.orange), lineWidth : 2))
                              .clipShape(Circle())
                             Spacer()
                            TextContentView(mentions: "\(self.mention)", lastMentioned: self.lastMentioned)
                            
                         }.padding()
                             .padding([.top, .bottom])
                     }.background(Color(.tertiarySystemGroupedBackground))
        
    }
}


struct TextContentView : View
{
    var mentions : String
    var lastMentioned : String
    
    var body : some View
    {
        VStack(alignment : .trailing)
            {
                
                Text("\(mentions)")
                    .font(.headline)
                    .fontWeight(.bold)
                .foregroundColor(.orange)
                  
                
                Text("Mentions")
                    .font(.caption)
                 .foregroundColor(Color(.secondaryLabel))
                 .padding(.top, 4)
                
                Divider()
                    .padding(.leading, 100)
                Text("\(lastMentioned)")
                    .font(.headline)
                .fontWeight(.bold)
                    .foregroundColor(.orange)
               
                Text("Last mentioned")
                .font(.caption)
                .foregroundColor(Color(.secondaryLabel))
                 .padding(.top, 4)

        }
    }
}
