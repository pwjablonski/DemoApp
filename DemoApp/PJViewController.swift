//
//  PJViewController.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/13/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//
import MessageUI

import UIKit

class PJViewController: UIViewController {
    
    let categories = ["Account", "Class", "Date"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.listTableView)
        self.view.addSubview(self.photoButton)
        self.view.addSubview(self.sendInfoButton)
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.listTableView.frame = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 150.0)
        self.photoButton.frame = CGRect(x: 0.0, y: 150.0, width: 375.0, height: 50.0)
        self.sendInfoButton.frame = CGRect(x: 0.0, y: 300, width: 375.0, height: 50.0)
        
    }

    lazy var listTableView: UITableView = {
        let view: UITableView = UITableView()
        view.separatorStyle = .SingleLine
        view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "abc")
        view.dataSource = self
        view.rowHeight = 50.0
        view.delegate = self
        return view
    }()
    
    lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Photo", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.addTarget(self, action: #selector(takePhoto), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func takePhoto(){
        let photoViewController = UIImagePickerController()
        photoViewController.sourceType = .PhotoLibrary
        photoViewController.delegate = self
        self.navigationController?.presentViewController(photoViewController, animated: true, completion: nil)
    }
    
    lazy var sendInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.addTarget(self, action: #selector(sendInfo), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func sendInfo(){
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        
        if MFMailComposeViewController.canSendMail() {
            self.navigationController?.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            print("errror")
        }
    }
}

extension PJViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("abc")!
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
}

extension PJViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(viewController, animated: true)
        print("You selected cell #\(self.categories[indexPath.row])!")
    }
}

extension PJViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true) { 
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .ScaleAspectFill
            self.view.addSubview(imageView)
            imageView.frame = CGRect(x: 125.0, y: 200.0, width: 100.0, height: 100.0)
        }
    }
    
}

extension PJViewController: UINavigationControllerDelegate {}

extension PJViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: NSError){
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}
