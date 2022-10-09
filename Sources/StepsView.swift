//
//  StepsView.swift
//
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//

#if canImport(SwiftUI)

import SweeterSwift
import SwiftUI

/// Step-by-step progress view with labels and shapes.
@available(iOS 13.0, *) public struct StepsView: UIViewRepresentable {
    public typealias UIViewType = StepProgressView
    private let uiView = StepProgressView()

    @Binding public var currentStep: Int

    public init(
        currentStep: Binding<Int>,
        steps: [String]? = nil,
        details: [Int: String]? = nil,
        stepShape: StepProgressView.Shape? = nil,
        firstStepShape: StepProgressView.Shape? = nil,
        lastStepShape: StepProgressView.Shape? = nil,
        lineWidth: CGFloat? = nil,
        textFont: UIFont? = nil,
        detailFont: UIFont? = nil,
        verticalPadding: CGFloat? = nil,
        horizontalPadding: CGFloat? = nil,
        futureStepColor: UIColor? = nil,
        pastStepColor: UIColor? = nil,
        currentStepColor: UIColor? = nil,
        currentDetailColor: UIColor?? = nil,
        futureStepFillColor: UIColor? = nil,
        pastStepFillColor: UIColor? = nil,
        currentStepFillColor: UIColor? = nil,
        futureTextColor: UIColor? = nil,
        pastTextColor: UIColor? = nil,
        currentTextColor: UIColor? = nil
    ) {
        _currentStep = currentStep

        uiView.steps =? steps
        uiView.details =? details
        uiView.stepShape =? stepShape
        uiView.firstStepShape =? firstStepShape
        uiView.lastStepShape =? lastStepShape
        uiView.lineWidth =? lineWidth
        uiView.textFont =? textFont
        uiView.detailFont =? detailFont
        uiView.verticalPadding =? verticalPadding
        uiView.horizontalPadding =? horizontalPadding
        uiView.futureStepColor =? futureStepColor
        uiView.pastStepColor =? pastStepColor
        uiView.currentStepColor =? currentStepColor
        uiView.currentDetailColor =? currentDetailColor
        uiView.futureStepFillColor =? futureStepFillColor
        uiView.pastStepFillColor =? pastStepFillColor
        uiView.currentStepFillColor =? currentStepFillColor
        uiView.futureTextColor =? futureTextColor
        uiView.pastTextColor =? pastTextColor
        uiView.currentTextColor =? currentTextColor

        uiView.setupStepViews() // don't wait until next run loop
    }

    public func makeUIView(context: UIViewRepresentableContext<StepsView>) -> StepProgressView {
        return uiView
    }

    public func updateUIView(_ uiView: StepProgressView, context: UIViewRepresentableContext<StepsView>) {
        uiView.currentStep = currentStep
    }
}

@available(iOS 13.0, *) public extension StepsView {
    func stepShape(_ value: StepProgressView.Shape) -> Self {
        uiView.stepShape = value
        return self
    }

    func firstStepShape(_ value: StepProgressView.Shape) -> Self {
        uiView.firstStepShape = value
        return self
    }

    func lastStepShape(_ value: StepProgressView.Shape) -> Self {
        uiView.lastStepShape = value
        return self
    }

    func lineWidth(_ value: CGFloat) -> Self {
        uiView.lineWidth = value
        return self
    }

    func textFont(_ value: UIFont) -> Self {
        uiView.textFont = value
        return self
    }

    func detailFont(_ value: UIFont) -> Self {
        uiView.detailFont = value
        return self
    }

    /// space between steps (0 => default based on textFont)
    func verticalPadding(_ value: CGFloat) -> Self {
        uiView.verticalPadding = value
        return self
    }

    /// space between shape and text (0 => default based on textFont)
    func horizontalPadding(_ value: CGFloat) -> Self {
        uiView.horizontalPadding = value
        return self
    }

    func futureStepColor(_ value: UIColor) -> Self {
        uiView.futureStepColor = value
        return self
    }

    func pastStepColor(_ value: UIColor) -> Self {
        uiView.pastStepColor = value
        return self
    }

    func currentStepColor(_ value: UIColor) -> Self {
        uiView.currentStepColor = value
        return self
    }

    func currentDetailColor(_ value: UIColor) -> Self {
        uiView.currentDetailColor = value
        return self
    }

    func futureStepFillColor(_ value: UIColor) -> Self {
        uiView.futureStepFillColor = value
        return self
    }

    func pastStepFillColor(_ value: UIColor) -> Self {
        uiView.pastStepFillColor = value
        return self
    }

    func currentStepFillColor(_ value: UIColor) -> Self {
        uiView.currentStepFillColor = value
        return self
    }

    func futureTextColor(_ value: UIColor) -> Self {
        uiView.futureTextColor = value
        return self
    }

    func pastTextColor(_ value: UIColor) -> Self {
        uiView.pastTextColor = value
        return self
    }

    func currentTextColor(_ value: UIColor) -> Self {
        uiView.currentTextColor = value
        return self
    }
}

#endif
