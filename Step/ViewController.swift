//
//  ViewController.swift
//  Step
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        let steps = StepProgressView(frame:view.bounds)
        steps.steps = ["First", "Second", "Third", "Last"]
        view.addSubview(steps)
    }

}

