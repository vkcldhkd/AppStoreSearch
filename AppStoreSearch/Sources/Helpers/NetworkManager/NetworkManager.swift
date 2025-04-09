//
//  NetworkManager.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

struct NetworkManager {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource =  Constant.sessionTimeoutSeconds
        configuration.timeoutIntervalForRequest = Constant.sessionTimeoutSeconds
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}

extension NetworkManager {
    static func request(
        method: HTTPMethod = .post,
        param: Parameters? = nil,
        requestURL: String,
        isShowErrorAlert: Bool = true,
        encoding: ParameterEncoding = JSONEncoding.default,
        header: HTTPHeaders? = nil
    ) -> Observable<[String: Any]?> {
        print("URL : \(requestURL)")
        let trimmedURL: String = requestURL.trimmed
        return NetworkManager.shared.rx
            .request(method, trimmedURL, parameters: param, encoding: encoding, headers: header)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .retry(3)
            .responseJSON()
            .map{ json -> [String: Any]? in
                print("\(#function) ")
                print("\n")
                print("TIME: \(Date())")
                print("HAEDER : \(header ?? [])")
                print("PARAM : \(param ?? [:])")
                print("METHOD : \(method.rawValue)")
                print("STATUS CODE : \(json.response?.statusCode ?? 0 )")
                print("-----------------------------------------------------\n")
                
                switch json.result{
                case let .success(successJson):
//                    print("\(#function) success response \(successJson)")
                    return successJson as? [String: Any]
                    
                case let .failure(error):
                    print("\(#function) failure requestURL \(requestURL)")
                    print("\(#function) failure error \(error)")
//                    print("\(#function) failure json \(json)")
                    return ["error": error.localizedDescription]
                }
        }
    }
}
