//
//  SettingViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import SnapKit
import Then
import UIKit

final class SettingViewController: UIViewController {
    enum SettingTitle: String {
        case locationTermsOfService = "위치기반 서비스 이용약관"
        case privacyPolicy = "개인정보 정책"
        case openSource = "오픈소스 라이브러리"
        case question = "문의하기"
    }
    
    private let settingTitle: [SettingTitle] = [.locationTermsOfService, .privacyPolicy, .openSource, .question]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 47
        tableView.backgroundColor = .white
        return tableView
    }()
    
    func webViewCellPressed(webURL: String) {
        let viewController = SettingWebViewController()
            //viewController.webURL = webURL
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Pallete.backgroundGray.color
        setTableViewLayout()
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
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.settingId) as? SettingTableViewCell else { return UITableViewCell() }
        cell.configureUI(title: settingTitle[indexPath.item].rawValue)
        cell.backgroundColor = .white
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch settingTitle[indexPath.row] {
        case .locationTermsOfService:
            webViewCellPressed(webURL: "https://desert-enthusiasm-9d0.notion.site/53817fd469a24dcb8ca2f1094002a39c?pvs=4")
        case .privacyPolicy:
            webViewCellPressed(webURL: "https://desert-enthusiasm-9d0.notion.site/077c4410b0964540b09bc735bdb93634?pvs=4")
        case .openSource:
            webViewCellPressed(webURL: "https://desert-enthusiasm-9d0.notion.site/2e50ba5f720b4d77a9a7c1e84b529867?pvs=4")
        case .question: break
        }
    }
}

private extension SettingViewController {
    func setTableViewLayout() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.settingId)
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
