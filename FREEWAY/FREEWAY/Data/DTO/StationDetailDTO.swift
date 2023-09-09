//
//  StationDetailDTO.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct StationCoordinate: Codable {
    let latitude: String
    let longitude: String
}

struct NextStation: Codable {
    let stationId: Int
    let stationName: String
}

struct PreviousStation: Codable {
    let stationId: Int
    let stationName: String
}

struct Facilities: Codable {
    let elevator: Bool
    let wheelchairLift: Bool
    let disabledToilet: Bool
    let transitParkingLot: Bool
    let unmannedCivilApplicationIssuingMachine: Bool
    let currencyExchangeKiosk: Bool
    let trainTicketOffice: Bool
    let feedingRoom: Bool
}

struct Elevator: Codable {
    let elevatorId: Int
    let elevatorCoordinate: StationCoordinate
    let elevatorStatus: String
    let exitNumber: String
}

struct TransferStation: Codable {
    let stationId: Int
    let lineId: String
}

struct StationDetailDTO: Codable {
    let stationId: Int
    let stationName: String
    let lineId: String
    let lineName: String
    let stationCoordinate: StationCoordinate
    let stationStatus: String
    let stationContact: String
    let stationImageUrl: String
    let nextStation: NextStation?
    let previousStation: PreviousStation?
    let branchStation: String?
    let facilities: Facilities
    let transferStations: [TransferStation]
    let elevators: [Elevator]
}
