//
//  StationDetailDTO.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct StationDetailDTO: Codable {
    let stationId: String
    let stationName: String
    let lineId: String
    let lineName: String
    let stationCoordinate: CoordinateDTO
    let stationStatus: String
    let stationContact: String
    let stationImageUrl: String
    let nextStation: NextPreviousStationDTO
    let previousStation: NextPreviousStationDTO
    let branchStation: NextPreviousStationDTO
    let facilities: FacilitiesDTO
    let transferStations: [NextPreviousStationDTO]
    let elevators: [ElevatorDTO]
}

struct NextPreviousStationDTO: Codable {
    let stationId: String
    let stationName: String
}

struct FacilitiesDTO: Codable {
    let elevator: Bool
    let wheelchairLift: Bool
    let disabledToilet: Bool
    let transitParkingLot: Bool
    let unmannedCivilApplicationIssuingMachine: Bool
    let currencyExchangeKiosk: Bool
    let trainTicketOffice: Bool
    let feedingRoom: Bool
}

struct ElevatorDTO: Codable {
    let elevatorId: Int
    let elevatorCoordinate: CoordinateDTO
    let elevatorStatus: String
}
