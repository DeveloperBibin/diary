//
//  ContactList.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 17/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import Contacts
struct ContactList: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @ObservedObject var watch : Watch
    var contacts = ContactsFetcher()
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    var body: some View {
        VStack {
            
            List(contacts.contacts)
            {
                (contact : CNContact) in
                contactRow(watch: self.watch, contact: contact).padding([.top, .bottom])
               
            }
//             
        
        }
    }
}


struct contactRow : View{
    @Environment(\.managedObjectContext) var managedObjectcontext
    @ObservedObject var watch : Watch
    var contact : CNContact
    @State var onClicked : Bool = false
    var body : some View
    {
        HStack
            {
                Image(systemName: self.onClicked ? "person.crop.circle.badge.checkmark" :"person.crop.circle.badge.plus")
                    .foregroundColor(self.onClicked ? .green : .secondary)
                Text("\(contact.name)").lineLimit(1)
                    .font(.headline)
                
            } .onTapGesture {
                     
                print("\(self.contact.identifier)")
                if self.watch.contacts.contains(where: {$0.id == self.contact.identifier})
                {
                    //Item already added, do remove it.
                    let item = self.watch.contacts.first(where: {$0.id == self.contact.identifier})
                    self.watch.contacts = self.watch.contacts.filter({$0.id != self.contact.identifier})
                    //self.watch.contacts.remove()
                    if !self.watch.deleteds.contains(item!)
                    {self.watch.deleteds.insert(item!)}
                
                }
                else
                {
                    //item isnt avaible do add it
                    let item = WatchContact(context: self.managedObjectcontext)
                    item.id = self.contact.identifier
                    item.name = self.contact.name
                    self.watch.contacts.insert(item)
                    //Remove from existing delteds if applicable
                    
                    if self.watch.deleteds.contains(where: {$0.id == self.contact.identifier})
                    {
                        self.watch.deleteds = self.watch.deleteds.filter({$0.id != self.contact.identifier})
                    }
                }
                self.onClicked.toggle()
                self.saveToCoreDate()
                       
                   }
        .onAppear()
                {
                    let contacts = self.watch.contacts
                    self.onClicked = contacts.contains(where: {$0.id == self.contact.identifier})
        }
       
    }
    func saveToCoreDate()
    {
        do {
            try self.managedObjectcontext.save()
        } catch {
            print(error)
        }
      sendDataToiPhone(self.watch)
        
    }
}
