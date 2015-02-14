//
//  AppDelegate.swift
//  Step
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

class StepProgressViewController: UIViewController {

    var steps: StepProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        steps = StepProgressView(frame: contentFrame)
        steps.steps = ["First", "Second", "Third", "Last"]
        view.addSubview(steps)

        let slider = UISlider(frame: view.bounds.rectsByDividing(128, fromEdge: CGRectEdge.MaxYEdge).slice.rectByInsetting(dx: 16, dy: 32))
        slider.minimumValue = -1
        slider.maximumValue = Float(steps.steps.count)
        slider.value = -1
        slider.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)
        view.addSubview(slider)
    }

    func sliderChanged(sender: UISlider) {
        steps.currentStep = Int(sender.value)
    }

    var contentFrame: CGRect {
        let fullFrame = view.bounds.rectsByDividing(UIApplication.sharedApplication().statusBarFrame.maxY, fromEdge: CGRectEdge.MinYEdge).remainder
        return fullFrame.rectByInsetting(dx: 16, dy: 16)
    }
}


@UIApplicationMain
class StepProgressViewDemo: UIResponder, UIApplicationDelegate {

    lazy var window = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = StepProgressViewController()
        window.makeKeyAndVisible()
        return true
    }
}

