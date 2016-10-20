
Pod::Spec.new do |s|

  s.name         = "StepProgressView"
  s.version      = "1.2.1"
  s.summary      = "Step-by-step progress view with labels and shapes. A good replacement for UIActivityIndicatorView and UIProgressView."

  s.description  = <<-DESC
Usage:

```swift
let progressView   = StepProgressView(frame: view.bounds)
progressView.steps = ["First", "Second", "Third", "Last"]

progressView.currentStep = 0 // started first step
...
progressView.currentStep = 4 // all done
```
                   DESC

  s.homepage     = "https://github.com/yonat/StepProgressView"
  s.screenshots  = "https://raw.githubusercontent.com/yonat/StepProgressView/master/screenshots/blue.gif", "https://raw.githubusercontent.com/yonat/StepProgressView/master/screenshots/red.gif"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Yonat Sharon" => "yonat@ootips.org" }
  s.social_media_url   = "http://twitter.com/yonatsharon"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/yonat/StepProgressView.git", :tag => s.version }

  s.source_files  = "StepProgressView.swift"

  s.requires_arc = true

end
