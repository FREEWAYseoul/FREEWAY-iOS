//
//  MockData.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct MockData {
    static let mockStationDetail: StationDetailDTO = {
        let coordinate = CoordinateDTO(latitude: "37.5445888153751", longitude: "127.056066999327")
        let nextStation = NextPreviousStationDTO(stationId: "212", stationName: "건대입구")
        let previousStation = NextPreviousStationDTO(stationId: "210", stationName: "뚝섬")
        let branchStation = NextPreviousStationDTO(stationId: "244", stationName: "용답")
        let facilities = FacilitiesDTO(
            elevator: true,
            wheelchairLift: false,
            disabledToilet: true,
            transitParkingLot: false,
            unmannedCivilApplicationIssuingMachine: false,
            currencyExchangeKiosk: false,
            trainTicketOffice: false,
            feedingRoom: true
        )
        let elevators = [
            ElevatorDTO(elevatorId: 42, elevatorCoordinate: coordinate, elevatorStatus: "사용 가능"),
            ElevatorDTO(elevatorId: 43, elevatorCoordinate: coordinate, elevatorStatus: "사용 가능")
        ]
        
        return StationDetailDTO(
            stationId: "211",
            stationName: "성수",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: coordinate,
            stationStatus: "사용 가능",
            stationContact: "02-6110-2111",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_15.gif",
            nextStation: nextStation,
            previousStation: previousStation,
            branchStation: branchStation,
            facilities: facilities,
            transferStations: [NextPreviousStationDTO(stationId: "2729", stationName: "7호선")],
            elevators: elevators
        )
    }()

    static let mockStationDTOs: [StationDTO] = [
        StationDTO(
            stationId: "207",
            stationName: "상왕십리",
            lineId: "2",
            coordinate: CoordinateDTO(latitude: "37.56443666620397", longitude: "127.02927241035283"),
            stationStatus: "사용 가능",
            elevatorsNumber: 2
        ),
        StationDTO(
            stationId: "208",
            stationName: "왕십리",
            lineId: "2",
            coordinate: CoordinateDTO(latitude: "37.561268363317176", longitude: "127.03710337610202"),
            stationStatus: "일부 가능",
            elevatorsNumber: 2
        )
    ]
}
