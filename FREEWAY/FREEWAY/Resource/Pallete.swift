//
//  Pallete.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit

enum Pallete: String {
    case blue
    case bgGray
    case dividerGray
    case black
    case gray
}

extension Pallete {
    var color: UIColor? {
        return .init(named: self.rawValue)
    }
}
