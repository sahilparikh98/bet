//
//  NSDate+convertToString.swift
//  bet
//
//  Created by Apple on 7/28/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
    }
}