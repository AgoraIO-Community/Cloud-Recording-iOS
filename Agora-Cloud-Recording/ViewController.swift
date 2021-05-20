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
        <#Fetch Token then Join Channel#>
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

