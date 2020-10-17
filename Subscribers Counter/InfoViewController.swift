//
//  InfoViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 05.10.2020.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDataSource {
    var data = ["Write to us"]
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        
        let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        let title = UILabel(frame: CGRect(x: 16, y: 72, width: 360, height: 41))
        title.textAlignment = .left
        title.text = "Info"
        title.font = titleFont
        self.view.addSubview(title)
    
        self.tableView.rowHeight = 60
        self.tableView.backgroundColor = UIColor.systemBackground
        self.view.addSubview(self.tableView)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.updateLayout(with: self.view.frame.size)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
          return self.data.count
        default:
          return 0
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        let cellName = self.data[indexPath.row]
        
        let cellTitleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let cellTitle = UILabel(frame: CGRect(x: 48, y: 18, width: self.view.bounds.size.width, height: 22))
        cellTitle.font = cellTitleFont
        cellTitle.text = cellName
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 16, y: 18, width: 24, height: 24))
        cellImg.image = UIImage(systemName: "pencil")

        cell.addSubview(cellImg)
        cell.addSubview(cellTitle)
        
        return cell
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(x: 0, y: 129, width: Int(self.view.bounds.size.width), height: 60)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
       coordinator.animate(alongsideTransition: { (contex) in
          self.updateLayout(with: size)
       }, completion: nil)
    }
}

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let email = "narek.changlyan@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
}

