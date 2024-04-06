
Pod::Spec.new do |s|

  s.name         = "StepProgressView"
  s.version      = "1.6.4"
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

  s.swift_version = '4.2'
  s.swift_versions = ['4.2', '5.0']
  s.platform     = :ios, "11.0"
  s.requires_arc = true
  s.weak_framework = 'SwiftUI'

  s.source       = { :git => "https://github.com/yonat/StepProgressView.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.resources = ['PrivacyInfo.xcprivacy']

  s.dependency 'SweeterSwift'

  s.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(FRAMEWORK_SEARCH_PATHS)' } # fix Interface Builder render error

end
