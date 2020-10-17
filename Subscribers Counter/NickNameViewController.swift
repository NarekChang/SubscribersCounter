//
//  NickNameViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 11.10.2020.
//

import UIKit

struct AccountInfoData: Decodable {
    let lv_identifier: String?
    let followers: Int?
    let following: Int?
    let subscribers: Int?
    let hearts: Int?
    let videos: Int?
}

struct AccountInfo: Decodable {
    let success: Bool?
    let service: String?
    let t: Int?
    let followers_count: Int?
    let logging_page_id: String?
    let data: AccountInfoData?
}

class NickNameViewController: UIViewController {
    var currSocialNetwork: String = ""
    var nickname: String = ""
    let uiBusy = UIActivityIndicatorView(style: .medium)
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        nickname = String(textField.text ?? "")
    }
    
    func resetAccount() {
        self.navigationItem.hidesBackButton = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem?.action = #selector(buttonClicked(sender:))
        
        let alert = UIAlertController(title: "Account not found, please try again", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    func saveAccount() {
        let defaults = UserDefaults.standard
        
        struct Account: Codable {
            var name: String
            var soc: String
        }
        
        do {
            if let stringOne = defaults.string(forKey: "accounts") {
                var stringTwo = stringOne
                let acc = Account(name: nickname, soc: currSocialNetwork)
                
                let encodedDataAcc = try JSONEncoder().encode(acc)
                let jsonStringAcc = String(data: encodedDataAcc, encoding: .utf8)
                
                stringTwo.append("|-|" )
                stringTwo.append(jsonStringAcc ?? "")
                
                defaults.set("\(stringTwo)", forKey: "accounts")
            } else {
                var stringTwo = ""
                let acc = Account(name: nickname, soc: currSocialNetwork)
                
                let encodedDataAcc = try JSONEncoder().encode(acc)
                let jsonStringAcc = String(data: encodedDataAcc, encoding: .utf8)
                
                stringTwo.append(jsonStringAcc ?? "")
                
                defaults.set(stringTwo, forKey: "accounts")
            }
        } catch {
            //handle error
            print("error")
            self.resetAccount()
        }

        uiBusy.stopAnimating()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        if nickname.count != 0 {
            uiBusy.hidesWhenStopped = true
            uiBusy.startAnimating()
            uiBusy.color = UIColor.systemBlue
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
            
            var apiURL: Array = [""]
            var currSocialNetworkApi: Array = [""]
            
            if currSocialNetwork == "youtube" {
                currSocialNetworkApi.append("youtube-subscriber-count")
            }
            
            if currSocialNetwork == "tiktok" {
                currSocialNetworkApi.append("tiktok-follower-count")
            }
            
            if currSocialNetwork == "twitter" {
                apiURL.append("https://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names=\(nickname)")
            }
            
            currSocialNetworkApi.append("instagram-follower-count")
            
            if currSocialNetwork == "instagram" {
                apiURL.append("https://www.instagram.com/\(nickname)/?__a=1")
            } else {
                apiURL.append("https://counts.live/api/\(currSocialNetworkApi[1])/\(nickname)/live")
            }
            
            
            let url = URL(string: apiURL[1] )!
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:79.0) Gecko/20100101 Firefox/79.0", forHTTPHeaderField: "User-Agent")
            request.addValue("*/*", forHTTPHeaderField: "Accept")
            request.addValue("Accept-Language", forHTTPHeaderField: "Accept-Language")
            request.addValue("https://counts.live/\(currSocialNetworkApi[1])/\(nickname)", forHTTPHeaderField: "Referer")
            request.addValue("keep-alive", forHTTPHeaderField: "Connection")
            
            print("currSocialNetwork", self.currSocialNetwork)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
                guard let data = data else { return }
                
                if self.currSocialNetwork == "twitter" {
                    do {
                        let dataStr = "\(String(data: data, encoding: .utf8) ?? "")"
                        let data = dataStr.data(using: .utf8)!
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                if (jsonArray.count > 0) {
//                                    let followers_count = jsonArray[0]["followers_count"] as? Int
                                    self.saveAccount()
                                    
                                } else {
                                    self.resetAccount()
                                }
                            } else {
                                print("bad json")
                                
                                self.resetAccount()
                            }
                        } catch let error as NSError {
                            print(error)
                            
                            self.resetAccount()
                        }
                    } catch let error as NSError {
                        print("error12")
                        print(error)
                        
                        self.resetAccount()
                    }
                } else {
                    do {
                        let AccountInfoObj: AccountInfo = try JSONDecoder().decode(AccountInfo.self, from: data)

                        if self.currSocialNetwork == "instagram" {
                            if AccountInfoObj.logging_page_id != nil {
                                self.saveAccount()
                            } else {
                                self.resetAccount()
                            }
                        } else {
                            if AccountInfoObj.success! {
                                self.saveAccount()
                            } else {
                                self.resetAccount()
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                        //handle error
                        print("error123")
                        self.resetAccount()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem?.action = #selector(buttonClicked(sender:))

        let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        let title = UILabel(frame: CGRect(x: 16, y: 72, width: self.view.bounds.size.width - 32, height: 41))
        title.textAlignment = .left
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.text = "Enter nickname"
        title.font = titleFont
        self.view.addSubview(title)
        
        let textInputFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        let textInput = UITextField(frame: CGRect(x: 16, y: 137, width: self.view.bounds.size.width - 32, height: 56))
        textInput.font = textInputFont
        textInput.placeholder = "Nickname"
        textInput.borderStyle = .none
        textInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -16, y: 56, width:self.view.bounds.size.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textInput.layer.addSublayer(bottomLine)
        
        self.view.addSubview(textInput)
    }
    
}

//curl 'https://counts.live/api/youtube-subscriber-count/UC6S1hSjVMFbB9WKv-qZKwuw/live' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.7,ru;q=0.3' -H 'Referer: https://counts.live/youtube-subscriber-count/UC6S1hSjVMFbB9WKv-qZKwuw' -H 'Connection: keep-alive'
// https://www.instagram.com/narekchang/?__a=1

// https://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names=Changlyan
//curl 'https://counts.live/api/twitter-follower-count/Changlyan/live' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.7,ru;q=0.3' -H 'Referer: https://counts.live/twitter-follower-count/Changlyan' -H 'Connection: keep-alive'

//curl 'https://counts.live/api/tiktok-follower-count/arkadiambarcumyan/live' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.7,ru;q=0.3' -H 'Referer: https://counts.live/tiktok-follower-count/arkadiambarcumyan' -H 'Connection: keep-alive'
