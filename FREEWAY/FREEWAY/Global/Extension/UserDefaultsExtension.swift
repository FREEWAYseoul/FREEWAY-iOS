//
//  UserDefaultsExtension.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/10.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case searchHistorys
    }
    
    var searchHistory: [StationDetailDTO] {
        get { return array(forKey: Key.searchHistorys.rawValue) as? [StationDetailDTO] ?? [] }
        set { set(newValue, forKey: Key.searchHistorys.rawValue) }
    }
}
