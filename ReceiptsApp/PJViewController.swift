//
//  PJViewController.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/13/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//
import MessageUI
import GoogleAPIClientForREST
import GoogleAPIClient
import GTMOAuth2
import UIKit

class PJViewController: UIViewController {
    
    let categories = CategoryModel()
    var details = DetailModel()
    
    var selectedImage = UIImage()
    var firstSelected = ""
    var selectedAccount = ""
    var selectedClass = ""
    var selectedDate = Date()
    var imageView = UIImageView()
    var fileAddress = ""
    //var imageData = UIImagePNGRepresentation()
    
    // GOOGLE SHEETS
    fileprivate let kKeychainItemName = "Google Sheets API"
    fileprivate let kClientID = "1017222674807-157d6lfu8rdvikic4rtvkmbsnaip9gut.apps.googleusercontent.com"
    fileprivate let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly, kGTLRAuthScopeSheetsSpreadsheets, kGTLAuthScopeDrive]
    fileprivate let service = GTLRSheetsService()
    
    // GOOGLE DRIVE
    fileprivate let kKeychainItemNameDRIVE = "Drive API"
    fileprivate let kClientIDDRIVE = "1017222674807-s8ukrgagqrmjpb7f6aq5gg73d6ck2h98.apps.googleusercontent.com"
    fileprivate let scopesDRIVE = [kGTLAuthScopeDriveMetadataReadonly, kGTLAuthScopeDrive]
    fileprivate let serviceDRIVE = GTLServiceDrive()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.listTableView)
        self.view.addSubview(self.sendInfoButton)
        self.view.backgroundColor = UIColor.white
        setDateFormatter()
        // Do any additional setup after loading the view, typically from a nib.
        //GOOGLE SHEETS
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            //service.authorizer = auth
            service.authorizer = auth
            serviceDRIVE.authorizer = auth
        }
        
