//
//  FetchContactWithIdentifier.swift
//  iDiary
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//
import Contacts
class PhoneContacts {

    class func getContacts(identifier : String,filter: ContactsFilter = .none) -> [CNContact] {

        var results : [CNContact] = []
        let contactStore = CNContactStore()
       let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                      CNContactMiddleNameKey as CNKeyDescriptor,
                      CNContactFamilyNameKey as CNKeyDescriptor,
                      CNContactImageDataAvailableKey as CNKeyDescriptor,
                      CNContactImageDataKey as CNKeyDescriptor,
       CNContactIdentifierKey as CNKeyDescriptor,
       CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor]

        contactStore.requestAccess(for: .contacts)
        {
            (granted, err) in
           if granted
           {
            do {
                 let containerResults = try contactStore.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch)
                 results.append(containerResults)
                       } catch {
                           print("Error fetching containers")
                       }
                 
            }
            else
           {
            print("No permission")
            }
        }
        return results

    }
}

 enum ContactsFilter {
      case none
      case mail
      case message
  }
 
