//
//  Copyright 2021 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AardvarkCrashReport
import AardvarkMailUI
import CrashReporter
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private Properties

    private let crashReporter = PLCrashReporter(configuration: .defaultConfiguration())

    private let crashBugReporter = ARKEmailBugReporter(
        emailAddress: "fake-email@aardvarkbugreporting.src",
        logStore: ARKLogDistributor.default().defaultLogStore
    )

    private var liveBugReporterAttachmentDelegate: LiveBugReporterAttachmentDelegate?

    // MARK: - AppDelegate

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()

        // Install the live bug reporter using the default gesture recognizer.
        let liveBugReporter = Aardvark.addDefaultBugReportingGestureWithEmailBugReporter(
            withRecipient: "fake-email@aardvarkbugreporting.src"
        )

        if let crashReporter = crashReporter {
            do {
                try crashReporter.enableAndReturnError()
                log("Enabled crash reporter")

            } catch {
                log(
                    "Failed to enable crash reporter",
                    parameters: [
                        "error": error.localizedDescription,
                    ]
                )
            }

            if crashReporter.hasPendingCrashReport() {
                log("Found pending crash report")
            } else {
                log("No pending crash report found")
            }

            // Set up an attachment delegate to provide the live crash report attachment.
            let liveBugReporterAttachmentDelegate = LiveBugReporterAttachmentDelegate(crashReporter: crashReporter)
            self.liveBugReporterAttachmentDelegate = liveBugReporterAttachmentDelegate
            liveBugReporter.emailAttachmentAdditionsDelegate = liveBugReporterAttachmentDelegate

        } else {
            log("Failed to initialize crash reporter")
        }

        // Wait 1 second so the UI has time to appear, then check for a pending crash report.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak self] in
            self?.promptForBugReportIfReporterHasPendingCrashReport()
        }

        return true
    }

    private func promptForBugReportIfReporterHasPendingCrashReport() {
        guard let crashReporter = crashReporter else {
            return
        }

        if let attachment = CrashReportAttachmentGenerator.attachmentForPendingCrashReport(from: crashReporter) {
            log("Generated attachment for pending crash report")

            guard let presentingViewController = window?.rootViewController else {
                log("Failed to present bug reporting prompt")
                return
            }

            let promptingDelegate = CrashBugReporterPromptingDelegate(
                attachment: attachment,
                presentingViewController: presentingViewController
            )
            crashBugReporter.promptingDelegate = promptingDelegate

            (crashBugReporter as ARKBugReporter).composeBugReportWithoutScreenshot()
        }
    }

}
