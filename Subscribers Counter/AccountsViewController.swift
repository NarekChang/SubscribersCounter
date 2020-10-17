//
//  AccountsViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 05.10.2020.
//

import UIKit

struct Account: Codable {
    var name: String
    var soc: String
}

class AccountsViewController: UIViewController, UITableViewDataSource {
    
    // Properties
    var list: Array<String> = ["{\"name\":\"\",\"soc\":\"twitter\"}"]
    
    // UI
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        title.text = "Accounts"
        title.font = .systemFont(ofSize: 34, weight: .bold)
        return title
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.tag = 104
        tableView.backgroundColor = UIColor.systemBackground
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        self.updateView()
    }
    
    func updateView() {
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: "accounts") {
            let arrayList = stringOne.components(separatedBy: "|-|")
            print("arrayList")
            print(arrayList)
            self.list = arrayList
            
            configureAsList()
        } else {
            configureAsEmpty()
        }
    }
    
    // MARK: - Private
    
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
        
        tableView.isHidden = false
        
        if let viewWithTag = self.view.viewWithTag(1444) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag2 = self.view.viewWithTag(5595) {
            viewWithTag2.removeFromSuperview()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add account",
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem?.action = #selector(buttonClicked(sender:))
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(ChooseSocialNetworkViewController(), animated: true)
    }
    
    private func configureAsEmpty() {
        self.navigationItem.rightBarButtonItem = nil
        tableView.isHidden = true
        
        let topMargin = (self.view.bounds.size.height - 72) / 2

        let addTextFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        let addText = UILabel(frame: CGRect(x: 0, y: topMargin, width: self.view.bounds.size.width, height: 41))
        addText.textAlignment = .center
        addText.text = "Add account to get started"
        addText.font = addTextFont
        addText.tag = 1444
        self.view.addSubview(addText)
        
        let goToAccountsList = UIAction(title: "GoToAccountsList") { (action) in
            self.navigationController?.pushViewController(ChooseSocialNetworkViewController(), animated: true)
        }
        let addBtn = UIButton(frame: CGRect(x: 0, y: topMargin + 48, width: self.view.bounds.size.width, height: 24), primaryAction: goToAccountsList)
        addBtn.setTitle("Add account", for: .normal)
        addBtn.tag = 5595
        addBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        
        self.view.addSubview(addBtn)
    }
    
    // MAKK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let data = Data(list[indexPath.row].utf8)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            var result: String = ""
            
            for i in 0..<list.count {
                result.append(list[i])
                
                if i != list.count - 1 {
                    result.append("|-|")
                    
                }
            }
            
            let defaults = UserDefaults.standard
            
            if list.count == 0 {
                defaults.removeObject(forKey: "accounts")
            } else {
                defaults.set("\(result)", forKey: "accounts")
            }
            
            self.updateView()
        }
    }
}

final class Cell: UITableViewCell {
    
    // Model
    struct Model {
        let title: String
        let image: UIImage
    }
    
    // UI
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        title.text = nil
    }
    
    // Configure
    
    func configure(with model: Model) {
        icon.image = model.image
        title.text = model.title
    }
    
    // MARK: - Private
    
    private func setupUI() {
        addSubview(title)
        addSubview(icon)
        
        NSLayoutConstraint.activate([
            // Icon
            .init(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: icon, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16),
            .init(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22),
            .init(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22),

            // Title
            .init(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: title, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1, constant: 8),
            .init(item: title, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        ])
    }
}
