//
//  Photo.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData

class Photo : NSManagedObject, Identifiable
{
    @NSManaged public var image : Data
    @NSManaged public var id : UUID
    @NSManaged public var caption : String 
}
