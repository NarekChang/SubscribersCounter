//
//  ChooseAccontViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 17.10.2020.
//

import UIKit

class TableViewCell3: UITableViewCell {

}

class ChooseAccontViewController: UIViewController, UITableViewDataSource {
    
    var list: Array<String> = ["{\"name\":\"\",\"soc\":\"twitter\"}"]
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        title.text = "Choose account"
        title.font = .systemFont(ofSize: 34, weight: .bold)
        return title
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.tag = 104
        tableView.backgroundColor = UIColor.systemBackground
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        
        setupUI()
        self.updateView()
    }
    
    func updateView() {
        let defaults = UserDefaults(suiteName: "group.subscribesCounter")
        if let stringOne = defaults?.string(forKey: "accounts") {
            let arrayList = stringOne.components(separatedBy: "|-|")
            self.list = arrayList
            
            configureAsList()
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // title
            .init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0),
            .init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10),
            .init(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            
            // tableview
            .init(item: tableView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 20),
            .init(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    private func configureAsList() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
          return self.list.count
        default:
          return 0
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let data = Data(self.list[indexPath.row].utf8)
        
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let name = json["name"] as? String,
            let iconName = json["soc"] as? String,
            let icon = UIImage(named: iconName.lowercased())
        else { fatalError() }
        
        let cellModel = Cell.Model(title: name, image: icon)
        cell.configure(with: cellModel)
        
        return cell
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(x: 0, y: 139, width: Int(self.view.bounds.size.width), height: 60 * self.list.count)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
       coordinator.animate(alongsideTransition: { (contex) in
          self.updateLayout(with: size)
       }, completion: nil)
    }
}

extension ChooseAccontViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currItem = self.list[indexPath.row]
        let vc = ChooseColorViewController()
        vc.accountStr = currItem
        vc.sizeStr = "default"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

