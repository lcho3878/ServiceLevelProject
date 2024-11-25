//
//  WebSocketManager.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/25/24.
//

import Foundation
import SocketIO
import RxSwift

final class WebSocketManager {
    typealias ChannelChatting = ChannelChatHistoryModel
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    var router: SocketRouter?
    var channelOutput = PublishSubject<ChannelChatting>()
    var dmOutput = PublishSubject<DMChatting>()
    
    static let shared = WebSocketManager()
    
    // BaseURL 소켓 연결
    func connect() {
        guard let url = SocketRouter.baseURL else { return }
        manager = SocketManager(socketURL: url)
        socket = manager?.defaultSocket
        
        socket?.on(clientEvent: .connect) { data, ack in
            print(">>> SOCKET CONNECTED")
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print(">>> SOCKET DISCONNECTED")
        }
        
        socket?.connect()
        connectNameSpace()
    }
    
    // BaseURL 소켓 연결 해제
    func disconnect() {
        disconnectNameSpace()
        socket?.disconnect()
    }
}

extension WebSocketManager {
    // router의 nameSpace로 소켓 연결
    func connectNameSpace() {
        guard let router else { return }
        let namespaceSocket = manager?.socket(forNamespace: router.namespace)
        
        namespaceSocket?.on(clientEvent: .connect) { data, ack in
            print(">>> CONNECTED NAMESPACE")
        }
        
        namespaceSocket?.on(clientEvent: .disconnect) { data, ack in
            print(">>> DISCONNECTED NAMESPACE")
        }
        let eventName: String
        switch router {
        case .chatting:
            eventName = "channel"
        case .dm:
            eventName = "dm"
        }
        namespaceSocket?.on(eventName) { [weak self] dataArray, ack in
            guard let firstItem = dataArray.first else {
                print(">>> no first")
                return
            }
            if let dictionary = firstItem as? [String: Any] {
                switch router {
                case .chatting:
                    if let chatting = self?.parseDictionary(of: ChannelChatting.self, dictionary: dictionary) {
                        self?.channelOutput.onNext(chatting)
                    }
                case .dm:
                    if let chatting = self?.parseDictionary(of: DMChatting.self, dictionary: dictionary) {
                        self?.dmOutput.onNext(chatting)
                    }
                }
            }
        }
        namespaceSocket?.connect()
    }
    
    // router의 nameSpace로 소켓 연결 해제
    func disconnectNameSpace() {
        guard let router else { return }
        let namespaceSocket = manager?.socket(forNamespace: router.namespace)
        namespaceSocket?.disconnect()
    }
}

extension WebSocketManager {
    // JSONData로 변환후 Decodable 변환
    private func parseDictionary<T: Decodable>(of: T.Type, dictionary: [String: Any]) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            let chatting = try JSONDecoder().decode(T.self, from: jsonData)
            return chatting
        } catch {
            return nil
        }
    }
}
