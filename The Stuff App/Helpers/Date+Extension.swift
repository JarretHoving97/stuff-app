//
//  Date+Extension.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Foundation

extension Date {
    
    public func isInPastOrToday(date: Date?) -> Bool {
        guard let date else { return true }
        return date.isInSame(.day, as: self) || self >= date
    }
    
    public func isInSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: component)
    }
}
