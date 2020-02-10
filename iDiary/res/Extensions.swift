//
//  Extensions.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

extension AnyTransition{
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.scale
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension AnyTransition{
    static var toLeft: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension AnyTransition{
    static var toRight: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}





extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear (date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameDay  (date: Date) -> Bool { isEqual(to: date, toGranularity: .day) }
    func isInSameWeek (date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func dayOfWeek() -> String? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           return dateFormatter.string(from: self).capitalized
           // or use capitalized(with: locale) if you want
       }

    var isInThisYear:  Bool { isInSameYear(date: Date()) }
    var isInThisMonth: Bool { isInSameMonth(date: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(date: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}


extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
    
    var firstName : String {
        return String(components(separatedBy: " ")[0])
    }
    
    var secondName : String {
        
        let stringArray = self.components(separatedBy: " ")
        
        if stringArray.count > 1
        {
            return stringArray[1]
        }
        else
        {   return " "}
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

func splitString (string : String) -> [String]

{
    var string1 : String = ""
    var string2 : String = ""
    
    let characterArray = Array(string)
    
    let center : Int = string.count / 2
    
    var spaceCharacter : Int = 0
    
    for i in center ... string.count
    {
        if characterArray[i] == " "
        {
            spaceCharacter = i
            break
        }
    }
    
    string1 = String(characterArray[0 ... spaceCharacter])
    string2 = String(characterArray[spaceCharacter + 1 ... string.count-1])
    
    return [string1, string2]
    
    
}

func dateDesc(date : Date) -> String  {
    
    var lastMentioned : String = ""
    
    if (date.isInToday)
    { lastMentioned = "Today"}
    else if (date.isInYesterday)
    {lastMentioned = "Yesterday"}
    else if (date.isInThisWeek)
    {lastMentioned = "This Week"}
    else if (date.isInThisMonth)
    {lastMentioned = "This Month"}
    else if (date.isInThisYear)
    {lastMentioned = "This Year"}
    else
    {
        
        var components : DateComponents
           {
               let calendar = Calendar.current
               let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
               return components
           }
        

        var month : String
        {
            switch components.month {

                case 1:
                          return "January"
                case 2:
                          return "February"
                case 3:
                          return "March"
                case 4:
                          return "April"
                case 5:
                          return "May"
                case 6:
                          return "June"
                case 7:
                          return "July"
                case 8:
                          return "August"
                case 9:
                          return "September"
                case 10:
                          return "October"
                case 11:
                          return "November"
                case 12:
                          return "December"

            default:
                return ""
            }

        }

        
           
        
       lastMentioned = "\(month) \(components.day!), \(components.year!)"
        
    }
    
    
    return lastMentioned
}


extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}


extension Double
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
