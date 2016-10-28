//
//  SubCategoryViewControllerDelegate.swift
//  DemoApp
//
//  Created by Peter Jablonski on 10/20/16.
//  Copyright © 2016 Peter Jablonski. All rights reserved.
//

import Foundation

protocol SubCategoryViewControllerDelegate: class {
    func subCategorySelectedAtIndexPath(_ category: String, selection: String)
}
