//
//  UIViewExtension.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/17.
//

import UIKit

extension UIView {
    func toImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer (bounds: bounds)
        return renderer.image { rendererContext in
            drawHierarchy (in: bounds, afterScreenUpdates: true)
        }
    }
}
