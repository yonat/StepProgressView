//
//  AppDelegate.swift
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import StepProgressView
import SweeterSwift
import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

class StepProgressViewController: UIViewController {
    @IBOutlet var steps: StepProgressView!

    let firstSteps = [
        "First",
        "Second",
        "Third can be very long and include a lot of unintersting text that spans several lines.",
        "Last but not least",
    ]
    let secondSteps = [
        "Lorem ipsum dolor sit amet",
        "consectetur adipiscing elit",
        "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
        "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",
        "Excepteur sint occaecat cupidatat non proident",
        "sunt in culpa qui officia deserunt mollit anim id est laborum",
    ]
    let details = [
        1: "Short descriotion",
        3: "Kind of long rambling explanation that no one reads in reality.",
    ]

    let margin: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: margin * 2, left: margin, bottom: margin, right: margin)

        steps = StepProgressView()
        steps.steps = firstSteps
        steps.details = details
        view.addConstrainedSubview(steps, constrain: .leftMargin, .rightMargin, .topMargin)
        steps.layoutMargins = .zero

        loadControls()
    }

    func loadControls() {
        // current step slider
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = Float(7)
        slider.value = -1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        view.addSubview(slider)

        // steps switch
        let stepsLabel = UILabel(text: "Steps")
        view.addSubview(stepsLabel)
        let stepsSwitch = UISwitch(target: self, action: #selector(stepsChanged))
        view.addSubview(stepsSwitch)

        // color scheme switch
        let colorLabel = UILabel(text: "Colors")
        view.addSubview(colorLabel)
        let colorSwitch = UISwitch(target: self, action: #selector(colorsChanged))
        view.addSubview(colorSwitch)

        // sizes switch
        let sizeLabel = UILabel(text: "Sizes")
        view.addSubview(sizeLabel)
        let sizeSwitch = UISwitch(target: self, action: #selector(sizeChanged))
        view.addSubview(sizeSwitch)

        // shapes switch
        let shapeLabel = UILabel(text: "Shapes")
        view.addSubview(shapeLabel)
        let shapeSwitch = UISwitch(target: self, action: #selector(shapeChanged))
        view.addSubview(shapeSwitch)

        let bindings = [
            "slider": slider,
            "stepsLabel": stepsLabel, "stepsSwitch": stepsSwitch,
            "colorLabel": colorLabel, "colorSwitch": colorSwitch,
            "sizeLabel": sizeLabel, "sizeSwitch": sizeSwitch,
            "shapeLabel": shapeLabel, "shapeSwitch": shapeSwitch,
        ]
        addConstraints(withVisualFormat: "|-[slider]-|", views: bindings)
        addConstraints(
            withVisualFormat: "V:[stepsLabel]-[stepsSwitch]-(24)-[colorLabel]-[colorSwitch]-(24)-[slider]-(24)-|",
            options: .alignAllLeading,
            views: bindings
        )
        addConstraints(
            withVisualFormat: "V:[sizeLabel]-[sizeSwitch]-(24)-[shapeLabel]-[shapeSwitch]-(24)-[slider]",
            options: .alignAllTrailing,
            views: bindings
        )

        // SwiftUI button
        if #available(iOS 13.0, *) {
            let showSwiftUIButton = UIButton(title: "Show in SwiftUI View", target: self, action: #selector(showSwiftUIDemo))
            view.addConstrainedSubview(showSwiftUIButton, constrain: .rightMargin, .topMargin)
            showSwiftUIButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            showSwiftUIButton.layer.borderWidth = 1
            let color = view.actualTintColor
            showSwiftUIButton.setTitleColor(color, for: .normal)
            showSwiftUIButton.layer.borderColor = color.cgColor
            DispatchQueue.main.async {
                showSwiftUIButton.layer.cornerRadius = showSwiftUIButton.frame.height / 2
            }
        }
    }

    @objc func sliderChanged(_ sender: UISlider) {
        steps.currentStep = Int(sender.value)
    }

    @objc func stepsChanged(_ sender: UISwitch) {
        steps.steps = sender.isOn ? secondSteps : firstSteps
        steps.details = sender.isOn ? [:] : details
    }

    @objc func colorsChanged(_ sender: UISwitch) {
        steps.pastStepColor = sender.isOn ? UIColor.black : UIColor.lightGray
        steps.pastTextColor = steps.pastStepColor
        steps.pastStepFillColor = steps.pastStepColor
        steps.currentStepColor = sender.isOn ? UIColor.red : nil
        steps.currentTextColor = steps.currentStepColor
        steps.currentDetailColor = sender.isOn ? UIColor.brown : UIColor.darkGray
        steps.futureStepColor = sender.isOn ? UIColor.gray : UIColor.lightGray
    }

    @objc func sizeChanged(_ sender: UISwitch) {
        steps.lineWidth = sender.isOn ? 3 : 1
        steps.textFont = sender.isOn ? UIFont.systemFont(ofSize: 1.5 * UIFont.buttonFontSize) : UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        steps.horizontalPadding = sender.isOn ? 8 : 0
    }

    @objc func shapeChanged(_ sender: UISwitch) {
        steps.firstStepShape = sender.isOn ? .downTriangle : .circle
        steps.stepShape = sender.isOn ? .rhombus : .circle
        steps.lastStepShape = sender.isOn ? .triangle : .square
    }

    @objc func showSwiftUIDemo() {
        #if canImport(SwiftUI)
        if #available(iOS 13.0, *) {
            present(UIHostingController(rootView: StepsViewDemo()), animated: true)
        }
        #endif
    }

    func addConstraints(withVisualFormat format: String, options: NSLayoutConstraint.FormatOptions = [], views: [String: Any]) {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: views))
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension UISwitch {
    convenience init(target: AnyObject, action: Selector) {
        self.init()
        addTarget(target, action: action, for: .valueChanged)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension UIButton {
    convenience init(title: String?, target: AnyObject, action: Selector) {
        self.init()
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

@UIApplicationMain
class StepProgressViewDemo: UIResponder, UIApplicationDelegate {
    lazy var mainWindow = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainWindow.backgroundColor = UIColor.white
        mainWindow.rootViewController = StepProgressViewController()
        mainWindow.makeKeyAndVisible()
        return true
    }
}
