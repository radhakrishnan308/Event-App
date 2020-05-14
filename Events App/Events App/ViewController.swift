//
//  ViewController.swift
//  Events App
//
//  Created by radhakrishnan on 13/05/20.
//  Copyright © 2020 radhakrishnan. All rights reserved.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController {
    
    //IB Outlets
    @IBOutlet var productIDTypeTextField: UITextField!
    @IBOutlet var emailTypeTextField: UITextField!
    @IBOutlet var eventTypeTextField: UITextField!
        
    //CleverTap Instance
    lazy var cleverTapAdditionalInstance: CleverTap = {
        let ctConfig = CleverTapInstanceConfig.init(accountId: "445-8WK-985Z", accountToken: "30b-544")
        return CleverTap.instance(with: ctConfig)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func eventButtonTapped(_ sender: Any) {
        
        // event with properties
        let props = [
            "Product name": "CleverTap",
            "Product ID": productIDTypeTextField.text!,
            "Product Image": "https://d35fo82fjcw0y8.cloudfront.net/2018/07/26020307/customer-success-clevertap.jpg",
            "Date": NSDate(),
            "Email": emailTypeTextField.text!
            ] as [String : Any]

        cleverTapAdditionalInstance.recordEvent(eventTypeTextField.text!, withProps: props)

        //Push Profile
        let profile: Dictionary<String, String> = [
            //Update pre-defined profile properties
            "Name": "Radhakrishnan",
            "Email": emailTypeTextField.text!,
            //Update custom profile properties
            "type": "Admin",
            "App": "Sample Events App"
        ]
        cleverTapAdditionalInstance.profilePush(profile)
    }
}

