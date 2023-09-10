//
//  BottomSheetViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/10.
//

import UIKit
import SnapKit
import Then
import FloatingPanel

final class BottomSheetViewController: FloatingPanelController {
    private let isTouchPassable: Bool
    
    init(isTouchPassable: Bool) {
        self.isTouchPassable = isTouchPassable
        
        super.init(delegate: nil)
        
        setUpView()
    }
    
    private func setUpView() {
        // Appearance
        let appearance = SurfaceAppearance().then {
            $0.cornerRadius = 20.0
            $0.backgroundColor = .white
            $0.borderColor = .clear
            $0.borderWidth = 0
        }
        
        // Surface
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandle.backgroundColor = Pallete.grabberGray.color
        surfaceView.grabberHandleSize = .init(width: 42.5, height: 3.33)
        surfaceView.appearance = appearance
        
        // Backdrop
        backdropView.dismissalTapGestureRecognizer.isEnabled = isTouchPassable ? false : true
        let backdropColor = isTouchPassable ? UIColor.clear : .black
        backdropView.backgroundColor = backdropColor // alpha 설정은 FloatingPanelBottomLayout 델리게이트에서 설정
        
        // Layout
        // 아래에서 계속
        let layout = TouchPassIntrinsicPanelLayout()
        self.layout = layout
        
        // delegate
        delegate = self // 아래에서 계속
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

final class TouchPassIntrinsicPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .half: FloatingPanelLayoutAnchor(absoluteInset: 233, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 124.0, edge: .bottom, referenceGuide: .superview)
            ]
        }
}
extension BottomSheetViewController: FloatingPanelControllerDelegate {

}
