//
//  ViewController.swift
//  TestWebSockets
//
//  Created by Friedrich HAEUPL on 12.12.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }

    var socket: WebSocket!
    var counterValue = 99
    var data:Data = Data()
    
    @IBOutlet weak var connectOutlet: NSButton!
    @IBOutlet weak var disconnectOutlet: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var counter: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    
    @IBAction func connect(_ sender: Any) {
        //var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        var request = URLRequest(url: URL(string: "ws://demos.kaazing.com/echo")!)
        //var request = URLRequest(url: URL(string: "wss://echo.websocket.org")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    @IBAction func sendText(_ sender: Any) {
        socket.write(string: textField.stringValue)
    }
    
    @IBAction func sendData(_ sender: Any) {
        
        let len  = slider.intValue
        //counter.intValue = len
        data  = randomData(ofLength: Int(len))
        
        socket.write(data: data)
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        let len  = slider.intValue
        counter.intValue = len
        //data  = randomData(ofLength: Int(len))
    }
    
    
    @IBAction func disconnect(_ sender: Any) {
        if socket.isConnected {
            //sender.title = "Connect"
            socket.disconnect()
        } else {
            //sender.title = "Disconnect"
            socket.connect()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.stringValue = "Enter Text here"
        counter.intValue = slider.intValue
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public func randomData(ofLength length: Int) -> Data {
        /*
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes)
        }
        //
        return Data(bytes: [255])
        */
        let bytes = [UInt8](repeating: 0x55, count: length)
        return Data(bytes: bytes)
    }

}

