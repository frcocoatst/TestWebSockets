//
//  ViewController.swift
//  TestWebSockets
//
//  Created by Friedrich HAEUPL on 12.12.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, WebSocketDelegate, WebSocketPongDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        logString = logString + "websocket is connected\n"
        textView.string = logString
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
            logString = logString + "websocket is disconnected: \(e.message)\n"
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            logString = logString + "websocket is disconnected: \(e.localizedDescription)\n"
        } else {
            print("websocket disconnected")
            logString = logString + "websocket is disconnected\n"
        }
        textView.string = logString
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
        logString = logString + "Received text: \(text)\n"
        textView.string = logString
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
        logString = logString + "Received data: \(data.count) Bytes\n"
        textView.string = logString
    }
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?){
        if (data != nil) {
            print("Received pong: \(data!.count) Bytes")
            logString = logString + "Received pong: \(data!.count) Byte\n"
        }
        else {
            print("Received pong")
            logString = logString + "Received pong"
        }
        textView.string = logString
    }

    var socket: WebSocket!
    var counterValue = 99
    var data:Data = Data()
    //var request = URLRequest(url: URL(string: "http://localhost:8080")!)
    //var request = URLRequest(url: URL(string: "ws://demos.kaazing.com/echo")!)
    //var request = URLRequest(url: URL(string: "wss://echo.websocket.org")!)
    var hostString = "ws://demos.kaazing.com/echo"
    var logString = ">\n"

    @IBOutlet weak var connectOutlet: NSButton!
    @IBOutlet weak var disconnectOutlet: NSButton!
    @IBOutlet weak var sendTextOutlet: NSButton!
    @IBOutlet weak var sendDataOutlet: NSButton!    
    @IBOutlet weak var sendPingOutlet: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var counter: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var hostLabel: NSTextField!
    @IBOutlet weak var hostSelectPopup: NSPopUpButton!
    @IBOutlet var textView: NSTextView!
    
    @IBAction func connect(_ sender: Any) {

        hostString = hostSelectPopup.title
        hostLabel.stringValue = hostString
        print (" Trying to connect to \(hostString)")
        var request = URLRequest(url: URL(string: hostString)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.pongDelegate = self
        socket.connect()
        
        connectOutlet.isEnabled = false
        disconnectOutlet.isEnabled = true
        sendTextOutlet.isEnabled = true
        sendDataOutlet.isEnabled = true
        sendPingOutlet.isEnabled = true
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
    
    @IBAction func popUpAction(_ sender: Any) {
        hostString = hostSelectPopup.title
        hostLabel.stringValue = hostString
    }
    
    @IBAction func sendPing(_ sender: Any) {
        let bytes = [UInt8](repeating: 0xAA, count: 20)
        let pingdata = Data(bytes: bytes)
        socket.write(ping: pingdata)
    }
    
    @IBAction func disconnect(_ sender: Any) {
        if socket.isConnected {
            //sender.title = "Connect"
            socket.disconnect()
        } else {
            //sender.title = "Disconnect"
            socket.connect()
        }
        connectOutlet.isEnabled = true
        disconnectOutlet.isEnabled = false
        sendTextOutlet.isEnabled = false
        sendDataOutlet.isEnabled = false
        sendPingOutlet.isEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hostLabel.stringValue = ""
        textField.stringValue = "Enter Text here"
        counter.intValue = slider.intValue
        
        connectOutlet.isEnabled = true
        disconnectOutlet.isEnabled = false
        sendTextOutlet.isEnabled = false
        sendDataOutlet.isEnabled = false
        sendPingOutlet.isEnabled = false
        textView.string = logString
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

