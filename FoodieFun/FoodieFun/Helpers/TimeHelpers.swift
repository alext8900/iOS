//
//  TimeHelpers.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct TimeHelpers {
    // for converting the hours from military time to regular time AM PM
    static func calculateAmPm(militaryTime: Int) -> String {
        let militaryTimeRaw: Int
        
        if militaryTime > 1200 {
            militaryTimeRaw = militaryTime - 1200
            let stringFullHour = stringConverter(number: militaryTimeRaw)
            return stringFullHour + " PM"
        } else {
            militaryTimeRaw = militaryTime
            let stringFullHour = stringConverter(number: militaryTimeRaw)
            return stringFullHour + " AM"
        }
    }

    static func stringConverter(number: Int) -> String {
        var stringMilitaryTimeRaw: String
        
        // this is for midnight to 1AM
        if number < 100 {
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "12" + stringMilitaryTimeRaw
        } else if number < 1000 { // will refactor but this is for one digit hour
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "0" + stringMilitaryTimeRaw
        } else {
            stringMilitaryTimeRaw = String(number)
        }
        
        let stringHour = stringMilitaryTimeRaw.prefix(2)
        let stringMinute = stringMilitaryTimeRaw.suffix(2)
        let stringFullHour = stringHour + "." + stringMinute
        return String(stringFullHour)
    }
    
    // use for adding a restaurant
    static func getTime(hour: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: hour)
        guard let timeHourInt = components.hour else { return nil }
        guard let timeMinuteInt = components.minute else { return nil }
        
        var timeHourIntToString: String = ""
        var timeMinuteIntToString: String = ""

        if timeHourInt == 0 {
            timeHourIntToString = String(timeHourInt) + "0"
        } else {
            timeHourIntToString = String(timeHourInt)
        }
        
        if timeMinuteInt == 0 {
            timeMinuteIntToString = String(timeMinuteInt) + "0"
        } else {
            timeMinuteIntToString = String(timeMinuteInt)
        }
        
        // change to String first in order to combine hour and minute as one unit of Int for the backend purpose
        guard let militaryTime = Int(String(timeHourIntToString) + timeMinuteIntToString) else { return nil }
        return militaryTime
    }
    
    // use for Edit a Restaurant
    static func setTime(number: Int) -> String {
        var stringMilitaryTimeRaw: String
        
        // will refactor but this is for midnight to 1AM
        if number < 100 {
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "00" + stringMilitaryTimeRaw
        } else if number < 1000 { // will refactor but this is for one digit hour
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "0" + stringMilitaryTimeRaw
        } else {
            stringMilitaryTimeRaw = String(number)
        }
        
        return stringMilitaryTimeRaw
    }
    
}
