//
//  MockData.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import Foundation

struct MockData {
    static let mockStationDetails: [StationDetailDTO] = [
        // 서울역
        StationDetailDTO(
            stationId: 201,
            stationName: "서울역",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: StationCoordinate(latitude: "37.555134", longitude: "126.970626"),
            stationStatus: "사용 가능",
            stationContact: "02-1234-5678",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_1.jpg",
            nextStation: NextStation(stationId: 202, stationName: "충정로"),
            previousStation: PreviousStation(stationId: 200, stationName: "시청"),
            facilities: Facilities(
                elevator: true,
                wheelchairLift: false,
                disabledToilet: true,
                transitParkingLot: true,
                unmannedCivilApplicationIssuingMachine: true,
                currencyExchangeKiosk: true,
                trainTicketOffice: true,
                feedingRoom: false
            ),
            transferStations: [
                TransferStation(stationId: 100, lineId: "1")
            ],
            elevators: [
                Elevator(elevatorId: 101, elevatorCoordinate: StationCoordinate(latitude: "37.5555", longitude: "126.9710"), elevatorStatus: "사용 가능", exitNumber: "1")
            ]
        ),
        
        // 을지로입구
        StationDetailDTO(
            stationId: 203,
            stationName: "을지로입구",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: StationCoordinate(latitude: "37.566014", longitude: "126.982684"),
            stationStatus: "사용 가능",
            stationContact: "02-1234-5679",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_2.jpg",
            nextStation: NextStation(stationId: 204, stationName: "을지로3가"),
            previousStation: PreviousStation(stationId: 202, stationName: "시청"),
            facilities: Facilities(
                elevator: true,
                wheelchairLift: true,
                disabledToilet: false,
                transitParkingLot: false,
                unmannedCivilApplicationIssuingMachine: false,
                currencyExchangeKiosk: false,
                trainTicketOffice: true,
                feedingRoom: true
            ),
            transferStations: [
                TransferStation(stationId: 102, lineId: "1")
            ],
            elevators: [
                Elevator(elevatorId: 102, elevatorCoordinate: StationCoordinate(latitude: "37.5661", longitude: "126.9830"), elevatorStatus: "사용 가능", exitNumber: "2")
            ]
        ),

        // 왕십리
        StationDetailDTO(
            stationId: 206,
            stationName: "왕십리",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: StationCoordinate(latitude: "37.561533", longitude: "127.037732"),
            stationStatus: "사용 가능",
            stationContact: "02-1234-5680",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_3.jpg",
            nextStation: NextStation(stationId: 207, stationName: "한양대"),
            previousStation: PreviousStation(stationId: 205, stationName: "상왕십리"),
            facilities: Facilities(
                elevator: true,
                wheelchairLift: true,
                disabledToilet: true,
                transitParkingLot: true,
                unmannedCivilApplicationIssuingMachine: true,
                currencyExchangeKiosk: true,
                trainTicketOffice: true,
                feedingRoom: false
            ),
            transferStations: [
                TransferStation(stationId: 103, lineId: "5"),
                TransferStation(stationId: 104, lineId: "경의중앙선")
            ],
            elevators: [
                Elevator(elevatorId: 103, elevatorCoordinate: StationCoordinate(latitude: "37.5617", longitude: "127.0379"), elevatorStatus: "사용 가능", exitNumber: "3")
            ]
        ),

        // 잠실
        StationDetailDTO(
            stationId: 208,
            stationName: "잠실",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: StationCoordinate(latitude: "37.513950", longitude: "127.102234"),
            stationStatus: "사용 가능",
            stationContact: "02-1234-5681",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_4.jpg",
            nextStation: NextStation(stationId: 209, stationName: "잠실나루"),
            previousStation: PreviousStation(stationId: 207, stationName: "잠실새내"),
            facilities: Facilities(
                elevator: true,
                wheelchairLift: false,
                disabledToilet: true,
                transitParkingLot: true,
                unmannedCivilApplicationIssuingMachine: false,
                currencyExchangeKiosk: false,
                trainTicketOffice: true,
                feedingRoom: true
            ),
            transferStations: [
                TransferStation(stationId: 105, lineId: "8")
            ],
            elevators: [
                Elevator(elevatorId: 104, elevatorCoordinate: StationCoordinate(latitude: "37.5141", longitude: "127.1025"), elevatorStatus: "사용 가능", exitNumber: "5")
            ]
        ),

        // 신촌
        StationDetailDTO(
            stationId: 210,
            stationName: "신촌",
            lineId: "2",
            lineName: "2호선",
            stationCoordinate: StationCoordinate(latitude: "37.556021", longitude: "126.936854"),
            stationStatus: "사용 가능",
            stationContact: "02-1234-5682",
            stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_5.jpg",
            nextStation: NextStation(stationId: 211, stationName: "이대"),
            previousStation: PreviousStation(stationId: 209, stationName: "홍대입구"),
            facilities: Facilities(
                elevator: true,
                wheelchairLift: true,
                disabledToilet: true,
                transitParkingLot: true,
                unmannedCivilApplicationIssuingMachine: false,
                currencyExchangeKiosk: true,
                trainTicketOffice: true,
                feedingRoom: false
            ),
            transferStations: [
                TransferStation(stationId: 106, lineId: "경의중앙선")
            ],
            elevators: [
                Elevator(elevatorId: 105, elevatorCoordinate: StationCoordinate(latitude: "37.5561", longitude: "126.9370"), elevatorStatus: "사용 가능", exitNumber: "2")
            ]
        )
    ]
    
    static let mockStationDetail: StationDetailDTO = StationDetailDTO(
        stationId: 201,
        stationName: "서울역",
        lineId: "2",
        lineName: "2호선",
        stationCoordinate: StationCoordinate(latitude: "37.555134", longitude: "126.970626"),
        stationStatus: "사용 가능",
        stationContact: "02-1234-5678",
        stationImageUrl: "http://data.seoul.go.kr/contents/stn_img/image_2_1.jpg",
        nextStation: NextStation(stationId: 202, stationName: "충정로"),
        previousStation: PreviousStation(stationId: 200, stationName: "시청"),
        facilities: Facilities(
            elevator: true,
            wheelchairLift: false,
            disabledToilet: true,
            transitParkingLot: true,
            unmannedCivilApplicationIssuingMachine: true,
            currencyExchangeKiosk: true,
            trainTicketOffice: true,
            feedingRoom: false
        ),
        transferStations: [
            TransferStation(stationId: 100, lineId: "1")
        ],
        elevators: [
            Elevator(elevatorId: 101, elevatorCoordinate: StationCoordinate(latitude: "37.5555", longitude: "126.9710"), elevatorStatus: "사용 가능", exitNumber: "1")
        ]
    )
    
    
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
            date: "2023-09-11",
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
