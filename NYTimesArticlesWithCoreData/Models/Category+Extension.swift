//
//  Category+Extension.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

extension Category {
    func isRecentEnough() -> Bool {
        guard let date = self.lastUpdated else { return false }
        let acceptableNumberOfHours = 1.0
        let acceptableNumberOfHoursInSeconds = acceptableNumberOfHours * 60 * 60
        return abs(date.timeIntervalSinceNow) < acceptableNumberOfHoursInSeconds
    }
    func populate(from jsonDict: [String: Any]) {
        if let categoryName = jsonDict["section"] as? String {
            self.name = categoryName
        }
        if let dateStr = jsonDict["last_updated"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let date = formatter.date(from: dateStr)
            self.lastUpdated = date
        }
    }
}
