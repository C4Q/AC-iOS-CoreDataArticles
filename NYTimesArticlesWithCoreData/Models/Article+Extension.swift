//
//  Article+Extension.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

extension Article {
    func populate(from dict: [String: Any]) {
        if let title = dict["title"] as? String {
            self.title = title
        }
        if let abstract = dict["abstract"] as? String {
            self.abstract = abstract
        }
        if let url = dict["url"] as? String {
            self.url = url
        }
        if let dateStr = dict["published_date"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let date = formatter.date(from: dateStr)
            self.timestamp = date
        }
        self.isFavorite = false
    }
}
