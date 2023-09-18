//
//  DateExtension.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/14.
//

import Foundation

extension Date {
    func getUpdateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd EEEE HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
