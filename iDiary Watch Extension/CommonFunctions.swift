//
//  CommonFunctions.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 19/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import WatchConnectivity

func sendDataToiPhone(_ message : Watch)
{
    
    let txt = WatchTemp(date: message.date, contacts: message.contacts.map({TempContacts(name: $0.name, id: $0.id)}), locations: message.locations.map({TempLocation(title: $0.title, subTitle: $0.subTitle, lat: $0.lat, lon: $0.lon, id: $0.id)}), deletedlocations: message.deletdslocations.map({TempLocation(title: $0.title, subTitle: $0.subTitle, lat: $0.lat, lon: $0.lon, id: $0.id)}), deletedcontacts: message.deleteds.map({TempContacts(name: $0.name, id: $0.id)}))
    
    let session = WCSession.default
    let encoder = JSONEncoder()
    
    do{
                let data = try encoder.encode(txt)
                let stringData = String(data : data, encoding: .utf8)
                let message = ["watchData": stringData ?? ""]
                
                if session.isReachable{
                                        session.sendMessage(message, replyHandler: nil) { (error) in
                                         
                                         print(error.localizedDescription)
                                         
                                         }}
                                     else
                                     {
                                     do{
                                         try session.updateApplicationContext(message)
                                     }catch let err as NSError
                                     {
                                         print("Error sending Context : \(err)")
                                     }
                                     }
        
        print("Date sent to iphone")
            }catch
            {print("Error")}
}