//        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
//            forName: kKeychainItemName,
//            clientID: kClientID,
//            clientSecret: nil) {
//            service.authorizer = auth
//        }
    }
    
    
    // When the view appears, ensure that the Google Sheets API service is authorized
    // and perform API calls
    override func viewDidAppear(_ animated: Bool) {
       // GOOGLE SHEETS
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize , canAuth {
            fetchFiles()
            //listMajors()
        }
        else {
            present(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    /////////////////GOOGLE SHEETS
    // Creates the auth controller for authorizing access to Google Sheets API
    fileprivate func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joined(separator: " ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(PJViewController.viewController(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Google Sheets API
    // with the new credentials.
    func viewController(_ vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        serviceDRIVE.authorizer = authResult
        service.authorizer = authResult
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(_ title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func appendValues(){
        //output.text = "Updating sheet data"
        let spreadsheetId = "1tWe4Z6BLEcGuHzxjD3R0TYVJqjttD_-Q0p3LszNmp8k"
        let range = "CurrentExpenses!A1:F"
        let object = GTLRSheets_ValueRange.init()
        
        object.values = [
            ["\(dateFormatter.string(from: self.selectedDate))", "\(amountTextField.text!)","\(descriptionTextField.text!)", "\(details.details[2])", "\(details.details[3])", "\(details.details[4])", "\(self.fileAddress)"]
        ]
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: object, spreadsheetId: spreadsheetId, range:range)
        query.valueInputOption = "USER_ENTERED"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(PJViewController.appendValuesResultWithTicket(_:finishedWithObject:error:))
            
        )
    }
    
    
    
    func appendValuesResultWithTicket(_ ticket: GTLRServiceTicket,
                                      finishedWithObject result : GTLRSheets_ValueRange,
                                      error : NSError?){
    }
    

    ///////////////////////
    /// Google DRIVE
    func fetchFiles() {
   
        let query = GTLQueryDrive.queryForFilesList()
        query?.pageSize = 10
        query?.fields = "nextPageToken, files(id, name)"
        serviceDRIVE.executeQuery(
            query!,
            delegate: self,
            didFinish: #selector(PJViewController.displayResultWithTicketDrive(_:finishedWithObject:error:))
        )
    }
    
    
    
    // Parse results and display
    func displayResultWithTicketDrive(_ ticket : GTLServiceTicket,
                                 finishedWithObject response : GTLDriveFileList,
                                 error : NSError?) {
        
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        var filesString = ""
        
        if let files = response.files , !files.isEmpty {
            filesString += "Files:\n"
            for file in files as! [GTLDriveFile] {
                filesString += "\(file.name) (\(file.identifier))\n"
            }
        } else {
            filesString = "No files found."
        }
        
        print(filesString)
    }

    func uploadImageToDrive(image: UIImage){
        let driveService = serviceDRIVE;
        let imageData = UIImagePNGRepresentation(image)
        let name = "\(details.details[2]) Receipt.png";
        let mimeType = "image/png";
        let metadata = GTLDriveFile();
        metadata.name = name;
        metadata.parents = ["0ByIVIYzVtbs2Rld5N05hMklZSWc"]
        //let data = content.data(using: String.Encoding.utf8)
        let data = imageData
        
        let uploadParameters = GTLUploadParameters(data: data!, mimeType: mimeType)
        let query = GTLQueryDrive.queryForFilesCreate(withObject: metadata, uploadParameters: uploadParameters)
        driveService.executeQuery(query!, completionHandler: {(ticket, updatedFile, error) -> Void in
            if error == nil {
                var newFile = GTLDriveFile()
                newFile = updatedFile as! GTLDriveFile
                print("#########################")
                print("File \(newFile.identifier)")
                self.fileAddress = "https://drive.google.com/open?id=\(newFile.identifier)"
            }
            else {
                print("An error occurred: \(error)")
            }
        })
    }
    
    
    /////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.listTableView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 420.0)
        self.datePicker.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 200.0)
        self.sendInfoButton.frame = CGRect(x: 10.0, y: 450, width: self.view.frame.width - 20, height: 50.0)
    }

    lazy var listTableView: UITableView = {
        let view: UITableView = UITableView()
        view.separatorStyle = .singleLine
        view.register(NonsenseCell.self, forCellReuseIdentifier: "EventCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "DatePickerCell")
        view.dataSource = self
        view.rowHeight = 70.0
        view.delegate = self
        return view
    }()
    
    var datePickerIndexPath: IndexPath?
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        return datePicker
    }()
    
    var dateFormatter = DateFormatter()
    
    func setDateFormatter() { // called in viewDidLoad()
        dateFormatter.dateStyle = .short
    }
    
    
    
    func takePhoto(_ choice: String){
        let photoViewController = UIImagePickerController()
        if choice == "Take Photo" {
            photoViewController.sourceType = .camera
        }else{
            photoViewController.sourceType = .photoLibrary
        }
        photoViewController.delegate = self
        self.navigationController?.present(photoViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    lazy var sendInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(red: 23.0/255.0 , green:  68.0/255.0 , blue :  116.0/255.0 , alpha: 1.0)
        
        button.addTarget(self, action: #selector(sendInfo), for: .touchUpInside)
        return button
    }()
    
    func sendInfo(){
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["peter@weare.ci"])
        mailComposerVC.setSubject("Receipt Message to CI")
        mailComposerVC.setMessageBody("New receipt from CI: \n Amount: \(amountTextField.text!) \n Description: \(descriptionTextField.text!) \n Date of Purchase: \(details.details[2]) \n Account: \(details.details[3]) \n Class: \(details.details[4])  \n Date Sent to cc@weare.ci: \(dateFormatter.string(from: self.selectedDate))", isHTML: false)
        var imageData = UIImagePNGRepresentation(self.selectedImage)
        mailComposerVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "image")
        
        if MFMailComposeViewController.canSendMail() {
            self.navigationController?.present(mailComposerVC, animated: true, completion: nil)
        } else {
            print("errror")
        }
        
        uploadImageToDrive(image: self.selectedImage)
        appendValues()
        
        self.clearDetails()
    }
    
    lazy var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.returnKeyType = UIReturnKeyType.done
        descriptionTextField.borderStyle = UITextBorderStyle.roundedRect
        descriptionTextField.placeholder = "Enter Description"
        descriptionTextField.delegate = self
        return descriptionTextField
    }()
    
    lazy var amountTextField: UITextField = {
        let amountTextField = UITextField()
        amountTextField.returnKeyType = UIReturnKeyType.done
        amountTextField.borderStyle = UITextBorderStyle.roundedRect
        amountTextField.placeholder = "Enter $ Amount"
        amountTextField.delegate = self
        return amountTextField
    }()
    
}

