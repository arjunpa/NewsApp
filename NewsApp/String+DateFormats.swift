//
//  String+DateFormats.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension String {
    
    private static let dateFormatter = DateFormatter()
    
    enum Formats: String {
        case zulu = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }
    
    func formatToDate(with format: Formats) -> Date? {
        let dateFormatter = type(of: self).dateFormatter
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
