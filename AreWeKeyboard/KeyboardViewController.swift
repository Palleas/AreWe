//
//  KeyboardViewController.swift
//  AreWeKeyboard
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import MobileCoreServices

class KeyboardViewController: UIInputViewController {

    private var activities = [Activity]()

    override func loadView() {

        let manager = NSFileManager.defaultManager()
        let url = manager.containerURLForSecurityApplicationGroupIdentifier("group.perfectly-cooked.arewe")?.URLByAppendingPathComponent("activities")

        let urls = manager
            .enumeratorAtURL(url!, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants, errorHandler: nil)?
            .allObjects as? [NSURL] ?? []
        self.activities = urls.map(Activity.init)

        let keyboardView = KeyboardView(activities: activities)
        keyboardView.delegate = self

        self.view = keyboardView
    }
}

extension KeyboardViewController: KeyboardViewDelegate {
    func didTapNextKeyboard() {
        advanceToNextInputMode()
    }

    func didSelect(activity activity: Activity) {
        UIPasteboard.generalPasteboard().setData(NSData(contentsOfURL: activity.url)!, forPasteboardType: kUTTypePNG as String)
    }
}
