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
import CrashReporter

#if SWIFT_PACKAGE
import AardvarkSwift
#endif

public final class CrashReportAttachmentGenerator {

    // MARK: - Public Static Method

    /// Generates a bug report attachment containing a textual representation of the pending crash report in the
    /// provided crash reporter, if one exists.
    ///
    /// - parameter crashReporter: The crash reporter from which to query the pending crash report.
    /// - parameter purgePendingCrashReport: Whether the pending crash report should be purged after it is loaded.
    /// Specify `false` if you check the pending crash report in multiple places.
    public static func attachmentForPendingCrashReport(
        from crashReporter: PLCrashReporter,
        purgePendingCrashReport: Bool = true
    ) -> ARKBugReportAttachment? {
        guard crashReporter.hasPendingCrashReport() else {
            return nil
        }

        defer {
            if purgePendingCrashReport {
                crashReporter.purgePendingCrashReport()
            }
        }

        do {
            let data = try crashReporter.loadPendingCrashReportDataAndReturnError()
            let crashReport = try PLCrashReport(data: data)
            return attachment(for: crashReport)

        } catch {
            return nil
        }
    }

    /// Generates a bug report attachment containing a textual representation of a live crash report.
    ///
    /// The report will be generated on the thread on which this method is called.
    ///
    /// - parameter crashReporter: The crash reporter to use to generate the live report.
    public static func attachmentForLiveReport(
        from crashReporter: PLCrashReporter
    ) -> ARKBugReportAttachment? {
        do {
            let data = try THIS_THREAD_IS_GENERATING_A_CRASH_REPORT(crashReporter)
            let crashReport = try PLCrashReport(data: data)
            return attachment(for: crashReport, named: "Live")

        } catch {
            return nil
        }
    }

    // MARK: - Private Methods

    private static func attachment(
        for crashReport: PLCrashReport,
        named reportName: String? = nil
    ) -> ARKBugReportAttachment? {
        guard let formattedText = PLCrashReportTextFormatter.stringValue(
            for: crashReport,
            with: PLCrashReportTextFormatiOS
        ) else {
            return nil
        }

        // Include the timestamp at which the crash occurred in the name to make it easy to identify when the crash
        // occurred (since a pending crash report will be from a prior launch, and there may be multiple crash reports
        // attached to a single bug report).
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_at_'h.mm'_'a"

        let fileName: String
        if let reportName = reportName {
            fileName = "\(reportName).crash"

        } else if let crashDate = crashReport.systemInfo.timestamp {
            let formattedCrashDate = dateFormatter.string(from: crashDate)
            fileName = "Crash_\(formattedCrashDate).crash"

        } else {
            fileName = "Crash.crash"
        }

        return ARKBugReportAttachment(
            fileName: fileName,
            data: formattedText.data(using: .utf8)!,
            dataMIMEType: "text/plain"
        )
    }

}

// MARK: -

private func THIS_THREAD_IS_GENERATING_A_CRASH_REPORT(_ crashReporter: PLCrashReporter) throws -> Data {
    return try crashReporter.generateLiveReportAndReturnError()
}
