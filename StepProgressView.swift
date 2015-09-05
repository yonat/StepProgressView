//
//  StepProgressView.swift
//  Show step-by-step progress.
//
//  Usage:
//      progress = StepProgressView(frame: someFrame)
//      progress.steps = ["First", "Second", "Third", "Last"]
//      progress.currentStep = 0
//      ... when all done:
//      progress.currentStep = 4
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

class StepProgressView: UIView {

    // MARK: - Behavior

    /// Titles of the step-by-step progression stages
    var steps: [String] = []                    { didSet {needsSetup = true} }

    /// Current active step: -1 = not started, steps.count = all done.
    var currentStep: Int = -1                   { didSet {needsColor = true} }

    // MARK: - Appearance

    enum Shape {
        case Circle
        case Square
        case Triangle
        case DownTriangle
        case Rhombus
    }

    var stepShape: Shape = .Circle              { didSet {needsSetup = true} }
    var firstStepShape: Shape = .Circle         { didSet {needsSetup = true} }
    var lastStepShape: Shape = .Square          { didSet {needsSetup = true} }

    var lineWidth: CGFloat = 1                  { didSet {needsSetup = true} }
    var textFont: UIFont = UIFont.systemFontOfSize( UIFont.buttonFontSize() )
        { didSet {needsSetup = true} }

    var verticalPadding: CGFloat = 0 // between steps (0 => default based on textFont)
        { didSet {needsSetup = true} }
    var horizontalPadding: CGFloat = 0 // between shape and text (0 => default based on textFont)
        { didSet {needsSetup = true} }

    // MARK: - Colors

    var futureStepColor:  UIColor = UIColor.lightGrayColor() { didSet {needsColor = true} }
    var pastStepColor:    UIColor = UIColor.lightGrayColor() { didSet {needsColor = true} }
    var currentStepColor: UIColor? = nil // nil => the view's tintColor
        { didSet {needsColor = true} }

    var futureStepFillColor:  UIColor = UIColor.clearColor() { didSet {needsColor = true} }
    var pastStepFillColor:    UIColor = UIColor.lightGrayColor() { didSet {needsColor = true} }
    var currentStepFillColor: UIColor = UIColor.clearColor() { didSet {needsColor = true} }

    var futureTextColor:  UIColor = UIColor.lightGrayColor() { didSet {needsColor = true} }
    var pastTextColor:    UIColor = UIColor.lightGrayColor() { didSet {needsColor = true} }
    var currentTextColor: UIColor? = nil // nil => the view's tintColor
        { didSet {needsColor = true} }


    // MARK: - Overrides

    override func tintColorDidChange() {
        if nil == currentStepColor || nil == currentTextColor {
            needsColor = true
        }
    }

    // MARK: - Private

    private var stepViews: [SingleStepView] = []

    private var needsSetup: Bool = false {
        didSet {
            if needsSetup && !oldValue {
                dispatch_async(dispatch_get_main_queue()) {[weak self] in
                    if true == self?.needsSetup {
                        self!.setupStepViews()
                    }
                }
            }
        }
    }

    private var needsColor: Bool = false {
        didSet {
            if needsColor && !oldValue {
                dispatch_async(dispatch_get_main_queue()) {[weak self] in
                    if true == self?.needsColor {
                        self!.colorSteps()
                    }
                }
            }
        }
    }

