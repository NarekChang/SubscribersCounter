//
//  WidgetsViewController.swift
//  Subscribers Counter
//
//  Created by 18476693 on 05.10.2020.
//

import UIKit

class WidgetsViewController: UIViewController {

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
        title.text = "Widgets"
        title.font = titleFont
        self.view.addSubview(title)
        
        let topMargin = (self.view.bounds.size.height - 72) / 2

        let addTextFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        let addText = UILabel(frame: CGRect(x: 0, y: topMargin, width: self.view.bounds.size.width, height: 41))
        addText.textAlignment = .center
        addText.text = "Add widgets to get started"
        addText.font = addTextFont
        self.view.addSubview(addText)
        
        let goToAccountsList = UIAction(title: "GoToAccountsList") { (action) in
            let topMargin = self.view.bounds.height
            print("Refresh the data.", topMargin, self.view.bounds.size.height)
        }
        let addBtn = UIButton(frame: CGRect(x: 0, y: topMargin + 48, width: self.view.bounds.size.width, height: 24), primaryAction: goToAccountsList)
        addBtn.setTitle("Add widget", for: .normal)
        addBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        
        self.view.addSubview(addBtn)
    }

}
