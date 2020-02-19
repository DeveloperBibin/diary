//
//  WatchToIphoneData.swift
//  iDiary
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//
import SwiftUI

struct WatchTemp : Codable
{
    var date : Date
    var contacts : [TempContacts]
    var locations : [TempLocation]
    var deletedlocations : [TempLocation]
    var deletedcontacts : [TempContacts]
    
}
struct TempContacts : Codable
{
    var name : String
    var id : String
}
struct TempLocation : Codable
{
     var title : String
     var subTitle : String
     var lat : Double
     var lon : Double
     var id : Int64
}
