//
//  StepProgressView.swift
//  Step
//  Note: Currently the only supported order is:
//      1. Set appearence properties. (optional)
//      2. Set steps.
//      3. Change currentStep.
//
//  Created by Yonat Sharon on 13/2/15.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

class StepProgressView: UIView {

    // MARK: - Behavior

    /// Titles of the step-by-step progression stages
    var steps: [String] = []    { didSet {setupStepViews()} }

    /// Current active step: -1 = not started, steps.count = all done.
    var currentStep: Int = -1   { didSet {colorSteps()} }

    // MARK: - Appearance

    enum Shape {
        case Circle
        case Square
    }

    var stepShape = Shape.Circle
    var firstStepShape = Shape.Circle
    var lastStepShape = Shape.Square

    var shapeSize: CGFloat = UIFont.systemFontSize()
    var lineWidth: CGFloat = 1
    var verticalPadding: CGFloat = UIFont.systemFontSize() // between steps
    var horizontalPadding: CGFloat = UIFont.systemFontSize() / 2 // between shape and text
    var textFont = UIFont.systemFontOfSize(UIFont.systemFontSize())

    // MARK: - Colors

    var futureStepColor = UIColor.lightGrayColor()
    var pastStepColor = UIColor.blackColor()
    var currentStepColor = UIColor.blackColor()

    var futureStepFillColor = UIColor.clearColor()
    var pastStepFillColor = UIColor.blackColor()
    var currentStepFillColor = UIColor.lightGrayColor()

    var futureTextColor = UIColor.lightGrayColor()
    var pastTextColor = UIColor.blackColor()
    var currentTextColor = UIColor.blackColor()


    // MARK: - Private

    private var stepViews: [SingleStepView] = []

    private func setupStepViews() {
        stepViews.map { $0.removeFromSuperview() }
        stepViews.removeAll(keepCapacity: true)

        for i in 0 ..< steps.count {

            // create step view
            var shape: Shape
            switch i {
            case 0:             shape = firstStepShape
            case steps.count-1: shape = lastStepShape
            default:            shape = stepShape
            }
            let stepView = SingleStepView(text: steps[i], font: textFont, shape: shape, shapeSize: shapeSize, lineWidth: lineWidth, hPadding: horizontalPadding, vPadding: verticalPadding)
            stepView.color(text: futureTextColor, stroke: futureStepColor, fill: futureStepFillColor, line: futureStepColor)
            addSubview(stepView)
            stepViews.append(stepView)

            // layout step view
            let prevView = (i == 0) ? self : stepViews[i-1]
            let prevAttribute: NSLayoutAttribute = (i == 0) ? .Top : .Bottom
            addConstraints([
                NSLayoutConstraint(item: stepView, attribute: .Top, relatedBy: .Equal, toItem: prevView, attribute: prevAttribute, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
            ])
        }
        stepViews.last?.lineView.hidden = true
    }

    private func colorSteps() {
        let n = stepViews.count
        if currentStep < n {
            stepViews[currentStep+1 ..< n].map { $0.color(text: self.futureTextColor, stroke: self.futureStepColor, fill: self.futureStepFillColor, line: self.futureStepColor) }
            if currentStep >= 0 {
                stepViews[currentStep].color(text: currentTextColor, stroke: currentStepColor, fill: currentStepFillColor, line: futureStepColor)
            }
        }
        if currentStep > 0 {
            stepViews[0 ..< currentStep].map { $0.color(text: self.pastTextColor, stroke: self.pastStepColor, fill: self.pastStepFillColor, line: self.pastStepColor) }
        }
    }
}

private class SingleStepView: UIView {
    var textLabel: UILabel = UILabel()
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    var lineView: UIView = UIView()

    convenience init(text: String, font: UIFont, shape: StepProgressView.Shape, shapeSize: CGFloat, lineWidth: CGFloat, hPadding: CGFloat, vPadding: CGFloat) {
        self.init()
        setTranslatesAutoresizingMaskIntoConstraints(false)

        // shape
        shapeLayer.frame = CGRect(origin: CGPoint(x: floor(lineWidth/2), y: floor(lineWidth/2)), size: CGSize(width: shapeSize, height: shapeSize))
        shapeLayer.path = UIBezierPath(shape: shape, frame: shapeLayer.bounds).CGPath
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)

        // text
        textLabel.font = font
        textLabel.text = text
        textLabel.sizeToFit()
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(textLabel)
        addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -vPadding),
            NSLayoutConstraint(item: textLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: hPadding + shapeSize + lineWidth)
        ])

        // line to next step
        lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(lineView)
        addConstraints([
            NSLayoutConstraint(item: lineView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: shapeSize/2),
            NSLayoutConstraint(item: lineView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: lineWidth),
            NSLayoutConstraint(item: lineView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: shapeSize + lineWidth - 1),
            NSLayoutConstraint(item: lineView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        ])
    }

    func color(#text: UIColor, stroke: UIColor, fill: UIColor, line: UIColor) {
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
        }
    }
}