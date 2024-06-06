//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 15.05.2024.
//

import Foundation

class DateFormatters {
    static let shared = DateFormatters()
    
    let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    func date(from string: String?) -> Date? {
        guard let dateString = string else {
            return nil
        }
        return dateFormatter.date(from: dateString)
    }
} 
