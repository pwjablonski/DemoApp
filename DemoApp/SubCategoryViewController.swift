//
//  SubCategoryViewController.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/17/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//

import Foundation
import MessageUI

import UIKit

class SubCategoryViewController: UIViewController {
    
    var subCategoriesModel = SubCategoryModel()
    var category = ""
    var subcategories = [String]()
    var selection = ""
    weak var delegate: SubCategoryViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.listTableView)
        self.view.backgroundColor = UIColor.white
        self.subcategories = subCategoriesModel.subCategories(category: category)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.listTableView.frame = self.view.frame
    }
    
    lazy var listTableView: UITableView = {
        let view: UITableView = UITableView()
        view.separatorStyle = .singleLine
        view.register(UITableViewCell.self, forCellReuseIdentifier: "abc")
        view.dataSource = self
        view.rowHeight = 50.0
        view.delegate = self
        return view
    }()

    func setCategory(category: String) {
        self.category = category
    }
    
    func setSubCategories(){
        self.subcategories = subCategoriesModel.subCategories(category: category)
    }
    
    
    func hasSubCategories(category: String) -> Bool {
        let result = subCategoriesModel.subCategories(category: category)
        if result.count != 0 {
            return true
        }
        else{
            return false
        }
        
    }
    
}

extension SubCategoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "abc")!
        let row = indexPath.row
        cell.textLabel?.text = subcategories[row]
        return cell
    }
    
}

extension SubCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if hasSubCategories(category: subcategories[indexPath.row]) {
            let viewController = SubCategoryViewController()
            viewController.delegate = self
            viewController.view.backgroundColor = UIColor.white
            viewController.setCategory(category: subcategories[indexPath.row])
            viewController.setSubCategories()
             self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.selection = subcategories[indexPath.row]
            self.delegate?.subCategorySelectedAtIndexPath(category: self.category, selection: self.selection)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}

extension SubCategoryViewController: SubCategoryViewControllerDelegate {
    
    func subCategorySelectedAtIndexPath(category: String, selection: String)  {
        self.delegate?.subCategorySelectedAtIndexPath(category: self.category, selection: selection)
    }
    
}



extension SubCategoryViewController: UINavigationControllerDelegate {}



