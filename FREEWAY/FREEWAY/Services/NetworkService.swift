//
//  NetworkService.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/04.
//

import UIKit
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {
        
    }

    func getAllStationList(completion: @escaping ([StationDTO]?, Error?) -> Void) {
        AF.request("http://freeway-env.eba-mpxrzw3w.ap-northeast-2.elasticbeanstalk.com/api/stations").responseDecodable(of: [StationDTO].self) { response in
            switch response.result {
            case .success(let stations):
                // 성공적으로 디코딩된 데이터를 사용할 수 있습니다.
                completion(stations, nil)
            case .failure(let error):
                // 데이터를 가져오는 중에 오류가 발생한 경우 처리할 내용을 작성합니다.
                print("데이터를 불러오는 중 오류 발생: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func getStationDetail(stationId: String = "", completion: @escaping (StationDetailDTO?, Error?) -> Void) {
        AF.request("http://freeway-env.eba-mpxrzw3w.ap-northeast-2.elasticbeanstalk.com/api/stations/\(stationId)").responseDecodable(of: StationDetailDTO.self) { response in
            switch response.result {
            case .success(let stations):
                // 성공적으로 디코딩된 데이터를 사용할 수 있습니다.
                completion(stations, nil)
            case .failure(let error):
                // 데이터를 가져오는 중에 오류가 발생한 경우 처리할 내용을 작성합니다.
                print("데이터를 불러오는 중 오류 발생: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func getNotifications(completion: @escaping ([NotificationDTO]?, Error?) -> Void) {
        AF.request("http://freeway-env.eba-mpxrzw3w.ap-northeast-2.elasticbeanstalk.com/api/notifications").responseDecodable(of: [NotificationDTO].self) { response in
            switch response.result {
            case .success(let notifications):
                // 성공적으로 디코딩된 데이터를 사용할 수 있습니다.
                completion(notifications, nil)
                // 여기에서 데이터를 처리하거나 ViewModel 등으로 전달할 수 있습니다.
            case .failure(let error):
                // 데이터를 가져오는 중에 오류가 발생한 경우 처리할 내용을 작성합니다.
                print("데이터를 불러오는 중 오류 발생: \(error)")
                completion(nil, error)
            }
        }
    }
}

