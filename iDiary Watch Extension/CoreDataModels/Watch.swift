//
//  Watch.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 17/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class Watch : NSManagedObject, Identifiable
{
    @NSManaged public var date : Date   
    @NSManaged public var contacts : Set<WatchContact>
    @NSManaged public var deleteds : Set<WatchContact>
    @NSManaged public var locations : Set<WatchLocation>
    @NSManaged public var deletdslocations : Set<WatchLocation>
    //@NSManaged public var id : String
   
    
}

extension Watch
{
    static func getAllItems() -> NSFetchRequest<Watch>
    {
        let request : NSFetchRequest<Watch> = NSFetchRequest<Watch>(entityName: "Watch")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
