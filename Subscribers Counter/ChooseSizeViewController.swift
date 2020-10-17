//
//  ChooseSizeViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 17.10.2020.
//

import UIKit

class ChooseSizeViewController: UIViewController, UITableViewDataSource {
    var accountStr: String = ""
    var data = ["Small","Medium","Large"]
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        
        let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        let title = UILabel(frame: CGRect(x: 16, y: 72, width: self.view.bounds.size.width - 32, height: 41))
        title.textAlignment = .left
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.text = "Choose size"
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let cellName = self.data[indexPath.row]
        
        let cellTitleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let cellTitle = UILabel(frame: CGRect(x: 16, y: 18, width: self.view.bounds.size.width, height: 22))
        cellTitle.font = cellTitleFont
        cellTitle.text = cellName
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 16, y: 18, width: 24, height: 24))
        cellImg.image = UIImage(named: cellName.lowercased())

        cell.addSubview(cellImg)
        cell.addSubview(cellTitle)
        
        return cell
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(x: 0, y: 129, width: Int(self.view.bounds.size.width), height: 60 * self.data.count)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
       coordinator.animate(alongsideTransition: { (contex) in
          self.updateLayout(with: size)
       }, completion: nil)
    }
}

extension ChooseSizeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currItem = self.data[indexPath.row]
        let vc = ChooseColorViewController()
        
        vc.accountStr = self.accountStr
        vc.sizeStr = currItem

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

