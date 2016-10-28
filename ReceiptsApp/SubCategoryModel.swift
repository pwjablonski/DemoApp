//
//  SubCategoryModel.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/17/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//

import UIKit

class SubCategoryModel: NSObject {
    
    var subCategoryList:[String:String] = [
        "4080 · CONTRIBUTIONS":"Account",
        "4700 · OTHER INCOME":"Account",
        "4800 · IN-KIND DONATIONS":"Account",
        "7000 · STAFF DEVELOPMENT":"Account",
        "8000 · OPERATING":"Account",
        "8500 · TECHNOLOGY & COMMUNICATIONS":"Account",
        "8600 · INSURANCE":"Account",
        "8800 · MARKETING":"Account",
        "9000 · OTHER EXPENSES":"Account",
        "9100 · ATHLETIC EVENTS":"Account",
        "9500 · PROCESSING FEES":"Account",
        "Program":"Class",
        "General Admin":"Class",
        "Fundraising":"Class",
        "Take Photo":"Photo",
        "Select Photo":"Photo",
        
                "Code/Interactive":"Program",
                "Camp/Internative":"Program",
                "Career/Interactive":"Program",
                "General Program":"Program",
        
        "Admin Exp":"General Admin",
        "General":"General Admin",
        
        "Athletic Events":"Fundraising",
        "Benefit Events":"Fundraising",
        "General Corp":"Fundraising",
        
        
        "4100 · Individual Donations" : "4080 · CONTRIBUTIONS",
        "4200 · Corporate Grants" : "4080 · CONTRIBUTIONS",
        "4300 · Foundation Grants": "4080 · CONTRIBUTIONS",
        "4400 · Board Member Donations": "4080 · CONTRIBUTIONS",
        "4500 · School Contributions": "4080 · CONTRIBUTIONS",
        
        
        "4715 · ePhilanthropy":"4700 · OTHER INCOME",
        "4775 · Miscellaneous Income":"4700 · OTHER INCOME",

        "7340 · Staff Development/Conferences":"7000 · STAFF DEVELOPMENT",
        "7360 · Expense Account":"7000 · STAFF DEVELOPMENT",
        

        "8300 · OCCUPANCY":"8000 · OPERATING",
        "8400 · OFFICE SUPPLIES & EXPENSE":"8000 · OPERATING",
        "8410 · Office / Program Supplies":"8000 · OPERATING",
        "8435 · Postage & Delivery":"8000 · OPERATING",
        "8460 · Bank Charges":"8000 · OPERATING",
        "8465 · Credit Card Fees":"8000 · OPERATING",
        
        "8512 · Computer/Technology Expense":"8500 · TECHNOLOGY & COMMUNICATIONS",
        "8518 · Web Hosting":"8500 · TECHNOLOGY & COMMUNICATIONS",
        "8530 · Telephone/Broadband/Wireless":"8500 · TECHNOLOGY & COMMUNICATIONS",
        "8572 · Software & Hardware":"8500 · TECHNOLOGY & COMMUNICATIONS",
        
        
        "8820 · Website":"8800 · MARKETING",
        "8825 · Printed Materials":"8800 · MARKETING",
        "8850 · TRAVEL, MEALS & ENTERTAINMENT":"8800 · MARKETING",
        "8865 · Local Travel":"8800 · MARKETING",
        "8870 · Meals":"8800 · MARKETING",
        "8875 · Hospitality":"8800 · MARKETING",
        "8890 · Long Distance Travel":"8800 · MARKETING",
        "8895 · Hotels / Occupancy":"8800 · MARKETING",



        "NY Code 11001":"Code/Interactive",
        "Cen TX Code 11002":"Code/Interactive",
        "General Code 11099":"Code/Interactive",

        "NY Summits 12001":"Camp/Internative",
        "Cen TX Summits 12002":"Camp/Internative",
        "General Summits 12099":"Camp/Internative",

        "NY Career 13001":"Career/Interactive",
        "Cen TX Career 13002":"Career/Interactive",
        "General Career 13099":"Career/Interactive",

        "NY Prog General  14001":"General Program",
        "Cen TX Prog General 14002":"General Program",
        "Gen Prog General 14099":"General Program",
        
        "NY Admin 21001":"Admin Exp",
        "NY General 23001":"Admin Exp",

       "NY Marathon 31101":"Athletic Events",
       
        "NY Gala 32201":"Benefit Events",
        "NY Summer Event 32301":"Benefit Events",
        "NY Miracle Day 32401":"Benefit Events",
        "Other Benefits 32900":"Benefit Events",

        "NY Gen Corp Funds 31001":"General Corp",
        "General Found":"General Corp",
        "NY Gen Found Funds 32001":"General Corp",
//        "General":"General Corp",
        "NY Gen Fund 33001":"General Corp"
        
        
    ]
    
    
    
    
    
    func subCategories(_ category:String) -> [String]{
        var shortList:[String] = []
        for subCategory in Array(subCategoryList.keys).sorted(){
            if subCategoryList[subCategory] == category{
                shortList += [subCategory]
            }
        }
        return shortList
    }
}


