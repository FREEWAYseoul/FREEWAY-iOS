//
//  MockData.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct MockData {
    static let mockStationDetail: StationDetailDTO = {
        let coordinate = StationCoordinate(latitude: "37.56462215427451", longitude: "127.00579179092047")
        let nextStation = NextStation(stationId: 217, stationName: "청구")
        let previousStation = PreviousStation(stationId: 215, stationName: "을지로4가")
        
        let facilities = Facilities(
            elevator: false,
            wheelchairLift: false,
            disabledToilet: false,
            transitParkingLot: false,
            unmannedCivilApplicationIssuingMachine: false,
            currencyExchangeKiosk: false,
            trainTicketOffice: false,
            feedingRoom: false
        )
        
        let elevators = [
            Elevator(elevatorId: 165, elevatorCoordinate: StationCoordinate(latitude: "37.565868382504576", longitude: "127.00909956240862"), elevatorStatus: "사용 가능", exitNumber: "1"),
            Elevator(elevatorId: 521, elevatorCoordinate: StationCoordinate(latitude: "37.564649986201594", longitude: "127.00754393215446"), elevatorStatus: "사용 가능", exitNumber: "4")
        ]
        
        return StationDetailDTO(
            stationId: 216,
            stationName: "동대문역사문화공원",
            lineId: "5",
            lineName: "5호선",
            stationCoordinate: coordinate,
            stationStatus: "모두 사용 가능",
            stationContact: "02-6311-5361",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_5_27.jpg",
            nextStation: nextStation,
            previousStation: previousStation,
            facilities: facilities,
            transferStations: [
                TransferStation(stationId: 84, lineId: "2"),
                TransferStation(stationId: 177, lineId: "4")
            ],
            elevators: elevators
        )
    }()
    
    
    
    static let mockStationDTOs: [StationDTO] = [
        StationDTO(
            stationId: 207,
            stationName: "성수",
            lineId: "2",
            coordinate: CoordinateDTO(latitude: "37.5445888153751", longitude: "127.056066999327"),
            stationStatus: "사용 가능",
            availableElevatorsNumber: 2
        ),
        StationDTO(
            stationId: 208,
            stationName: "왕십리",
            lineId: "2",
            coordinate: CoordinateDTO(latitude: "37.561268363317176", longitude: "127.03710337610202"),
            stationStatus: "일부 가능",
            availableElevatorsNumber: 2
        )
    ]
    
    static let mockStationDTO = StationDTO(stationId: 207, stationName: "성수", lineId: "2", coordinate: CoordinateDTO(latitude: "37.5445888153751", longitude: "127.056066999327"), stationStatus: "사용 가능", availableElevatorsNumber: 2)
    
    static let mockNotiDTO: [NotificationDTO] = [
        NotificationDTO (
            date: "2023-07-30",
            notifications: [
                NotificationDataDTO(
                    summary: "금천구청역 간 1호선 열차 운행 재개됨.",
                    content: "안내말씀 드립니다.  코레일 구간 1호선 서울역~금천구청역 간 상,하선 열차 운행 중단은 강수 감소로 전구간 운행재개되었습니다. 열차 이용에 참고하시기 바랍니다.",
                    time: "01:24:00"
                ),
                NotificationDataDTO(
                    summary: "폭우로 1호선 지상 구간 운행 중단. 열차 이용 주의.",
                    content: "안내말쓰 드립니다. 코레일 지상 구간 폭우로 인하여 1호선 서울역~금천구청역 상,하선 열차 운행이 중지 중 입니다. 열차 이용에 참고하시기 바랍니다.",
                    time: "01:11:00"
                )
            ]
        ),
        NotificationDTO (
            date: "2023-07-30",
            notifications: [
                NotificationDataDTO(
                    summary: "금천구청역 간 1호선 열차 운행 재개됨.",
                    content: "안내말씀 드립니다.  코레일 구간 1호선 서울역~금천구청역 간 상,하선 열차 운행 중단은 강수 감소로 전구간 운행재개되었습니다. 열차 이용에 참고하시기 바랍니다.",
                    time: "01:24:00"
                ),
                NotificationDataDTO(
                    summary: "폭우로 1호선 지상 구간 운행 중단. 열차 이용 주의.",
                    content: "안내말쓰 드립니다. 코레일 지상 구간 폭우로 인하여 1호선 서울역~금천구청역 상,하선 열차 운행이 중지 중 입니다. 열차 이용에 참고하시기 바랍니다.",
                    time: "01:11:00"
                )
            ]
        )
    ]
    
    
}
