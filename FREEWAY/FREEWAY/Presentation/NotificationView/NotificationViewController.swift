//
//  NotificationViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/10.
//

import UIKit
import SnapKit
import Then

final class NotificationViewController: UIViewController {
    let data = MockData.mockNotiDTO
    
    let notificationsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 57
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
    }
    
    let notificationTitle = NotificationTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
    }
    
    //MARK: Contraints
    private func safeAreaTopInset() -> CGFloat? {
        if #available(iOS 15.0, *) {
            let topArea = UIApplication.shared.windows.first?.safeAreaInsets.top
            return topArea
        } else {
            return nil
        }
    }
    
    private func setDefaultNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: Action
    @objc func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

private extension NotificationViewController {
    func configure() {
        view.backgroundColor = .white
        notificationTitle.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.addSubview(notificationTitle)
        notificationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(59)
        }
    }
}
