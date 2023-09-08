//
//  Pallete.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/23.
//

import UIKit

enum Pallete: String {
    case customGray
    case customBlack
    case customBlue
    case dividerGray
    case backgroundGray
    case alertBackgroundRed
    case alertIconGray
    case alertDotRed
    case voiceTextBackground
    case updatedTextGray
    case impossibleRed
    case possibleGreen
    case unavailableGray
}

enum LinePallete: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case d1 = "D1"
    case k1 = "K1"
    case k4 = "K4"
}

extension Pallete {
    var color: UIColor? {
        return .init(named: self.rawValue)
    }
}

extension LinePallete {
    var color: UIColor? {
        return .init(named: self.rawValue)
    }
}

