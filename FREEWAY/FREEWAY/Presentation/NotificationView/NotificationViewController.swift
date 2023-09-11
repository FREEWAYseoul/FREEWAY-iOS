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
    let data: [NotificationDTO]
    
    let notificationsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
        $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.notiCellId)
    }
    
    let notificationTitle = NotificationTitleView()
    
    init(data: [NotificationDTO]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
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

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func isSectionDateToday(section: Int) -> Bool {
        let sectionDate = data[section].date.formatDate(from: "yyyy-MM-dd", to: "yyyy년 M월 d일 E요일")
        return sectionDate?.isToday() ?? false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.notiCellId) as? NotificationTableViewCell else { return UITableViewCell() }
        let isSectionToday = isSectionDateToday(section: indexPath.section)
        let data = data[indexPath.section].notifications[indexPath.row]
        print(data)
        cell.configure(data: data, isToday: isSectionToday)
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let dateSection = NotificationTableSection()
        var date = data[section].date.formatDate(from: "yyyy-MM-dd", to: "yyyy년 M월 d일 E요일")
        date = date!.isToday() ? "(오늘) " + date! : date
        
        dateSection.configure(date: date!)
        dateSection.backgroundColor = .white
        return dateSection
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
