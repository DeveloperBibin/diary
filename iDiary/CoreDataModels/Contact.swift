//
//  Contact.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class Contact : NSManagedObject, Identifiable
{
    @NSManaged public var name : String
    @NSManaged public var id : String
    @NSManaged public var imageData : Data
    @NSManaged public var imageDataAvailble : Bool
    
}
