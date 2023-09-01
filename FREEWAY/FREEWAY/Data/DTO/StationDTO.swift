//
//  StationDTO.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct CoordinateDTO: Codable {
    let latitude: String
    let longitude: String
}

struct StationDTO: Codable {
    let stationId: String
    let stationName: String
    let lineId: String
    let coordinate: CoordinateDTO
    let stationStatus: String
    let elevatorsNumber: Int
}
