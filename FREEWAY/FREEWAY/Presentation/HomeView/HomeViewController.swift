//
//  HomeViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    private let alertButton = InAppAlertButtonView()
    private let homeTitle = HomeTitleView()
    private let textField = HomeSearchTextfieldView()
    private let recentSearchView = RecentSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func safeAreaTopInset() -> CGFloat? {
        if #available(iOS 15.0, *) {
            let topArea = UIApplication.shared.windows.first?.safeAreaInsets.top
            return topArea
        } else {
            return nil
        }
    }
}

private extension HomeViewController {
    
    func setupLayout() {
        view.addSubview(alertButton)
        alertButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 32.09)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(29)
        }
        
        view.addSubview(homeTitle)
        homeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 162)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(72)
        }
        
        view.addSubview(recentSearchView)
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(74)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
}
