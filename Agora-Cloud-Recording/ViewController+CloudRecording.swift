//
//  ViewController+CloudRecording.swift
//  Agora-Cloud-Recording
//
//  Created by Max Cobb on 19/05/2021.
//

import UIKit

extension ViewController {
    func stopRecord(sender: UIButton) {
        guard let recordData = self.recordData else { return }
        let body: [String: Any] = [
            "channel": channelName,
            "uid": recordData.uid,
            "sid": recordData.sid,
            "rid": recordData.rid
        ]
        let postData = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: URL(string: "\(self.urlBase)/api/stop/call")!, timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)

            // Update button to non-recording state
            sender.isSelected = false
            sender.setImage(UIImage(
                systemName: "record.circle",
                withConfiguration: UIImage.SymbolConfiguration(scale: .large)
            ), for: .normal)
            sender.backgroundColor = .systemGray

            // Reset the record data properties
            self.recordData = nil
        }

        task.resume()
    }
    func startRecord(sender: UIButton) {
        let body: [String: String] = ["channel": channelName]
        let postData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: URL(string: "\(self.urlBase)/api/start/call")!, timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseDict = responseJSON as? [String: Any],
                  let responseData = responseDict["data"] as? [String: Any],
                  let uid = responseData["uid"] as? UInt,
                  let sid = responseData["sid"] as? String,
                  let rid = responseData["rid"] as? String
            else {
                return
            }

            // Store the record data
            self.recordData = (uid, sid, rid)

            // Update the record button
            sender.isSelected = true
            sender.setImage(UIImage(
                systemName: "record.circle.fill",
                withConfiguration: UIImage.SymbolConfiguration(scale: .large)
            ), for: .normal)
            sender.backgroundColor = .systemRed

        }
        task.resume()
    }

    func recordStatus() {
        var request = URLRequest(url: URL(string: "\(self.urlBase)/api/status/call")!,timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let recordData = self.recordData else {
            return
        }
        let body: [String: String] = [
            "channel": channelName,
            "sid": recordData.sid, "rid": recordData.rid
        ]
        let postData = try? JSONSerialization.data(withJSONObject: body)

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }

}
