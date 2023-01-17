//
//  String+Extension.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

enum DateFormat: String {
    case ISO = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dateWithStripReversed = "yyyy-MM-dd"
    case dateWithSlash = "dd/MM/yyyy"
    case year = "yyyy"
    case britishDate = "MMMM dd, yyyy"
}
var setLocale = Locale(identifier: "EN")

extension String {
    func setURL() -> String {
        let string = self
        let imgBaseURL = "https://image.tmdb.org/t/p/original"
        
        return "\(imgBaseURL)\(string)"
    }
    
    func formatedDate(from formatDate: DateFormat, format: DateFormat = .dateWithSlash) -> String {
        if let originalDate: Date = Date().dateFromStringWithFormat(format: formatDate, string: self) {
            let formatter: DateFormatter = DateFormatter()
            formatter.locale = setLocale
            formatter.dateFormat = format.rawValue
            return formatter.string(from: originalDate)
        } else { return self }
    }
}

extension Date{
    func dateFromStringWithFormat(format: DateFormat, string: String) -> Date?{
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "EN")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.date(from: string)
    }
}
