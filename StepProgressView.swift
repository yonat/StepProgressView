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

open class StepProgressView: UIView {

    // MARK: - Behavior

    /// Titles of the step-by-step progression stages
    open var steps: [String] = []                 { didSet {needsSetup = true} }

    /// Optional additional text description for each step, shown below the step title
    open var details: [Int:String] = [:]          { didSet {needsSetup = true} }

    /// Current active step: -1 = not started, steps.count = all done.
    open var currentStep: Int = -1                { didSet {needsColor = true} }

    // MARK: - Appearance

    public enum Shape {
        case circle
        case square
        case triangle
        case downTriangle
        case rhombus
    }

    open var stepShape: Shape = .circle           { didSet {needsSetup = true} }
    open var firstStepShape: Shape = .circle      { didSet {needsSetup = true} }
    open var lastStepShape: Shape = .square       { didSet {needsSetup = true} }

    open var lineWidth: CGFloat = 1               { didSet {needsSetup = true} }
    open var textFont: UIFont = UIFont.systemFont( ofSize: UIFont.buttonFontSize )
        { didSet {needsSetup = true} }
    open var detailFont: UIFont = UIFont.systemFont( ofSize: UIFont.systemFontSize )
        { didSet {needsSetup = true} }

    open var verticalPadding: CGFloat = 0 // between steps (0 => default based on textFont)
        { didSet {needsSetup = true} }
    open var horizontalPadding: CGFloat = 0 // between shape and text (0 => default based on textFont)
        { didSet {needsSetup = true} }

    // MARK: - Colors

    open var futureStepColor:  UIColor = UIColor.lightGray { didSet {needsColor = true} }
    open var pastStepColor:    UIColor = UIColor.lightGray { didSet {needsColor = true} }
    open var currentStepColor: UIColor? = nil // nil => the view's tintColor
        { didSet {needsColor = true} }
    open var currentDetailColor: UIColor? = UIColor.darkGray // nil => currentStepColor
        { didSet {needsColor = true} }

    open var futureStepFillColor:  UIColor = UIColor.clear { didSet {needsColor = true} }
    open var pastStepFillColor:    UIColor = UIColor.lightGray { didSet {needsColor = true} }
    open var currentStepFillColor: UIColor = UIColor.clear { didSet {needsColor = true} }

    open var futureTextColor:  UIColor = UIColor.lightGray { didSet {needsColor = true} }
    open var pastTextColor:    UIColor = UIColor.lightGray { didSet {needsColor = true} }
    open var currentTextColor: UIColor? = nil // nil => the view's tintColor
        { didSet {needsColor = true} }


    // MARK: - Overrides

    override open func tintColorDidChange() {
        if nil == currentStepColor || nil == currentTextColor {
            needsColor = true
        }
    }

    // MARK: - Private

    private var stepViews: [SingleStepView] = []

    private var needsSetup: Bool = false {
        didSet {
            if needsSetup && !oldValue {
                DispatchQueue.main.async {[weak self] in
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
                DispatchQueue.main.async {[weak self] in
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
        stepViews.removeAll(keepingCapacity: true)

        let shapeSize = textFont.pointSize * 1.2
        if horizontalPadding.isZero {horizontalPadding = shapeSize / 2}
        if verticalPadding.isZero {verticalPadding = shapeSize}

        var shape = firstStepShape
        var prevView: UIView = self
        var prevAttribute: NSLayoutAttribute = .top
        for i in 0 ..< steps.count {

            // create step view
            if i == steps.count-1 {shape = lastStepShape}
            else if i > 0  {shape = stepShape}
            let stepView = SingleStepView(text: steps[i], detail: details[i], font: textFont, detailFont: detailFont, shape: shape, shapeSize: shapeSize, lineWidth: lineWidth, hPadding: horizontalPadding, vPadding: verticalPadding)
            addSubview(stepView)
            stepViews.append(stepView)

            // layout step view
            addConstraints([
                NSLayoutConstraint(item: stepView, attribute: .top, relatedBy: .equal, toItem: prevView, attribute: prevAttribute, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: stepView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            ])
            prevView = stepView
            prevAttribute = .bottom
        }
        stepViews.last?.lineView.isHidden = true

        colorSteps()
    }

    private func colorSteps() {
        needsColor = false

        let n = stepViews.count
        if currentStep < n {
            // color future steps
            stepViews[currentStep+1 ..< n].forEach { $0.color(text: futureTextColor, detail: futureTextColor, stroke: futureStepColor, fill: futureStepFillColor, line: futureStepColor) }

            // color current step
            if currentStep >= 0 {
                let textColor: UIColor = currentTextColor ?? tintColor
                let detailColor = currentDetailColor ?? textColor
                stepViews[currentStep].color(text: textColor, detail: detailColor, stroke: textColor, fill: currentStepFillColor, line: futureStepColor)
            }
        }

        // color past steps
        if currentStep > 0 {
            stepViews[0 ..< min(currentStep, n)].forEach { $0.color(text: pastTextColor, detail: pastTextColor, stroke: pastStepColor, fill: pastStepFillColor, line: pastStepColor) }
        }
    }
}

private class SingleStepView: UIView {
    var textLabel: UILabel = UILabel()
    var detailLabel: UILabel = UILabel()
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    var lineView: UIView = UIView()

    convenience init(text: String, detail: String?, font: UIFont, detailFont: UIFont, shape: StepProgressView.Shape, shapeSize: CGFloat, lineWidth: CGFloat, hPadding: CGFloat, vPadding: CGFloat) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false

        // shape
        shapeLayer.frame = CGRect(origin: CGPoint(x: floor(lineWidth/2), y: floor(lineWidth/2)), size: CGSize(width: shapeSize, height: shapeSize))
        shapeLayer.path = UIBezierPath(shape: shape, frame: shapeLayer.bounds).cgPath
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)

        // text
        textLabel.font = font
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: hPadding + shapeSize + lineWidth)
        ])

        // detail
        detailLabel.font = detailFont
        detailLabel.text = detail
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        addConstraints([
            NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: textLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: textLabel, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -vPadding),
        ])

        // line to next step
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        addConstraints([
            NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: shapeSize/2),
            NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: lineWidth),
            NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: shapeSize + lineWidth - 1),
            NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        ])
    }

    func color(text: UIColor, detail: UIColor, stroke: UIColor, fill: UIColor, line: UIColor) {
        textLabel.textColor = text
        detailLabel.textColor = detail
        lineView.backgroundColor = line
        shapeLayer.strokeColor = stroke.cgColor
        shapeLayer.fillColor = fill.cgColor
    }
}

private extension UIBezierPath {
    convenience init(shape: StepProgressView.Shape, frame: CGRect) {
        switch shape {

        case .circle:
            self.init(ovalIn: frame)

        case .square:
            self.init(rect: frame)

        case .triangle:
            self.init()
            move(to: CGPoint(x: frame.midX, y: frame.minY))
            addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
            addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
            close()

        case .downTriangle:
            self.init()
            move(to: CGPoint(x: frame.midX, y: frame.maxY))
            addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
            addLine(to: CGPoint(x: frame.minX, y: frame.minY))
            close()

        case .rhombus:
            self.init()
            move(to: CGPoint(x: frame.midX, y: frame.minY))
            addLine(to: CGPoint(x: frame.maxX, y: frame.midY))
            addLine(to: CGPoint(x: frame.midX, y: frame.maxY))
            addLine(to: CGPoint(x: frame.minX, y: frame.midY))
            close()
        }
    }
}
