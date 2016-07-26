//
//  DateTimeFormatters.swift
//  Binumi_iOS
//
//  Created by Tien Doan on 9/22/15.
//  Copyright © 2015 Tien Doan. All rights reserved.
//

import Foundation

struct DateFormatters {
    
    /// Specifies a short style, typically numeric only, such as “11/23/37”.
    static let short = dateFormatterForStyle(.ShortStyle)
    
    /// Specifies a long style, typically with full text, such as “November 23, 1937”.
    static let long = dateFormatterForStyle(.LongStyle)
    
    static func format(format: String) -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return formatter
    }
}

struct TimeFormatters {
    
    /// Specifies a short style, typically numeric only, such as “3:30 PM”.
    static let short = timeFormatterForStyle(.ShortStyle)
    static let formatter = serverDateTimeFormatter()
    
}

struct ServerDateTimeFormatter {
    
    /// Formatter for strings like: 2015-05-28T06:11:54+0000
    static let formatter = serverDateTimeFormatter()
    static let formatterDateOnly = serverDateFormatter()
}

private func dateFormatterForStyle(style: NSDateFormatterStyle) -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateStyle = style
    formatter.timeStyle = NSDateFormatterStyle.NoStyle
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    return formatter
}

private func timeFormatterForStyle(style: NSDateFormatterStyle) -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateStyle = NSDateFormatterStyle.NoStyle
    formatter.timeStyle = style
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    return formatter
}

private func serverDateTimeFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    //    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    //formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    setBackendTimezoneToDateFormatter(formatter)
    return formatter
}

private func serverDateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    //    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    formatter.dateFormat = "MM/dd/yyyy"
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    setBackendTimezoneToDateFormatter(formatter)
    return formatter
}

private func setBackendTimezoneToDateFormatter(formatter: NSDateFormatter) {
    //TODO: set timezone by server
//    if let timezone = AppDelegate.instance().config?.timezone {
//        formatter.timeZone = timezone
//    }
    //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
    //formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
}
