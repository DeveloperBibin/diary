//
//  HostingController.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 13/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import WatchConnectivity

class HostingController: WKHostingController<ContentView> {
    var wcSession : WCSession! = nil
    var data : StreaksData = StreaksData()
    
    override init() {
        super.init()
        if WCSession.isSupported()
        {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
            print("Activated")
        }
        else
        {
            print("WcSession Not Supported")
        }
    }
    override var body: ContentView {
        return ContentView(streaksData: self.data)
    }
}

extension HostingController : WCSessionDelegate
{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.SyncRecievedData(message: message)
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
            
        self.SyncRecievedData(message: applicationContext)
        
    }
    
    
    func SyncRecievedData(message : [String : Any])
    {
        let dayNumber = message["dayNumber"] as! String
               let weeklyNumber = message["WeeklyNumber"] as! String
        let defaults = UserDefaults.standard
               DispatchQueue.main.async {
                   print("Recieved")
                   self.data.dailyNumber = Int(dayNumber)!
                   self.data.weeklyNumber = Double(weeklyNumber)!
                defaults.set(Int(dayNumber)!, forKey: "dailyNumber")
                defaults.set(Double(weeklyNumber)!, forKey: "weeklyNumber")
               }
        
    }
    
    
}
