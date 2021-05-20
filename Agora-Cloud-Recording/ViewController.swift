//
//  ViewController.swift
//  Agora-Cloud-Recording
//
//  Created by Max Cobb on 12/05/2021.
//

import UIKit
import AgoraUIKit_iOS

class ViewController: UIViewController {
    var agoraViewer: AgoraVideoViewer!
    var channelName = "test"
    var recordData: (uid: UInt, sid: String, rid: String)?
    let urlBase: String = <#Server URL#>
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let agoraViewer = AgoraVideoViewer(
            connectionData: AgoraConnectionData(appId: <#Agora App ID#>)
        )

        agoraViewer.fills(view: self.view)

        self.fetchTokenThenJoin()
    }

    func fetchTokenThenJoin() {
        var request = URLRequest(url: URL(string: "\(urlBase)/api/get/rtc/test")!, timeoutInterval: 10)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseDict = responseJSON as? [String: Any],
                  let rtcToken = responseDict["rtc_token"] as? String,
                  let uid = responseDict["uid"] as? UInt
            else {
                return
            }

            // Join Channel with new token
            self.agoraViewer.join(channel: self.channelName, with: rtcToken, as: .broadcaster, uid: uid)
        }

        task.resume()
    }
}

extension ViewController: AgoraVideoViewerDelegate {
    func extraButtons() -> [UIButton] {
        let recButton = UIButton()
        recButton.setImage(UIImage(
            systemName: "record.circle",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        ), for: .normal)
        recButton.addTarget(self, action: #selector(self.clickedRecord), for: .touchUpInside)
        return [recButton]
    }

    @objc func clickedRecord(sender: UIButton) {
        print("zap!")
        if sender.isSelected {
            self.stopRecord(sender: sender)
        } else {
            self.startRecord(sender: sender)
        }
    }
}

