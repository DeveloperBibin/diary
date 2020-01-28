//
//  Diary.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import CoreData


class Diary : NSManagedObject, Identifiable{
    
    @NSManaged public var title : String
    @NSManaged public var entry : String
    @NSManaged public var date : Date
    @NSManaged public var lastUpdated : Date
    @NSManaged public var isLocked : Bool
    @NSManaged public var isFav : Bool
    @NSManaged public var comments : Bool

    
//    @NSManaged public var imageSet : Set<Image>
//    @NSManaged public var placeSet : Set<Place>
//    @NSManaged public var contactSet : Set<Contact>
    
    
    
}

extension Diary{
    
    
    static func getAllItems() -> NSFetchRequest<Diary>
    {
        let request : NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
        
        
    }
    
    
    
    static func getTwoDays() -> NSFetchRequest<Diary>
    {
        let calendar = Calendar.current
        
        
        var dateFrom = calendar.date(byAdding: .day, value: -2, to: Date())
        dateFrom = calendar.startOfDay(for: dateFrom!)
        
        
        
        let request : NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
               let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", dateFrom! as NSDate, Date() as NSDate)
               request.sortDescriptors = [sortDescriptor]
               request.predicate = predicate
               return request
    }
    
    

    
    static func getItemWithDate() -> NSFetchRequest<Diary>
    {
        
       
        
               let calendar = Calendar.current
               // get the current calendar
               
               let now = Date()
               let today = Date()
           
        
             var dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
               
              let resetOption = UserDefaults.standard.integer(forKey: "reset_time")
               
               switch resetOption {
                            
                        case 0:
                            print("")
                            
                        case 1:
                            let twoAm = calendar.date(bySettingHour: 2, minute: 00, second: 00, of: today)
                            let start = calendar.startOfDay(for: Date())
                            if now >= start && now <= twoAm!
                            {
                               
                               dateFrom = Date.yesterday
                            }
                          
                        case 2:
                            let EightAm = calendar.date(bySettingHour: 8, minute: 00, second: 00, of: today)
                            let start = calendar.startOfDay(for: Date())
                            if now >= start && now <= EightAm!
                            {
                               
                               dateFrom = Date.yesterday
                            }
                        default:
                             print("")
                        }
               
               
               
               
               dateFrom = calendar.startOfDay(for: dateFrom) // eg. 2016-10-10 00:00:00
               let dateTo = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dateFrom)
        
        print("getItemWithDate")
        let request : NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", dateFrom as NSDate, dateTo! as NSDate)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        return request
        
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
