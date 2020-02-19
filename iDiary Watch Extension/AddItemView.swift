//
//  AddItemView.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 17/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Watch.getAllItems()) var watchItems : FetchedResults<Watch>
    var body: some View {
        Form {
            
            Section(header : Text("Add items to today entry").foregroundColor(.secondary)){
                
                AddContactsButton(watchItems : self.watchItems)
                AddLocation(watch : self.watchItems.first!)
            }
            Section(header : Text("Added Contacts").foregroundColor(.secondary)){
                ContactListItems(watch: self.watchItems.first!)
            }
            Section(header : Text("Added Locations").foregroundColor(.secondary)){
                           LocationListItems(watch: self.watchItems.first!)
                       }
            
              
           
            .navigationBarTitle(Text("Quick Add"))
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}

struct deletedItems : View
{
    @ObservedObject var watch : Watch
    
    var body : some View
    {
        ForEach(Array(watch.deleteds))
        {
            contact in
            Text("\(contact.name)")
        }
    }
}

struct deletedItemsLocation : View
{
    @ObservedObject var watch : Watch
    
    var body : some View
    {
        ForEach(Array(watch.deletdslocations))
        {
            contact in
            Text("\(contact.title)")
        }
    }
}

struct ContactListItems : View
{
    @ObservedObject var watch : Watch
    @Environment(\.managedObjectContext) var managedObjectContext
    var body : some View
    {
    ForEach(Array(watch.contacts))
      {
          contact in
          Text("\(contact.name)")
        }.onDelete(perform: delete)
                  
        
    }
    
    func delete(at offsets: IndexSet) {
        
        let index = offsets.first!
        let listItem = Array(self.watch.contacts)[index]
        self.deleteContact(listItem)
        self.saveContext()
        
    }
    
    func deleteContact(_ item : WatchContact)
    {
        self.watch.contacts.remove(item)
        self.watch.deleteds.insert(item)
        
        
    }
    
    func saveContext()
    {
        do
        {
            try self.managedObjectContext.save()
        }
        catch
        {
            print("Errir")
        }
        
        sendDataToiPhone(self.watch)
    }
    
}

struct LocationListItems : View
{
    @ObservedObject var watch : Watch
    @Environment(\.managedObjectContext) var managedObjectContext
    var body : some View
    {
    ForEach(Array(watch.locations))
      {
          contact in
          Text("\(contact.title)")
        }.onDelete(perform: delete)
                  
        
    }
    
    func delete(at offsets: IndexSet) {
        
        let index = offsets.first!
        let listItem = Array(self.watch.locations)[index]
        self.deleteLocation(listItem)
        self.saveContext()
        
    }
    
    func deleteLocation(_ item : WatchLocation)
    {
        self.watch.locations.remove(item)
        self.watch.deletdslocations.insert(item)
        
    }
    
    func saveContext()
    {
        do
        {
            try self.managedObjectContext.save()
        }
        catch
        {
            print("Errir")
        }
        sendDataToiPhone(self.watch)
    }
    
}

struct AddContactsButton : View
{
    var watchItems : FetchedResults<Watch>
   
    var body : some View
    {
        NavigationLink(destination : ContactList(watch: self.watchItems.first!))
           {
         
            HStack{
               Image(systemName: "person.crop.circle")
                   .foregroundColor(Color.green)
                Text("Add Contact")
                Spacer()
                Image(systemName : "chevron.right")
                    .foregroundColor(.secondary)
            }.padding()
        
           }
    }
}

struct AddLocation : View
{
    @ObservedObject var watch : Watch
    var body : some View
    {
        NavigationLink(destination : LocationView(watch : self.watch)){
                
                     HStack{
                     Image(systemName: "mappin.and.ellipse")
                         .foregroundColor(Color.orange)
                     Text("Add Location")
                        Spacer()
                      Image(systemName : "chevron.right")
                        .foregroundColor(.secondary)
            }.padding()
                     }
    }
}
