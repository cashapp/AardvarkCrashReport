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

import AardvarkLoggingUI
import Paralayout
import UIKit

class ViewController: UIViewController {

    // MARK: - UIViewController

    override func loadView() {
        view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "AardvarkCrashReport Demo"

        mainView.instructionsLabel.text = """
            Tap one of the red buttons below to trigger a crash. On the next app launch, you will be prompted to file \
            a bug report with the resulting crash report attached.

            Alternatively, hold two fingers on the screen to file a bug report with a live report.
            """

        mainView.crashButton.addTarget(self, action: #selector(triggerCrash), for: .touchUpInside)
        mainView.exceptionButton.addTarget(self, action: #selector(triggerException), for: .touchUpInside)
        mainView.showLogsButton.addTarget(self, action: #selector(showLogViewer), for: .touchUpInside)
    }

    // MARK: - Private Properties

    private var mainView: View {
        return view as! View
    }

    // MARK: - Private Methods

    @objc private func triggerCrash() {
        _ = [Int]()[1]
    }

    @objc private func triggerException() {
        NSException(name: .genericException, reason: "Testing", userInfo: nil).raise()
    }

    @objc private func showLogViewer() {
        let viewer = ARKLogTableViewController()
        navigationController?.pushViewController(viewer, animated: true)
    }

}

// MARK: -

extension ViewController {

    final class View: UIView {

        // MARK: - Life Cycle

        override init(frame: CGRect) {
            super.init(frame: frame)

            instructionsLabel.numberOfLines = 0
            instructionsLabel.textAlignment = .center
            instructionsLabel.textColor = .black
            instructionsLabel.font = .systemFont(ofSize: 17)
            addSubview(instructionsLabel)

            crashButton.setTitle("Trigger Crash", for: .normal)
            crashButton.setTitleColor(.white, for: .normal)
            crashButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
            crashButton.backgroundColor = .red
            addSubview(crashButton)

            exceptionButton.setTitle("Trigger Exception", for: .normal)
            exceptionButton.setTitleColor(.white, for: .normal)
            exceptionButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
            exceptionButton.backgroundColor = .red
            addSubview(exceptionButton)

            showLogsButton.setTitle("Show Logs", for: .normal)
            showLogsButton.setTitleColor(.white, for: .normal)
            showLogsButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
            showLogsButton.backgroundColor = .blue
            addSubview(showLogsButton)

            backgroundColor = .white
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Public Properties

        let instructionsLabel: UILabel = .init()

        let crashButton: UIButton = .init()

        let exceptionButton: UIButton = .init()

        let showLogsButton: UIButton = .init()

        // MARK: - UIView

        override func layoutSubviews() {
            let buttons = [crashButton, exceptionButton, showLogsButton]

            instructionsLabel.sizeToFit(width: bounds.width - 48, constraints: .maxWidth)

            buttons.forEach { button in
                button.contentEdgeInsets = .init(uniform: 16)
                button.sizeToFit(width: bounds.width - 48, constraints: .fixedWidth)
                button.layer.cornerRadius = button.bounds.height / 2
            }

            applyVerticalSubviewDistribution(
                [
                    [instructionsLabel.distributionItem, 32.fixed],
                    buttons.flatMap { [$0.distributionItem, 24.fixed] }.dropLast()
                ].flatMap { $0 }
            )
        }

    }

}
