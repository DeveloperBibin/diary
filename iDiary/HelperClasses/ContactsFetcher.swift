//
//  ContactsFetcher.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import Foundation
import SwiftUI
import Contacts
import os
import Combine

class ContactsFetcher: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var contacts: [CNContact] = []
    @Published var items : [CNContact] = []
    
    @Published var error: Error? = nil
    
    @Published var contactStatus : String? = nil
    
    @Published var suggestedContacts : [CNContact] = []
    
    @Published var suggestedContact : [CNContact] = []
    
    @Published var searchText : String = ""
    @Published var searchText1 : String = ""
    
    
    
    private var cntcs : AnyPublisher<[CNContact], Never>
    {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{
                input in
                return self.search(input)
        }
        .eraseToAnyPublisher()
    }
    
    
    init() {
        
        self.fetch(stringKeys: [""])
        
        cntcs
            .receive(on : RunLoop.main)
            .map{
                results in
                results
        }
        .assign(to : \.items, on: self)
        .store(in : &cancellable)
    }
    
    
    func search(_ string : String) -> [CNContact]
    {
        return self.contacts.filter({$0.name.lowercased().contains(string.lowercased())})
    }
    
    func fetch(stringKeys : [String]) {
        
        let store = CNContactStore()
        
        print("Requesting Contct acces")
        
        store.requestAccess(for: .contacts)
        {
            (granted, err) in
            
            
            
            
            if granted
                
            {
                
                
                
                os_log("Fetching contacts")
                do {
                    
                    let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                                       CNContactMiddleNameKey as CNKeyDescriptor,
                                       CNContactFamilyNameKey as CNKeyDescriptor,
                                       CNContactImageDataAvailableKey as CNKeyDescriptor,
                                       CNContactImageDataKey as CNKeyDescriptor,
                                       CNContactIdentifierKey as CNKeyDescriptor,
                                       CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor]
                    
                    
                    let requeest = CNContactFetchRequest(keysToFetch: keysToFetch)
                    
                    
                    do {
                        try store.enumerateContacts(with: requeest)
                        {
                            (contact, stop) in
                            DispatchQueue.main.async {
                                self.contacts.append(contact)
                            }
                            
                            
                            
                        }
                    } catch {
                        print("Could not fetch Contacts.")
                    }
                    
                    print("suggested count from fetched class is \(self.suggestedContacts.count)")
                    
                }
                
            }
                
                
            else
            {
                DispatchQueue.main.async {
                    
                    
                    self.contactStatus = "denied"
                    
                    
                }
                
                print("Acces not granted.")
            }
        }
    }
}

extension CNContact: Identifiable {
    
    
    
    var name: String {
        
        let fullName = CNContactFormatter.string(from: self, style: .fullName) ?? "No Name"
        
        return [fullName].filter{ $0.count > 0}.joined(separator: " ")
        
        
        
        
        
    }
}
