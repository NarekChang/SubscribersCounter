//
//  WidgetsViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 05.10.2020.
//

import UIKit

class WidgetsViewController: UIViewController, UITableViewDataSource {
    // Properties
    var list: Array<String> = ["{\"size\":\"Small\",\"soc\":\"tiktok\",\"name\":\"zachking\",\"color\":\"White\"}"]
    
    // UI
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        title.text = "Widgets"
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
        tableView.register(Cell2.self, forCellReuseIdentifier: "Cell2")
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
        self.updateView()
    }
    
    private func configureAsList() {
        self.tableView.reloadData()
        
        tableView.isHidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add widget",
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem?.action = #selector(buttonClicked(sender:))
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
            self.navigationController?.pushViewController(ChooseAccontViewController(), animated: true)
        }
        let addBtn = UIButton(frame: CGRect(x: 0, y: topMargin + 48, width: self.view.bounds.size.width, height: 24), primaryAction: goToAccountsList)
        addBtn.setTitle("Add account", for: .normal)
        addBtn.tag = 5595
        addBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        
        self.view.addSubview(addBtn)
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(ChooseAccontViewController(), animated: true)
    }
    
    func setUI() {
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
    
    func updateView() {
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: "widgets") {
            let arrayList = stringOne.components(separatedBy: "|-|")
            self.list = arrayList
            
            configureAsList()
        } else {
            configureAsEmpty()
        }
    }

    // MAKK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Cell2
        let data = Data(list[indexPath.row].utf8)
        
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let name = json["name"] as? String,
            let iconName = json["soc"] as? String,
            let icon = UIImage(named: iconName.lowercased()),
            let size = json["size"] as? String,
            let color = json["color"] as? String
        else { fatalError() }
        
        let cellModel = Cell2.Model(title: name, image: icon, size: size, color: color)
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
                defaults.removeObject(forKey: "widgets")
            } else {
                defaults.set("\(result)", forKey: "widgets")
            }
            
            self.updateView()
        }
    }
}

final class Cell2: UITableViewCell {
    
    // Model
    struct Model {
        let title: String
        let image: UIImage
        let size: String
        let color: String
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
    
    private lazy var colorSize: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.gray
        label.textAlignment = .right
        return label
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
        colorSize.text = nil
    }
    
    // Configure
    
    func configure(with model: Model) {
        icon.image = model.image
        title.text = model.title
        colorSize.text = "\(model.color) · \(model.size)"
    }
    
    // MARK: - Private
    
    private func setupUI() {
        addSubview(title)
        addSubview(icon)
        addSubview(colorSize)
        
        NSLayoutConstraint.activate([
            // Icon
            .init(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: icon, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16),
            .init(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22),
            .init(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22),

            // Title
            .init(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: title, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1, constant: 8),
            .init(item: title, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            
            
            .init(item: colorSize, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: colorSize, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16),
        ])
    }
}
