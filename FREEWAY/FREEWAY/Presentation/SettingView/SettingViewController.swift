//
//  SettingViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import SnapKit
import Then
import UIKit
import MessageUI

final class SettingViewController: UIViewController {
    
    enum SettingTitle: String {
        case locationTermsOfService = "위치기반 서비스 이용약관"
        case privacyPolicy = "개인정보 정책"
        case openSource = "오픈소스 라이브러리"
        case question = "문의하기"
    }
    
    private let settingTitle: [SettingTitle] = [.locationTermsOfService, .privacyPolicy, .openSource, .question]
    
    let settingTitleView = SettingTitleView()
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isScrollEnabled = false
        $0.rowHeight = 48
        $0.backgroundColor = .white
        $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.settingId)
        $0.separatorStyle = .none
        $0.backgroundColor = Pallete.backgroundGray.color
    }
    
    func webViewCellPressed(webURL: String) {
        let viewController = SettingWebViewController()
            viewController.webURL = webURL
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setDefaultNavigationBar()
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

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.settingId) as? SettingTableViewCell else { return UITableViewCell() }
        cell.configureUI(title: settingTitle[indexPath.item].rawValue, isLastCell: indexPath.item == settingTitle.count-1)
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
        case .question:
            touchUpInsideToMailToQuestionPage()
        }
    }
}

private extension SettingViewController {
    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        settingTitleView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.addSubview(settingTitleView)
        settingTitleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(57)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(settingTitleView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    private func touchUpInsideToMailToQuestionPage() {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                let bodyString = """
                                 문의 내용을 입력해주세요
                                 """
                
                composeViewController.setToRecipients(["freeway.seoul@gmail.com"])
                composeViewController.setSubject("[문의]")
                composeViewController.setMessageBody(bodyString, isHTML: false)
                
                self.present(composeViewController, animated: true, completion: nil)
            } else {
                print("메일 보내기 실패")
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                
                sendMailErrorAlert.addAction(goAppStoreAction)
                sendMailErrorAlert.addAction(cancleAction)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
    }
}
