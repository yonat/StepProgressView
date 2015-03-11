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

progressView.currentStep = 0 // started first step
...
progressView.currentStep = 4 // all done
```

## Changing Appearance

**Shape of the step icons:**

```swift
progressView.stepShape = .Circle
progressView.firstStepShape = .Rhombus
progressView.lastStepShape = .Square
// also available: Triangle, DownTriangle
```

**Line and text size and font:**

```swift
progressView.lineWidth = 2.5
progressView.textFont = myFont
```

**Colors:**


```swift
progressView.tintColor = myGeneralTintColor

// alternatively:

progressView.currentStepColor = UIColor.redColor()
progressView.pastStepColor = UIColor.grayColor()
progressView.futureStepColor = UIColor.grayColor()

progressView.currentStepFillColor = UIColor.yellowColor()
progressView.pastStepFillColor = UIColor.grayColor()
progressView.futureStepFillColor = UIColor.lightGrayColor()

progressView.currentTextColor = UIColor.blueColor()
progressView.pastTextColor = UIColor.grayColor()
progressView.futureTextColor = UIColor.lightGrayColor()
```
