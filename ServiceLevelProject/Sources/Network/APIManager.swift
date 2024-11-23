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
    
    /// MVVM ViewModel에서 사용될 callRequest 메서드입니다.
    /// 응답값이 없는 경우에 사용합니다.
    func callRequest(api: TargetType) -> Single<Result<Void, ErrorModel>> {
        return Single.create { observer -> Disposable in
            func loop() {
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
                        .response { response in
                            switch response.result {
                            case .success(_):
                                observer(.success(.success(())))
                            case .failure(_):
                                let statusCode = response.response?.statusCode
                                switch statusCode {
                                case 400, 500:
                                    if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                        print(">>> errorCode: \(errorModel.errorCode)")
                                        switch errorModel.errorCode {
                                        case "E05":
                                            self.refreshToken { result in
                                                switch result {
                                                case .success(_):
                                                    loop()
                                                case .failure(_):
                                                    print("refresh 만료! 로그인화면으로 이동")
                                                    observer(.success(.failure(errorModel)))
                                                }
                                            }
                                        case "E06":
                                            print("refresh 만료! 로그인화면으로 이동")
                                        default:
                                            observer(.success(.failure(errorModel)))
                                        }
                                    }
                                default:
                                    print("Error: Decoding Failure")
                                    break
                                }
                            }
                        }
                } catch {
                    print("Error 발생! : \(error)")
                }
            }
            
            loop()
            return Disposables.create()
        }
    }
    
    /// MVVM ViewModel에서 사용될 callRequest 메서드입니다.
    /// 응답값이 있는 경우에 사용합니다.
    /// type에 Decodable한 타입을 지정하여 사용합니다.
    func callRequest<T: Decodable>(api: TargetType, type: T.Type) -> Single<Result<T, ErrorModel>> {
        return Single.create { observer -> Disposable in
            func loop() {
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
                                case 400, 500:
                                    if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                        print(">>> errorCode: \(errorModel.errorCode)")
                                        
                                        switch errorModel.errorCode {
                                        case "E05":
                                            self.refreshToken { result in
                                                switch result {
                                                case .success(_):
                                                    loop()
                                                case .failure(_):
                                                    print("refresh 만료! 로그인화면으로 이동")
                                                    observer(.success(.failure(errorModel)))
                                                }
                                            }
                                        case "E06":
                                            print("refresh 만료! 로그인화면으로 이동")
                                        default:
                                            observer(.success(.failure(errorModel)))
                                        }
                                    }
                                default:
                                    print("Error: Decoding Failure")
                                    break
                                }
                            }
                        }
                } catch {
                    print("Error 발생! : \(error)")
                }
            }
            loop()
            return Disposables.create()
        }
    }
    
    /// MVC ViewController에서 사용될 callRequest 메서드입니다.
    /// 응답값이 없는 경우에 사용합니다.
    func callRequest(api: TargetType, completion: @escaping (Result<Void, ErrorModel>) -> Void) {
        func loop() {
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
                                    switch errorModel.errorCode {
                                    case "E05":
                                        self.refreshToken { result in
                                            switch result {
                                            case .success(_):
                                                loop()
                                            case .failure(_):
                                                print("refresh 만료! 로그인화면으로 이동")
                                                completion(.failure(errorModel))
                                            }
                                        }
                                    case "E06":
                                        print("refresh 만료! 로그인화면으로 이동")
                                    default:
                                        completion(.failure(errorModel))
                                    }
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
        
        loop()
    }
    
    /// MVC ViewController에서 사용될 callRequest 메서드입니다.
    /// 응답값이 있는 경우에 사용합니다.
    /// type에 Decodable한 타입을 지정하여 사용합니다.
    func callRequest<T: Decodable>(api: TargetType, type: T.Type, completion: @escaping (Result<T, ErrorModel>) -> Void) {
        func loop() {
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
                        case .success(let value):
                            completion(.success(value))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400, 500:
                                if let data = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                                    completion(.failure(errorModel))
                                    switch errorModel.errorCode {
                                    case "E05":
                                        self.refreshToken { result in
                                            switch result {
                                            case .success(_):
                                                loop()
                                            case .failure(_):
                                                print("refresh 만료! 로그인화면으로 이동")
                                                completion(.failure(errorModel))
                                            }
                                        }
                                    case "E06":
                                        print("refresh 만료! 로그인화면으로 이동")
                                    default:
                                        completion(.failure(errorModel))
                                    }
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
        
        loop()
    }
    
    // 토큰 갱신 메서드
    func refreshToken(completion: @escaping (Result<RefreshTokenModel, ErrorModel>) -> Void) {
        APIManager.shared.callRequest(api: UserRouter.refreshToken, type: RefreshTokenModel.self) { result in
            switch result {
            case .success(let success):
                UserDefaultManager.accessToken = success.accessToken
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure)) // 여기는 200, 400밖에 없음 -> Failure인 경우 리프레시 만료로 재로그인 필요
            }
        }
    }

}

// MARK: loadImage Function
extension APIManager {
    
    /// 응답값의 Image를 가져오는 메서드입니다.
    ///
    /// 사용예시
    ///
    ///     Task {
    ///         let data = try await APIManager.shared.loadImage(element.coverImage)
    ///         coverImageView.image = UIImage(data: data)
    ///     }
    
    func loadImage(_ image: String) async throws -> Data {
        let request = try ImageRouter.image(image: image).asURLRequest()
        let response = AF.request(request)
            .validate(statusCode: 200..<300)
            .serializingResponse(using: .data)
        
        switch await response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
