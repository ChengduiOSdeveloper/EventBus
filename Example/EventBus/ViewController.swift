//
//  ViewController.swift
//  EventBus
//
//  Created by ylei11@volvocars.com on 07/24/2021.
//  Copyright (c) 2021 ylei11@volvocars.com. All rights reserved.
//

import UIKit
import EventBus

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        EventBusCenter.default.add(self, name: "test", object: nil, action: #selector(testAction(sender:)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            EventBusCenter.default.call("test", object: nil, userInfo: ["name": "jack"])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func testAction(sender: AnyObject) {
        guard let eventBus = sender as? EventBus else { return }
        print(eventBus)
    }

}

