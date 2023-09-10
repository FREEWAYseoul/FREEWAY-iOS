//
//  NotificationDataDTO.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct NotificationDataDTO: Codable {
    let summary: String
    let content: String
    let time: String
}

struct NotificationDTO: Codable {
    let date: String
    let notifications: [NotificationDataDTO]
}
