//
//  SearchHistoryBaseView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import Then
import SnapKit

class SearchHistoryBaseView: UIView {
    let searchHistoryTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 57
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
    }
    
    let searchHistoryLabel = UILabel().then {
        //변경 필요
        $0.textColor = Pallete.customGray.color
        $0.text = "최근 검색"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
}

extension SearchHistoryBaseView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
