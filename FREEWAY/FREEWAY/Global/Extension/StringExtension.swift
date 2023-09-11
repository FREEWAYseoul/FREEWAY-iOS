//
//  StringExtension.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import Foundation

extension String {
    func formatDate(from sourceFormat: String, to targetFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = targetFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func isToday() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self),
           Calendar.current.isDateInToday(date) {
            return true
        }
        return false
    }
}