    private func setupStepViews() {
        needsSetup = false

        stepViews.forEach { $0.removeFromSuperview() }
        stepViews.removeAll(keepCapacity: true)

        let shapeSize = textFont.pointSize * 1.2
        if horizontalPadding.isZero {horizontalPadding = shapeSize / 2}
        if verticalPadding.isZero {verticalPadding = shapeSize}

        var shape = firstStepShape
        var prevView: UIView = self
        var prevAttribute: NSLayoutAttribute = .Top
        for i in 0 ..< steps.count {

            // create step view
            if i == steps.count-1 {shape = lastStepShape}
            else if i > 0  {shape = stepShape}
            let stepView = SingleStepView(text: steps[i], font: textFont, shape: shape, shapeSize: shapeSize, lineWidth: lineWidth, hPadding: horizontalPadding, vPadding: verticalPadding)
            addSubview(stepView)
            stepViews.append(stepView)

            // layout step view
            addConstraints([
                NSLayoutConstraint(item: stepView, attribute: .Top, relatedBy: .Equal, toItem: prevView, attribute: prevAttribute, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
            ])
            prevView = stepView
            prevAttribute = .Bottom
        }
        stepViews.last?.lineView.hidden = true

        colorSteps()
    }

    private func colorSteps() {
        needsColor = false

        let n = stepViews.count
        if currentStep < n {
            // color future steps
            stepViews[currentStep+1 ..< n].forEach { $0.color(text: self.futureTextColor, stroke: self.futureStepColor, fill: self.futureStepFillColor, line: self.futureStepColor) }

            // color current step
            if currentStep >= 0 {
                stepViews[currentStep].color(text: currentTextColor ?? tintColor, stroke: currentStepColor ?? tintColor, fill: currentStepFillColor, line: futureStepColor)
            }
        }

        // color past steps
        if currentStep > 0 {
            stepViews[0 ..< min(currentStep, n)].forEach { $0.color(text: self.pastTextColor, stroke: self.pastStepColor, fill: self.pastStepFillColor, line: self.pastStepColor) }
        }
    }
}

private class SingleStepView: UIView {
    var textLabel: UILabel = UILabel()
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    var lineView: UIView = UIView()

    convenience init(text: String, font: UIFont, shape: StepProgressView.Shape, shapeSize: CGFloat, lineWidth: CGFloat, hPadding: CGFloat, vPadding: CGFloat) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false

        // shape
        shapeLayer.frame = CGRect(origin: CGPoint(x: floor(lineWidth/2), y: floor(lineWidth/2)), size: CGSize(width: shapeSize, height: shapeSize))
        shapeLayer.path = UIBezierPath(shape: shape, frame: shapeLayer.bounds).CGPath
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)

        // text
        textLabel.font = font
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -vPadding),
            NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: hPadding + shapeSize + lineWidth)
        ])

        // line to next step
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        addConstraints([
            NSLayoutConstraint(item: lineView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: shapeSize/2),
            NSLayoutConstraint(item: lineView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: lineWidth),
            NSLayoutConstraint(item: lineView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: shapeSize + lineWidth - 1),
            NSLayoutConstraint(item: lineView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        ])
    }

    func color(text text: UIColor, stroke: UIColor, fill: UIColor, line: UIColor) {
        textLabel.textColor = text
        lineView.backgroundColor = line
        shapeLayer.strokeColor = stroke.CGColor
        shapeLayer.fillColor = fill.CGColor
    }
}

private extension UIBezierPath {
    convenience init(shape: StepProgressView.Shape, frame: CGRect) {
        switch shape {

        case .Circle:
            self.init(ovalInRect: frame)

        case .Square:
            self.init(rect: frame)

        case .Triangle:
            self.init()
            moveToPoint(CGPoint(x: frame.midX, y: frame.minY))
            addLineToPoint(CGPoint(x: frame.maxX, y: frame.maxY))
            addLineToPoint(CGPoint(x: frame.minX, y: frame.maxY))
            closePath()

        case .DownTriangle:
            self.init()
            moveToPoint(CGPoint(x: frame.midX, y: frame.maxY))
            addLineToPoint(CGPoint(x: frame.maxX, y: frame.minY))
            addLineToPoint(CGPoint(x: frame.minX, y: frame.minY))
            closePath()

        case .Rhombus:
            self.init()
            moveToPoint(CGPoint(x: frame.midX, y: frame.minY))
            addLineToPoint(CGPoint(x: frame.maxX, y: frame.midY))
            addLineToPoint(CGPoint(x: frame.midX, y: frame.maxY))
            addLineToPoint(CGPoint(x: frame.minX, y: frame.midY))
            closePath()
        }
    }
}