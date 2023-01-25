# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- fix crash when currentStep is less than -1.

## [1.6.0] - 2022-10-09

### Added
- add SwiftUI wrapper `StepsView`. (Requires minimum deployment target iOS 11.0)

### Fixed
- calculate `intrinsicContentSize`.
- make SwiftUI frame correctly respond to `.fixedSize(horizontal: false, vertical: true)`.

## [1.5.7] - 2020-06-27

### Changed
- export `StepProgressView.Shape` to Objective-C as `StepProgressViewShape` in order to avoid conflict with other libraries' `Shape` type.

## [1.5.6] - 2019-08-22

### Added
- support Swift Package Manager.

### Fixed
- fix Interface Builder render error.

## [1.5.4] - 2019-07-23

### Changed
- Better support for auto layout, now has correct intrinsicContentSize.

## [1.5.3] - 2019-07-13

### Changed
- MiniLayout moved to SweeterSwift.

## [1.5.2] - 2019-06-21

### Changed
- Swift 5, CocoaPods 1.7.

## [1.5.1] - 2019-06-07

### Added
- UIAppearance support.

## [1.5.0] - 2018-09-05

### Changed
- Swift 4.2

## [1.4.1] - 2018-05-20

### Changed
- Better format code, use MiniLayout.

## [1.4.0] - 2017-07-15

### Changed
- Swift 4

## [1.3.0] - 2016-11-24

### Added
- make `IBDesignable`.
