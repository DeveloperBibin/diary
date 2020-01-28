//
//  OnAppearCheck.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import CoreData
class OnAppearCheck
{
    
    var context : NSManagedObjectContext
    
    static let shared = OnAppearCheck(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext )
    
    private init(context : NSManagedObjectContext) {
        self.context = context
    }
    
    
    func createTodayIfEmpty()
    {
        do {
           if let todayDiary = try self.context.fetch(Diary.getItemWithDate()) as? [Diary]
            {
                if todayDiary.count == 0
                {
                    let diaryItem = Diary(context: self.context)
                    diaryItem.date = Calendar.current.startOfDay(for: Date())
                }
            }
        } catch let error as NSError {
            print("CreateTodatiFEmty Error \(error)")
        }
    }
    
    
    
}
