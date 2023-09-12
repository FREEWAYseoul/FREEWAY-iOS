//
//  SettingWebViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import UIKit
import SnapKit
import Then
import WebKit

final class SettingWebViewController: UIViewController {
    
    var webURL: String = ""
    private var webView: WKWebView!
    private var observation: NSKeyValueObservation?
    
    var settingWebTitleView = SettingTitleView()
    
    lazy var progressView =  UIProgressView(progressViewStyle: .bar).then {
        $0.progressTintColor = Pallete.customBlue.color
        $0.backgroundColor = .white
        $0.progress = 0.0
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setWebView()
        setDefaultNavigationBar()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        observation = nil
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

private extension SettingWebViewController {
    func configure() {
        view.backgroundColor = .white
        settingWebTitleView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        settingWebTitleView.seperator.removeFromSuperview()
    }
    
    func setupLayout() {
    
    view.addSubview(settingWebTitleView)
    settingWebTitleView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
        make.leading.trailing.equalToSuperview()
        make.height.equalTo(50)
    }
    
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(settingWebTitleView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2.5)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        let AppInfoURL = URL(string: webURL)
        let AppInfoRequest = URLRequest(url: AppInfoURL!)
        DispatchQueue.main.async {
            self.webView.load(AppInfoRequest)
        }
        observation = webView.observe(\WKWebView.estimatedProgress, options: .new) { _, change in
            self.progressView.progress = Float(self.webView.estimatedProgress)
            if self.progressView.progress == 1 { self.progressView.progressTintColor = .white }
        }
    }
}
