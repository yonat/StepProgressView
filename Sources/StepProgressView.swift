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
//  Copyright (c) 2016 Yonat Sharon. All rights reserved.
//

import SweeterSwift
import UIKit

@IBDesignable
open class StepProgressView: UIView {
    // MARK: - Behavior

    /// Titles of the step-by-step progression stages
    open var steps: [String] = [] { didSet { needsSetup = true } }

    /// Optional additional text description for each step, shown below the step title
    open var details: [Int: String] = [:] { didSet { needsSetup = true } }

    /// Current active step: -1 = not started, steps.count = all done.
    open var currentStep: Int = -1 {
        didSet {
            needsColor = true
            accessibilityValue = steps.indices.contains(currentStep) ? steps[currentStep] : nil
        }
    }

    // MARK: - Appearance

    @objc public enum Shape: Int {
        case circle
        case square
        case triangle
        case downTriangle
        case rhombus
    }

    @objc open dynamic var stepShape: Shape = .circle { didSet { needsSetup = true } }
    @objc open dynamic var firstStepShape: Shape = .circle { didSet { needsSetup = true } }
    @objc open dynamic var lastStepShape: Shape = .square { didSet { needsSetup = true } }

    @IBInspectable open dynamic var lineWidth: CGFloat = 1 { didSet { needsSetup = true } }
    @objc open dynamic var textFont = UIFont.systemFont(ofSize: UIFont.buttonFontSize) { didSet { needsSetup = true } }
    @objc open dynamic var detailFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) { didSet { needsSetup = true } }

    /// space between steps (0 => default based on textFont)
    @IBInspectable open dynamic var verticalPadding: CGFloat = 0 { didSet { needsSetup = true } }

    /// space between shape and text (0 => default based on textFont)
    @IBInspectable open dynamic var horizontalPadding: CGFloat = 0 { didSet { needsSetup = true } }

    // MARK: - Colors

    @IBInspectable open dynamic var futureStepColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastStepColor: UIColor = .lightGray { didSet { needsColor = true } }

    /// nil => use the view's tintColor
    @IBInspectable open dynamic var currentStepColor: UIColor? { didSet { needsColor = true } }

    /// nil => use currentStepColor
    @IBInspectable open dynamic var currentDetailColor: UIColor? = .darkGray { didSet { needsColor = true } }

    @IBInspectable open dynamic var futureStepFillColor: UIColor = .clear { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastStepFillColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var currentStepFillColor: UIColor = .clear { didSet { needsColor = true } }

    @IBInspectable open dynamic var futureTextColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastTextColor: UIColor = .lightGray { didSet { needsColor = true } }

    /// nil => use the view's tintColor
    @IBInspectable open dynamic var currentTextColor: UIColor? { didSet { needsColor = true } }

    // MARK: - Overrides

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAccessibility()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initAccessibility()
    }

    open override func tintColorDidChange() {
        if nil == currentStepColor || nil == currentTextColor {
            needsColor = true
        }
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        steps = ["First Step", "Second Step", "This Step", "Last Step"]
        details = [0: "The beginning", 3: "the end"]
    }

    // MARK: - Private

    private func initAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = "Step Progress"
        accessibilityIdentifier = "StepProgress"
    }

    private var stepViews: [SingleStepView] = []

    private var needsSetup: Bool = false {
        didSet {
            if needsSetup && !oldValue {
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self, strongSelf.needsSetup {
                        strongSelf.setupStepViews()
                    }
                }
            }
        }
    }

    private var needsColor: Bool = false {
        didSet {
            if needsColor && !oldValue {
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self, strongSelf.needsColor {
                        strongSelf.colorSteps()
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
        if horizontalPadding.isZero { horizontalPadding = shapeSize / 2 }
        if verticalPadding.isZero { verticalPadding = shapeSize }

        var shape = firstStepShape
        var prevView: UIView = self
        var prevAttribute: NSLayoutConstraint.Attribute = .top
        for i in 0 ..< steps.count {
            // create step view
            if i == steps.count - 1 {
                shape = lastStepShape
            } else if i > 0 {
                shape = stepShape
            }
            let stepView = SingleStepView(
                text: steps[i],
                detail: details[i],
                font: textFont, detailFont:
                detailFont,
                shape: shape,
                shapeSize: shapeSize,
                lineWidth: lineWidth,
                hPadding: horizontalPadding,
                vPadding: verticalPadding
            )
            stepViews.append(stepView)

            // layout step view
            addConstrainedSubview(stepView, constrain: .leading, .trailing)
            constrain(stepView, at: .top, to: prevView, at: prevAttribute)
            prevView = stepView
            prevAttribute = .bottom
        }
        if let lastStepView = stepViews.last {
            lastStepView.lineView.isHidden = true
            constrain(lastStepView, at: .bottom)
        }

        colorSteps()
    }

    private func colorSteps() {
        needsColor = false

        let n = stepViews.count
        if currentStep < n {
            // color future steps
            stepViews[currentStep + 1 ..< n].forEach {
                $0.color(text: futureTextColor, detail: futureTextColor, stroke: futureStepColor, fill: futureStepFillColor, line: futureStepColor)
            }

            // color current step
            if currentStep >= 0 {
                let textColor: UIColor = currentTextColor ?? tintColor
                let detailColor = currentDetailColor ?? textColor
                stepViews[currentStep].color(
                    text: textColor,
                    detail: detailColor,
                    stroke: textColor,
                    fill: currentStepFillColor,
                    line: futureStepColor
                )
            }
        }

        // color past steps
        if currentStep > 0 {
            stepViews[0 ..< min(currentStep, n)].forEach {
                $0.color(text: pastTextColor, detail: pastTextColor, stroke: pastStepColor, fill: pastStepFillColor, line: pastStepColor)
            }
        }
    }
}

private class SingleStepView: UIView {
    var textLabel = UILabel()
    var detailLabel = UILabel()
    var shapeLayer = CAShapeLayer()
    var lineView = UIView()

    convenience init(text: String, detail: String?, font: UIFont, detailFont: UIFont, shape: StepProgressView.Shape, shapeSize: CGFloat, lineWidth: CGFloat, hPadding: CGFloat, vPadding: CGFloat) {
        self.init()

        // shape
        shapeLayer.frame = CGRect(
            origin: CGPoint(x: floor(lineWidth / 2), y: floor(lineWidth / 2)),
            size: CGSize(width: shapeSize, height: shapeSize)
        )
        shapeLayer.path = UIBezierPath(shape: shape, frame: shapeLayer.bounds).cgPath
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)

        // text
        textLabel.font = font
        textLabel.text = text
        textLabel.numberOfLines = 0
        addConstrainedSubview(textLabel, constrain: .top, .trailing)
        constrain(textLabel, at: .leading, diff: hPadding + shapeSize + lineWidth)

        // detail
        detailLabel.font = detailFont
        detailLabel.text = detail
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        constrain(detailLabel, at: .top, to: textLabel, at: .bottom)
        constrain(detailLabel, at: .trailing, to: textLabel)
        constrain(detailLabel, at: .leading, to: textLabel)
        constrain(detailLabel, at: .bottom, diff: -vPadding)

        // line to next step
        addConstrainedSubview(lineView, constrain: .bottom)
        constrain(lineView, at: .leading, diff: shapeSize / 2)
        constrain(lineView, at: .top, diff: shapeSize + lineWidth - 1)
        lineView.constrain(.width, to: lineWidth)
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
