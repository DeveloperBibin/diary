//
//  Contact.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 17/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class WatchContact : NSManagedObject, Identifiable
{
    @NSManaged public var name : String
    @NSManaged public var id : String
   
    
}
