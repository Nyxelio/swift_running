//
//  HistoryViewController.swift
//  running
//
//  Created by Developer on 18/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//
import UIKit
import Foundation
import CoreData


class HistoryViewController: UIViewController {
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
