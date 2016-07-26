//
//  Utils.swift
//  Binumi_iOS
//
//  Created by Tien Doan on 9/22/15.
//  Copyright © 2015 Tien Doan. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


func showSimpleAlert(title: String, message: String?, presentingController: UIViewController) {
    
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
        
    }))
    
    presentingController.presentViewController(controller, animated: true, completion: nil)
}

func showSimpleAlert(title: String, message: String?, presentingController: UIViewController, confirmBlock:ConfirmBlock) {
    
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
        confirmBlock(confirm: true)
    }))
    
    presentingController.presentViewController(controller, animated: true, completion: nil)
}

//func classNameAsString(obj: Any) -> String {
//    return _stdlib_getDemangledTypeName(obj).componentsSeparatedByString(".").last!
//}

func loadNibs(nibFile:String) -> AnyObject?{
    return NSBundle.mainBundle().loadNibNamed(nibFile, owner: nil, options: nil).first
}

func mainStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
}

func timeFromNow(date:NSDate?) -> String{
    if date == nil {
        return ""
    }
    //let calendar = NSCalendar.currentCalendar()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let unitFlags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
    let dateComponents = calendar!.components(unitFlags, fromDate: date!, toDate: NSDate(), options: .WrapComponents)
    
    let years = dateComponents.year
    let months = dateComponents.month
    let weeks = dateComponents.weekdayOrdinal
    let days = dateComponents.day
    let hours = dateComponents.hour
    let minutes = dateComponents.minute
    let seconds = dateComponents.second
    
    if years > 0 {
        let temp = years < 2 ? "year" : "years"
        return "\(years) \(temp) ago"
    }else if months > 0 {
        let temp = months < 2 ? "month" : "months"
        return "\(months) \(temp) ago"
    }else if weeks > 0 {
        let temp = weeks < 2 ? "week" : "weeks"
        return "\(weeks) \(temp) ago"
    }else if days > 0 {
        let temp = days < 2 ? "day" : "days"
        return "\(days) \(temp) ago"
    }else if hours > 0 {
        let temp = hours < 2 ? "hour" : "hours"
        return "\(hours) \(temp) ago"
    }else if minutes > 0 {
        let temp = minutes < 2 ? "minute" : "minutes"
        return "\(minutes) \(temp) ago"
    }else if seconds > 0 {
        let temp = seconds < 2 ? "second" : "seconds"
        return "\(seconds) \(temp) ago"
    }else{
        return "1s ago"
    }
}
