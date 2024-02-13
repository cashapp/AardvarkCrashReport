# AardvarkCrashReport

[![CI Status](https://img.shields.io/github/actions/workflow/status/cashapp/AardvarkCrashReport/ci.yml?branch=main)](https://github.com/cashapp/AardvarkCrashReport/actions?query=workflow%3ACI+branch%3Amain)
[![Version](https://img.shields.io/cocoapods/v/AardvarkCrashReport.svg?style=flat)](https://cocoapods.org/pods/AardvarkCrashReport)
[![License](https://img.shields.io/cocoapods/l/AardvarkCrashReport.svg?style=flat)](https://cocoapods.org/pods/AardvarkCrashReport)
[![Platform](https://img.shields.io/cocoapods/p/AardvarkCrashReport.svg?style=flat)](https://cocoapods.org/pods/AardvarkCrashReport)

AardvarkCrashReport is an extension to [Aardvark](https://github.com/square/Aardvark) that makes it easy to provide high quality data about crashes in your bug reports.

## Installation

### CocoaPods

To install AardvarkCrashReport via [CocoaPods](https://cocoapods.org/), simply add the following line to your Podfile:

```ruby
pod 'AardvarkCrashReport'
```

## Getting Started

AardvarkCrashReport is built on top of [PLCrashReporter](https://github.com/microsoft/plcrashreporter). If you don't already have PLCrashReporter set up in your app, it's easy to get started. When your app launches, simply create and store a `PLCrashReporter`, then enable it to begin monitoring for crashes.

```swift
self.crashReporter = PLCrashReporter(configuration: .defaultConfiguration())
try? self.crashReporter?.enableAndReturnError()
```

AardvarkCrashReport provides two ways to gather data from the crash reporter: one for crashes that happened on the prior app launch and one to collect a "live" report (a description of the current state of the app).

### Reporting a Crash

When your interface loads, call the `CrashReportAttachmentGenerator`'s `attachmentForPendingCrashReport(from:)` method to check if there is a crash report from the prior launch. If there is, the method will return a bug report attachment containing the crash report. If not, it will return `nil`.

```swift
if let attachment = CrashReportAttachmentGenerator.attachmentForPendingCrashReport(from: crashReporter) {
    // Show a bug report prompt with the `attachment` included.
}
```

Check out the [`AppDelegate`](Example/AardvarkCrashReport/AppDelegate.swift) in the demo app for an example of how to show a bug report prompt.

### Generating a Live Report

To generate an attachment containing a live report, call the `CrashReportAttachmentGenerator`'s `attachmentForLiveReport(from:)` method.

```swift
let attachment = CrashReportAttachmentGenerator.attachmentForLiveReport(from: crashReporter)
```

Check out the [`LiveBugReporterAttachmentDelegate`](https://github.com/squareup/AardvarkCrashReport/blob/main/Example/AardvarkCrashReport/LiveBugReporterAttachmentDelegate.swift) for an example of how this can be used in an attachment delegate for an [ARKEmailBugReporter](https://github.com/square/Aardvark/blob/master/Sources/AardvarkMailUI/ARKEmailBugReporter.h).

## Demo App

AardvarkCrashReport include a demo app that shows how the framework can be used. To run the demo app:

1. Clone the repo.
2. Open the `Example` directory.
3. Run `bundle exec pod install`.
4. Open `AardvarkCrashReportDemo.xcworkspace`.
5. Enable code signing for the `AardvarkCrashReportDemo` to use your development team.
6. Run the `AardvarkCrashReportDemo` scheme on your device.

Note that the demo app uses an email-based bug reporter, so it will not be able to file the report from a simulator since the simulator does not include the Mail app. The crash reporter is also automatically disabled when the debugger is attached, so to test the flow you will need to run the app on your device _without_ attaching a debugger.

## Requirements

* Xcode 12.0 or later
* iOS 12.0 or later

## Contributing

We’re glad you’re interested in AardvarkCrashReport, and we’d love to see where you take it. Please read our [contributing guidelines](CONTRIBUTING.md) prior to submitting a Pull Request.

## License

```
Copyright 2021 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