extension PJViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = categories.category.count
        
        if datePickerIndexPath != nil {
            rows += 1
        }

        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell: UITableViewCell
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
            cell.addSubview(self.datePicker)
            return cell
        } else {
            let cell: NonsenseCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! NonsenseCell
            cell.textLabel?.text = categories.category[row]
            if cell.textLabel?.text == "Photo" {
                cell.contentView.addSubview(self.imageView)
            }else if cell.textLabel?.text == "Description"{
                descriptionTextField.frame = CGRect(x:10.0, y: 10.0, width: self.listTableView.frame.width - 20, height: 50.0)
                cell.contentView.addSubview(descriptionTextField)
                
            }
            else if cell.textLabel?.text == "Amount"{
                amountTextField.frame = CGRect(x:10.0, y: 10.0, width: self.listTableView.frame.width - 20, height: 50.0)
                cell.contentView.addSubview(amountTextField)
                
            }
            else{
                cell.detailTextLabel?.text = details.details[row]
            }
            return cell
        }
    }
    
    func clearDetails(){
        for num in 0...details.details.count - 1{
            details.details[num] = ""
        }
        self.imageView.image = UIImage()
        self.listTableView.reloadData()
    }
}

class NonsenseCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PJViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let row = indexPath.row
        let cellText = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        if cellText == "Date"{
           //tableView.beginUpdates() // because there are more than one action below
            if datePickerIndexPath != nil && (datePickerIndexPath!.row - 1) == indexPath.row { // case 2
                let rowToDelete = datePickerIndexPath!.row
                datePickerIndexPath = nil
                tableView.deleteRows(at: [IndexPath(row: rowToDelete, section: 0)], with: .fade)
                details.details[2] = dateFormatter.string(from: self.datePicker.date)
                self.listTableView.reloadData()
            
            } else { // case 1、3
                datePickerIndexPath = IndexPath(row: row + 1, section: 0)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            }
            tableView.deselectRow(at: indexPath, animated: true)
         //   tableView.endUpdates()
        }
        else if cellText == "Description" {
        }
        else if cellText == "Amount" {
        }
        else {
            self.firstSelected = categories.category[row]
            let viewController = SubCategoryViewController()
            viewController.delegate = self
            viewController.view.backgroundColor = UIColor.white
            viewController.setCategory(category: categories.category[row])
            viewController.setSubCategories()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = tableView.rowHeight
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            _ = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
            rowHeight = 200
            print("reset height!")
        }
        return rowHeight
    }
}



extension PJViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true) { 
            
            self.selectedImage = image
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFill
            
            
            
            //self.view.addSubview(self.imageView)
            self.imageView.frame = CGRect(x: self.listTableView.frame.width - 100, y: 12.0, width: 50.0, height: 50.0)
            
            
            self.listTableView.reloadData()
        }
    }
}

extension PJViewController: UINavigationControllerDelegate {}

extension PJViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?){
        self.dismiss(animated: false, completion: nil)
        print(error)
    }
}

