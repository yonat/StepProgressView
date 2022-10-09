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
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                StepsView(
                    currentStep: $currentStep.int,
                    steps: ["One", "Two", "Three", "Jinx"],
                    stepShape: .rhombus,
                    firstStepShape: .downTriangle,
                    lastStepShape: .triangle
                )
                .fixedSize(horizontal: true, vertical: false)
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
                .roundedBorder()
                .fixedSize()
                .accentColor(.green)

                Spacer()

                StepsView(
                    currentStep: $currentStep.int,
                    steps: ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing elit"],
                    details: [
                        0: "sed do eiusmod tempor",
                        1: "incididunt ut labore et dolore",
                        2: "magna aliqua ut enim ad minim",
                        3: "veniam quis nostrud",
                    ]
                )
                .stepShape(.rhombus)
                .fixedSize()
                .roundedBorder()
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

private extension Double {
    var int: Int {
        get { Int(self) }
        set { self = Double(newValue) }
    }
}

@available(iOS 13.0, *)
extension View {
    func roundedBorder(_ radius: CGFloat = 16) -> some View {
        padding(radius * 0.75)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.accentColor)
            )
    }
}

#endif
