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

import Aardvark
import AardvarkMailUI
import UIKit

final class CrashBugReporterPromptingDelegate: NSObject, ARKEmailBugReporterPromptingDelegate {

    // MARK: - Life Cycle

    init(attachment: ARKBugReportAttachment, presentingViewController: UIViewController) {
        self.attachment = attachment
        self.presentingViewController = presentingViewController
    }

    // MARK: - Private Properties

    private let attachment: ARKBugReportAttachment

    private let presentingViewController: UIViewController

    // MARK: - ARKEmailBugReporterPromptingDelegate

    func showBugReportingPrompt(
        for configuration: ARKEmailBugReportConfiguration,
        completion: @escaping ARKEmailBugReporterCustomPromptCompletionBlock
    ) {
        let alertController = UIAlertController(
            title: "Crash Detected",
            message: "Would you like to file a bug report?",
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                // The bug (crash) happened on the prior launch, so there's no point in including the screenshot or
                // view hierarchy from the current launch.
                configuration.excludeScreenshot()
                configuration.excludeViewHierarchyDescription()

                configuration.additionalAttachments.append(self.attachment)

                completion(configuration)
            }
        )

        alertController.addAction(
            UIAlertAction(title: "No", style: .cancel) { _ in
                completion(nil)
            }
        )

        presentingViewController.present(alertController, animated: true)
    }

}
