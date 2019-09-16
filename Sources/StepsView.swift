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

        uiView.translatesAutoresizingMaskIntoConstraints = false
    }

    public func makeUIView(context: UIViewRepresentableContext<StepsView>) -> StepProgressView {
        return uiView
    }

    public func updateUIView(_ uiView: StepProgressView, context: UIViewRepresentableContext<StepsView>) {
        uiView.currentStep = currentStep
    }
}

#endif
