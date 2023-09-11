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
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
        $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.notiCellId)
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
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
    }
    
    func setupLayout() {
        view.addSubview(notificationTitle)
        notificationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(59)
        }
        
        view.addSubview(notificationsTableView)
        notificationsTableView.snp.makeConstraints { make in
            make.top.equalTo(notificationTitle.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.notiCellId) as? NotificationTableViewCell else { return UITableViewCell() }
        let data = data[indexPath.section].notifications[indexPath.row]
        print(data)
        cell.configure(data: data, isToday: false, date: "")
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateSection = NotificationTableSection()
        let date = data[section].date
        dateSection.configure(date: date)
        return dateSection
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
