//
//  StepsViewDemo.swift
//
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//

#if canImport(SwiftUI)

import StepProgressView
import SwiftUI

@available(iOS 13.0, *)
struct StepsViewDemo: View {
    @State private var currentStep: Double = -1

    var body: some View {
        VStack {
            HStack {
                StepsView(currentStep: $currentStep.int, steps: ["First", "Second", "Third", "Done"])
                Spacer()
                StepsView(
                    currentStep: $currentStep.int,
                    steps: ["One", "Two", "Three", "Jinx"],
                    stepShape: .rhombus,
                    firstStepShape: .downTriangle,
                    lastStepShape: .triangle
                )
                .accentColor(.purple)
            }
            Spacer()
            HStack {
                StepsView(
                    currentStep: $currentStep.int,
                    steps: ["אחת", "שתיים", "ו-ש-לוש", "הסוף!"],
                    futureStepColor: .brown,
                    pastStepColor: .blue,
                    futureStepFillColor: .orange,
                    pastStepFillColor: .cyan,
                    currentStepFillColor: .yellow,
                    futureTextColor: .brown,
                    pastTextColor: .blue
                )
                .accentColor(.green)
                StepsView(
                    currentStep: $currentStep.int,
                    steps: ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing elit"],
                    details: [
                        0: "sed do eiusmod tempor incididunt",
                        1: "ut labore et dolore magna aliqua",
                        2: "Ut enim ad minim veniam",
                        3: "quis nostrud exercitation ullamco laboris",
                    ]
                )
                .accentColor(.red)
            }
            Spacer()
            VStack {
                Text("Change Current Step:").bold()
                Slider(value: $currentStep, in: -1.0 ... 4.0, step: 1.0)
            }
        }
        .padding()
    }
}

extension Double {
    var int: Int {
        get { Int(self) }
        set { self = Double(newValue) }
    }
}

#endif
