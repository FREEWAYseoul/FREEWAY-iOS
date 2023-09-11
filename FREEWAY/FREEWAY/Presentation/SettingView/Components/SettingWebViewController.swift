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
    
    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "icon-arrow-right")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
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
        view.backgroundColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        setWebView()
        setDefaultNavigationBar()
        view.insetsLayoutMarginsFromSafeArea = true
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
    
    func setupLayout() {
    
    view.addSubview(backButton)
    backButton.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(13)
        make.leading.equalToSuperview().offset(10)
    }
    
    backButton.addSubview(backButtonImage)
    backButtonImage.snp.makeConstraints { make in
        make.bottom.top.leading.equalToSuperview()
        make.width.equalTo(24)
    }
    backButtonImage.isUserInteractionEnabled = false
    
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
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