extension PJViewController: SubCategoryViewControllerDelegate {
    func subCategorySelectedAtIndexPath(_ category: String, selection: String) {
        if category == "Account" {
            self.details.details[3] = selection
        }
        if category == "Class" {
            self.details.details[4] = selection
        }
        if category == "Photo"{
            takePhoto(selection)
        }
        self.listTableView.reloadData()
        
    }
}

extension PJViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

var categories2: [String:Any] = [
    "Account" : [
        "4080 · CONTRIBUTIONS" : [
            "4100 · Individual Donations" :[],
            "4200 · Corporate Grants" :[],
            "4300 · Foundation Grants":[],
            
            "4400 · Board Member Donations":[],
            
            "4500 · School Contributions":[],
        ],
        "4700 · OTHER INCOME" : [
            "4715 · ePhilanthropy",
            "4775 · Miscellaneous Income"
        ],
        "4800 · IN-KIND DONATIONS" : [
            "4800 · IN-KIND DONATIONS"
        ],
        "7000 · STAFF DEVELOPMENT" : [
            "7340 · Staff Development/Conferences",
            "7360 · Expense Account"
        ],
        "8000 · OPERATING" : [
            "8300 · OCCUPANCY",
            "8400 · OFFICE SUPPLIES & EXPENSE",
            "8410 · Office / Program Supplies",
            "8435 · Postage & Delivery",
            "8460 · Bank Charges",
            "8465 · Credit Card Fees"
        ],
        "8500 · TECHNOLOGY & COMMUNICATIONS" : [
            "8512 · Computer/Technology Expense",
            "8518 · Web Hosting",
            "8530 · Telephone/Broadband/Wireless",
            "8572 · Software & Hardware",
        ],
        "8600 · INSURANCE" : [
            "8600 · INSURANCE"
        ],
        "8700 · PROFESSIONAL FEES" : [
            "8700 · PROFESSIONAL FEES"
        ],
        "8800 · MARKETING" : [
            "8820 · Website",
            "8825 · Printed Materials",
            "8850 · TRAVEL, MEALS & ENTERTAINMENT",
            "8865 · Local Travel",
            "8870 · Meals",
            "8875 · Hospitality",
            "8890 · Long Distance Travel",
            "8895 · Hotels / Occupancy"
        ],
        "9000 · OTHER EXPENSES" : [
            "9000 · OTHER EXPENSES"
        ],
        "9100 · ATHLETIC EVENTS" : [
            "9100 · ATHLETIC EVENTS"
        ],
        "9500 · PROCESSING FEES": [
            "9500 · PROCESSING FEES"
        ]
    ],
    
    "Class" : [
        "Program" : [
            "Code/Interactive" : [
                "NY Code 11001",
                "Cen TX Code 11002",
                "General Code 11099"
            ],
            "Camp/Internative": [
                "NY Summits 12001",
                "Cen TX Summits 12002",
                "General Summits 12099"
            ],
            "Career/Interactive" : [
                "NY Career 13001",
                "Cen TX Career 13002",
                "General Career 13099"
            ],
            "Genearl" : [
                "NY Prog General  14001",
                "Cen TX Prog General 14002",
                "Gen Prog General 14099"
            ]
        ],
        "General Admin" : [
            "Admin Exp" : [
                "NY Admin 21001"
            ],
            "General" : [
                "NY General 23001"
            ]
        ],
        "Fundraising" : [
            "Athletic Events": [
                "NY Marathon 31101"
            ],
            "Benefit Events" : [
                "NY Gala 32201",
                "NY Summer Event 32301",
                "NY Miracle Day 32401",
                "Other Benefits 32900",
            ],
            "General Corp" : [
                "NY Gen Corp Funds 31001",
                "General Found",
                "NY Gen Found Funds 32001",
                "General",
                "NY Gen Fund 33001"
            ]
        ]
    ]
]


