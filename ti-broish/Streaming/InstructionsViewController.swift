//
//  InstructionsViewController.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 28.03.21.
//

import UIKit

class InstructionsViewController: StreamingBaseViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var preferLandscapeLabel: UILabel!
    @IBOutlet weak var focusCenterLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    @IBOutlet weak var streamInterruptionsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    @IBAction func onCloseButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func initViews() {
        titleLabel.text = .localized("instructions_title")
        preferLandscapeLabel.text = .localized("instructions_use_landscape_text")
        focusCenterLabel.text = .localized("instructions_keep_focus_in_center")
        batteryLevelLabel.text = .localized("instructions_battery_usage")
        streamInterruptionsLabel.text = .localized("instructions_interruptions_stop_stream")
        closeButton.configureSolidButton(title: .localized("button_next"), theme: theme)
    }
}
