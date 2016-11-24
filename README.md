# StepProgressView
Step-by-step progress view with labels and shapes. A good replacement for UIActivityIndicatorView and UIProgressView.

<p align="center">
<img src="screenshots/blue.gif">
<img src="screenshots/red.gif">
</p>

## Usage

```swift
let progressView   = StepProgressView(frame: view.bounds)
progressView.steps = ["First", "Second", "Third", "Last"]
progressView.details = [0: "The beginning", 3: "The end"] // appears below step title

progressView.currentStep = 0 // started first step
...
progressView.currentStep = 4 // all done
```

## Changing Appearance

**Shape of the step icons:**

```swift
progressView.stepShape = .circle
progressView.firstStepShape = .rhombus
progressView.lastStepShape = .square
// also available: .triangle, .downTriangle
```

**Text fonts and sizes:**

```swift
progressView.textFont = myFont
progressView.detailFont = anotherFont
```

**Line size spacing:**

```swift
progressView.lineWidth = 2.5
progressView.verticalPadding = 8 // between steps (0 => default based on textFont)
progressView.horizontalPadding: 8 // between shape and text (0 => default based on textFont)
```

**Colors:**


```swift
progressView.tintColor = myGeneralTintColor

// alternatively:

progressView.currentStepColor = .red
progressView.pastStepColor = .gray
progressView.futureStepColor = .gray

progressView.currentStepFillColor = .yellow
progressView.pastStepFillColor = .gray
progressView.futureStepFillColor = .lightGray

progressView.currentTextColor = .blue
progressView.pastTextColor = .gray
progressView.futureTextColor = .lightGray
progressView.currentDetailColor = .cyan // nil => use currentStepColor
```


## Installation

### CocoaPods:

```ruby
pod 'StepProgressView'
```

For legacy Swift 2.3:

```ruby
pod 'StepProgressView', '~> 1.2.1'
```

### Manually:

Copy `StepProgressView.swift` to your Xcode project.
