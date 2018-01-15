//
//  SocketService.swift
//  Smack
//
//  Created by Serena Lambert on 13/01/2018.
//  Copyright © 2018 Serena Lambert. All rights reserved.
//

import UIKit
import SocketIO

var manager = SocketManager(socketURL: URL(string: BASE_URL)!)
var socket = manager.defaultSocket

class SocketService: NSObject {


    static let instance = SocketService()


    override init() {
        super.init()
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }

    func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1]  as? String else { return }
            guard let channelId = dataArray[1]  as? String else { return }

            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }

}
