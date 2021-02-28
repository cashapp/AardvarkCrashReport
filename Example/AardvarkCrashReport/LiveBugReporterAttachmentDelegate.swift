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

final class LiveBugReporterAttachmentDelegate: NSObject, ARKEmailBugReporterEmailAttachmentAdditionsDelegate {

    // MARK: - Life Cycle

    init(crashReporter: PLCrashReporter) {
        self.crashReporter = crashReporter
    }

    // MARK: - Private Properties

    private let crashReporter: PLCrashReporter

    // MARK: - ARKEmailBugReporterEmailAttachmentAdditionsDelegate

    func emailBugReporter(
        _ emailBugReporter: ARKEmailBugReporter,
        shouldIncludeLogStoreInBugReport logStore: ARKLogStore
    ) -> Bool {
        return true
    }

    func additionalEmailAttachments(for emailBugReporter: ARKEmailBugReporter) -> [ARKBugReportAttachment]? {
        return [
            CrashReportAttachmentGenerator.attachmentForLiveReport(from: crashReporter),
        ].compactMap { $0 }
    }

}
