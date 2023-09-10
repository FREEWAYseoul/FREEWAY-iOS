//
//  NotificationDataDTO.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct NotificationDTO: Codable {
    let summary: String
    let content: String
    let time: String
}

struct NotificationDataDTO: Codable {
    let date: String
    let notifications: [NotificationDTO]
}
