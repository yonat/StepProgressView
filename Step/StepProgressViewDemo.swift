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

    let firstSteps = ["First", "Second", "Third can be very long and include a lot of unintersting text that spans several lines.", "Last but not least"]
    let secondSteps = ["Lorem ipsum dolor sit amet", "consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", "Excepteur sint occaecat cupidatat non proident", "sunt in culpa qui officia deserunt mollit anim id est laborum"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setTranslatesAutoresizingMaskIntoConstraints(false)

        // step progress
        steps = StepProgressView(frame: contentFrame.rectByInsetting(dx: 0, dy: 32))
        steps.steps = firstSteps
        view.addSubview(steps)

        // current step slider
        let slider = UISlider()
        slider.setTranslatesAutoresizingMaskIntoConstraints(false)
        slider.minimumValue = -1
        slider.maximumValue = Float(7)
        slider.value = -1
        slider.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)
        view.addSubview(slider)

        // steps switch
        let stepsLabel = UILabel(text: "Steps")
        view.addSubview(stepsLabel)
        let stepsSwitch = UISwitch(target: self, action: "stepsChanged:")
        view.addSubview(stepsSwitch)

        // color scheme switch
        let colorLabel = UILabel(text: "Colors")
        view.addSubview(colorLabel)
        let colorSwitch = UISwitch(target: self, action: "colorsChanged:")
        view.addSubview(colorSwitch)

        // sizes switch
        let sizeLabel = UILabel(text: "Sizes")
        view.addSubview(sizeLabel)
        let sizeSwitch = UISwitch(target: self, action: "sizeChanged:")
        view.addSubview(sizeSwitch)

        // shapes switch
        let shapeLabel = UILabel(text: "Shapes")
        view.addSubview(shapeLabel)
        let shapeSwitch = UISwitch(target: self, action: "shapeChanged:")
        view.addSubview(shapeSwitch)

        let bindings = NSDictionary(dictionary: [
            "slider": slider,
            "stepsLabel": stepsLabel, "stepsSwitch": stepsSwitch,
            "colorLabel": colorLabel, "colorSwitch": colorSwitch,
            "sizeLabel": sizeLabel, "sizeSwitch": sizeSwitch,
            "shapeLabel": shapeLabel, "shapeSwitch": shapeSwitch
        ])
        view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("|-[slider]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: bindings) )
        view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:[stepsLabel]-[stepsSwitch]-(24)-[colorLabel]-[colorSwitch]-(24)-[slider]-(24)-|", options: .AlignAllLeading, metrics: nil, views: bindings) )
        view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:[sizeLabel]-[sizeSwitch]-(24)-[shapeLabel]-[shapeSwitch]-(24)-[slider]", options: .AlignAllTrailing, metrics: nil, views: bindings) )
    }

    func sliderChanged(sender: UISlider) {
        steps.currentStep = Int(sender.value)
    }

    func stepsChanged(sender: UISwitch) {
        steps.steps = sender.on ? secondSteps : firstSteps
    }

    func colorsChanged(sender: UISwitch) {
        steps.pastStepColor = sender.on ? UIColor.blackColor() : UIColor.lightGrayColor()
        steps.pastTextColor = steps.pastStepColor
        steps.pastStepFillColor = steps.pastStepColor
        steps.currentStepColor = sender.on ? UIColor.redColor() : nil
        steps.currentTextColor = steps.currentStepColor
        steps.futureStepColor = sender.on ? UIColor.grayColor() : UIColor.lightGrayColor()
    }

    func sizeChanged(sender: UISwitch) {
        steps.lineWidth = sender.on ? 3 : 1
        steps.textFont = sender.on ? UIFont.systemFontOfSize( 1.5 * UIFont.buttonFontSize() ) : UIFont.systemFontOfSize( UIFont.buttonFontSize() )
        steps.horizontalPadding  = sender.on ? 8 : 0
    }

    func shapeChanged(sender: UISwitch) {
        steps.firstStepShape = sender.on ? .DownTriangle : .Circle
        steps.stepShape = sender.on ? .Rhombus : .Circle
        steps.lastStepShape = sender.on ? .Triangle : .Square
    }

    var contentFrame: CGRect {
        let fullFrame = view.bounds.rectsByDividing(UIApplication.sharedApplication().statusBarFrame.maxY, fromEdge: CGRectEdge.MinYEdge).remainder
        return fullFrame.rectByInsetting(dx: 16, dy: 16)
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        sizeToFit()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}

private extension UISwitch {
    convenience init(target: AnyObject, action: Selector) {
        self.init()
        addTarget(target, action: action, forControlEvents: .ValueChanged)
        setTranslatesAutoresizingMaskIntoConstraints(false)
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

