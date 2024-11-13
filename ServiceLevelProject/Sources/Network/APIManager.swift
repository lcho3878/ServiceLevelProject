//
//  APIManager.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func validationEmail(email: String, completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        do {
            let query = ValidationEmail(email: email)
            let request = try Router.validationEmail(query: query).asURLRequest()
            
            AF.request(request)
                .responseString { response in
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 200:
                        completion(.success(()))
                    case 400, 500:
                        if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                            completion(.failure(errorModel))
                        }
                    default:
                        break
                    }
                }
        } catch {
            print("Error 발생! : \(error)")
        }
    }
    
    func callRequest<T: Decodable>(api: TargetType, type: T.Type) -> Single<Result<T, ErrorCode>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try api.asURLRequest()
                let method: DataRequest
                if let multipartFormData = api.multipartFormData {
                    method = AF.upload(multipartFormData: multipartFormData, with: request)
                }
                else {
                    method = AF.request(request)
                }
                method
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400:
                                if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                    print(">>> errorCode: \(errorModel.errorCode)")
                                }
                                observer(.success(.failure(.clientError)))
                            case 500:
                                observer(.success(.failure(.success)))
                            default:
                                print("dc")
                                break
                            }
                        }
                    }
            } catch {
                print("Error 발생! : \(error)")
            }
            
            return Disposables.create()
        }
    }
}
