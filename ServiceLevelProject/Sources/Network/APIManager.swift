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
    
    //사용되지 않는 메서드
    func validationEmail(email: String, completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        do {
            let query = ValidationEmail(email: email)
            let request = try UserRouter.validationEmail(query: query).asURLRequest()
            
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
    
    /// MVVM ViewModel에서 사용될 callRequest 메서드입니다.
    /// 응답값이 없는 경우에 사용합니다.
    func callRequest(api: TargetType) -> Single<Result<Void, ErrorCode>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try api.asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success(_):
                            observer(.success(.success(())))
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
                                print("알수없는 오류 발생")
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
    
    /// MVVM ViewModel에서 사용될 callRequest 메서드입니다.
    /// 응답값이 있는 경우에 사용합니다.
    /// type에 Decodable한 타입을 지정하여 사용합니다.
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
    
    /// MVC ViewController에서 사용될 callRequest 메서드입니다.
    /// 응답값이 없는 경우에 사용합니다.
    func callRequest(api: TargetType, completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        do {
            let request = try api.asURLRequest()
            
            AF.request(request)
                .response { response in
                    switch response.result {
                    case .success(_):
                        completion(.success(()))
                    case .failure(_):
                        let statusCode = response.response?.statusCode
                        switch statusCode {
                        case 400, 500:
                            if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                completion(.failure(errorModel))
                            }
                        default:
                            break
                        }
                    }
                }
        } catch {
            print("Error 발생! : \(error)")
        }
    }
    
    /// MVC ViewController에서 사용될 callRequest 메서드입니다.
    /// 응답값이 있는 경우에 사용합니다.
    /// type에 Decodable한 타입을 지정하여 사용합니다.
    func callRequest<T: Decodable>(api: TargetType, type: T.Type, completion: @escaping (Result<T, ErrorModel>) -> Void) {
        do {
            let request = try api.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure(_):
                        let statusCode = response.response?.statusCode
                        switch statusCode {
                        case 400, 500:
                            if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                completion(.failure(errorModel))
                            }
                        default:
                            print("Error: Decoding Failure")
                        }
                    }
                    
                }
        } catch {
            print("Error 발생! : \(error)")
        }
    }
}
