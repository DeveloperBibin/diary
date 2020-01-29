//
//  ContactSearch.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import Contacts
import Combine

struct ContactSearch: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    @State var searchText : String = ""
    
    @ObservedObject var contactStore : ContactsFetcher = ContactsFetcher()
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var diary : Diary
    
    var body: some View {
        
        return NavigationView {
            
            
            VStack{
                
               
                HStack {
                    
                    Image(systemName : "magnifyingglass")
                        .foregroundColor(Color(.secondaryLabel))
                    TextField("Search", text: self.$contactStore.searchText)
                    
                    if !self.contactStore.searchText.isBlank {
                        Button(action: {
                            self.contactStore.searchText = ""
                        })
                        {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(.tertiarySystemGroupedBackground))
                            
                        }
                        .transition(.scale)
                        
                        
                    }
                    
                }
                .padding(8)
                .background(Color(.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding([.leading], 9)
                .padding(.trailing, self.contactStore.searchText.isEmpty ? 9 : 9)
                
                
                
                if self.contactStore.contactStatus != "denied"
                {
                    
                    if self.contactStore.error == nil
                    {
                       
                        
                        List(contactStore.items){
                            (contact : CNContact) in
                            
                            Button(action: {
                               
                                let tcontact = Contact(context: self.managedObjectcontext)
                                tcontact.id = contact.identifier
                                tcontact.imageDataAvailble = contact.imageDataAvailable
                                tcontact.imageData = contact.imageDataAvailable ? contact.imageData! : Data()
                                tcontact.name = contact.name
                                
                                self.diary.contacts.insert(tcontact)
                              
                           
                                
                            }) {
                                
                                ContactRow(name: contact.name , image: contact.imageDataAvailable ? Image(uiImage: UIImage(data: contact.imageData!)!) : nil)
                            }
                   
                        }
                        
                        
                    }
                }
                    
                else {
                    
                    
                    PermissionDenied(permissin: "Contact")
                    
                }
                Spacer()
                
                
            }
                
                
            .navigationBarTitle(Text("Search Contacts"))
            
        }
        
        
        
        
    }
}

struct ContactSearch_Previews: PreviewProvider {
    static var previews: some View {
        
        ContactSearch(diary: Diary())
            
        
    }
    
    
}

struct SearchBarView: View {
    
    @Binding var searchText : String
    @Binding var editChanged : Bool
    
    var body: some View {
        HStack {
            HStack{
                
                HStack {
                    
                    Image(systemName : "magnifyingglass")
                        .foregroundColor(Color(.secondaryLabel))
                    TextField("Search",text: self.$searchText
                        
                    )
                    
                    if !self.searchText.isEmpty {
                        Button(action: {
                            self.searchText = ""
                        })
                        {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(Color(.secondaryLabel))
                            
                        }
                        .transition(.scale)
                        
                        
                    }
                    
                    
                    
                }
                .padding(7)
            }
                
            .background(Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding([.leading], 9)
            .padding(.trailing, self.searchText.isEmpty ? 9 : 0)
            
            
            
            
        }
        .animation(.interactiveSpring())
        .padding(.top, 10)
    }
}

