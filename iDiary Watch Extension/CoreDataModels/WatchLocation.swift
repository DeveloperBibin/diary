//
//  WatchLocation.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class WatchLocation : NSManagedObject, Identifiable
{

   @NSManaged public var title : String
   @NSManaged public var subTitle : String
   @NSManaged public var lat : Double
   @NSManaged public var lon : Double
   @NSManaged public var id : Int64
   
    
}
