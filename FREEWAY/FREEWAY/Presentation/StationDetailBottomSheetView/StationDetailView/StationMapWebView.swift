//
//  StationMapWebViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/02.
//

import UIKit
import SnapKit
import Then
import WebKit

final class StationMapWebView: UIView {
    var webURL: String
    private var webView: WKWebView!
    private let GuidanceLabel = UILabel().then {
        $0.text = "손으로 확대, 축소가 가능해요"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.opacity = 0.5
    }
    private var emptyView = EmptyView()
    
    init(_ url: String) {
        webURL = url
        super.init(frame: .zero)
        backgroundColor = Pallete.backgroundGray.color
        if webURL != "" { setWebView() }
        setupLayout()
        self.insetsLayoutMarginsFromSafeArea = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(newURL: String) {
        webURL = newURL      
        if webURL != "" {
            webView?.removeFromSuperview()
            webView = nil
            setWebView()
            setupLayout()
        } else {
            emptyView.isHidden = false
            GuidanceLabel.isHidden = true
        }
    }

}

private extension StationMapWebView {
    func setupLayout() {
        if webURL != "" {
            self.addSubview(webView)
            webView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.bottom.equalToSuperview()
            }
            self.addSubview(GuidanceLabel)
            GuidanceLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-253)
                make.centerX.equalToSuperview()
            }
        } else {
            self.addSubview(emptyView)
            emptyView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.bottom.equalToSuperview()
            }
            emptyView.emptySearchTitleLabel.text = "역사 지도 정보가 없습니다."
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
    }
}
