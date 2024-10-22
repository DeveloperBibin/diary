//
//  SceneDelegate.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import UIKit
import SwiftUI
import WatchConnectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var wcSession : WCSession! = nil
    
    var decoder = JSONDecoder()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if WCSession.isSupported()
        {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
        }
        else
        {
            print("WCSESSION IS NOT SUPPORTED FROM IPHONE")
        }
        
        
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //let contentView = HomeDiary()
        let homeDiary = HomeDiary(session : self.wcSession).environment(\.managedObjectContext, context)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: homeDiary)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        OnAppearCheck.shared.createTodayIfEmpty()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    lazy var operationQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()
    
    
}

extension SceneDelegate : WCSessionDelegate
{
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        print("Rec AC")
        let defaults = UserDefaults.standard
        var array = defaults.stringArray(forKey: "logs") ?? [String]()
        array.append("AC - Recieved at \(Date().description)")
        defaults.set(array, forKey: "logs")
        
        let stringDat = applicationContext["watchData"] as! String
        processingDataFromWatch(stringDat)
        
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Rec MS")
        let defaults = UserDefaults.standard
        var array = defaults.stringArray(forKey: "logs") ?? [String]()
        array.append("MS - Recieved at \(Date().description)")
        defaults.set(array, forKey: "logs")
        
        let stringData = message["watchData"] as! String
        processingDataFromWatch(stringData)
        //watchData
    }
    
    
    func processingDataFromWatch(_ stringData : String)
    {
        operationQueue.addOperation {
            DispatchQueue.main.async
            { //Process Data
            do
            {
                
                let data = Data(stringData.utf8)
                let item = try self.decoder.decode(WatchTemp.self, from: data)
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
                
                context.performAndWait {
                 
                    let addContacts = item.contacts
                    let deleteContacts = item.deletedcontacts.map({$0.id})
                    let addlocations = item.locations
                    let deletedlocation = item.deletedlocations.map({$0.id})
                    let date = item.date
                    
                    var diaries : [Diary]
                    do {
                    try diaries = context.fetch(getDesiredDateRequest(date: date))
                        if diaries.count > 0
                        {
                           
                            //Diary with date EXISTS
                            
                            guard let diary = diaries.first else {return}
                            //ADD contacts
                            for contact in addContacts
                            {
                                if !diary.contacts.contains(where: {$0.id == contact.id})
                                {
                                   
                                    guard let contact = PhoneContacts.getContacts(identifier: contact.id).first else {return}
                                    let tcontact = Contact(context: context)
                                    tcontact.id = contact.identifier
                                    tcontact.imageDataAvailble = contact.imageDataAvailable
                                    tcontact.imageData = contact.imageDataAvailable ? contact.imageData! : Data()
                                    tcontact.name = contact.name
                                    
                                    diary.contacts.insert(tcontact)
                                    
                                }
                            }
                            
                        //Delete deleteds items
                            diary.contacts = diary.contacts.filter({!deleteContacts.contains($0.id)})
                            
                            //Add Location items
                            
                            for location in addlocations
                            {
                                if !diary.locations.contains(where: {$0.title == location.title && $0.subTitle == location.subTitle})
                                {
                                    
                                    let tlocation = Location(context: context)
                                    tlocation.id = location.id
                                    tlocation.lat = location.lat
                                    tlocation.lon = location.lon
                                    tlocation.title = location.title
                                    tlocation.subTitle = location.subTitle
                                    
                                    diary.locations.insert(tlocation)
                                }
                                
                            }
                            
                           diary.locations = diary.locations.filter({!deletedlocation.contains($0.id)})
                            
                        }
                        else
                        {
                            //Diary Does not exist
                        }
                    }
                    catch { print("error")}
                   
                    if context.hasChanges {
                                            do {
                                                try context.save()
                                               
                                            } catch {
                                                
                                                
                                                print("Error")
                                            }
                                        }
                    
                }
            }
            catch
            { print("eRROR PARSING DATA")}
            
        }
            
        }
    }
    
    
}
