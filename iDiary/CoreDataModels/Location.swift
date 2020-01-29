//
//  Location.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class Location : NSManagedObject, Identifiable
{
    @NSManaged public var title : String
    @NSManaged public var subTitle : String
    @NSManaged public var lat : Double
    @NSManaged public var lon : Double
    @NSManaged public var id : Int64
    
}
