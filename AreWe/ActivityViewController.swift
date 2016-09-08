//
//  ViewController.swift
//  AreWe
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit

final class ActivityViewController: UIViewController {

    override func loadView() {
        let activityView = ActivityView()
        activityView.delegate = self

        self.view = activityView
    }

}

final class SaveToKeyboard: UIActivity {
    private var image: UIImage?

    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        image = activityItems
            .filter { $0 is UIImage }
            .first as? UIImage
    }

    override func activityTitle() -> String? {
        return "Save to keyboard"
    }

    override func activityImage() -> UIImage? {
        return UIImage(named: "share")
    }

    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return !activityItems.filter { $0 is UIImage }.isEmpty
    }

    override func performActivity() {
        guard let image = image else { return }

        let manager = NSFileManager.defaultManager()
        let activitiesURL = manager
            .containerURLForSecurityApplicationGroupIdentifier("group.perfectly-cooked.arewe")?
            .URLByAppendingPathComponent("activities")

        let activitiesPath = activitiesURL!.path!

        if !manager.fileExistsAtPath(activitiesPath) {
            try! manager.createDirectoryAtPath(activitiesPath, withIntermediateDirectories: true, attributes: [:])
        }

        let data = UIImagePNGRepresentation(image)
        let filename = NSUUID().UUIDString + ".png"
        let fullpath = activitiesPath.stringByAppendingString("/\(filename)")
        try! data?.writeToFile(fullpath, options: .DataWritingAtomic)

        self.activityDidFinish(true)
    }
}

extension ActivityViewController: ActivityViewDelegate {
    func didTapShare() {
        let screenshot = (view as! ActivityView).screenshot()

        let sharingController = UIActivityViewController(activityItems: [screenshot], applicationActivities: [SaveToKeyboard()])
        presentViewController(sharingController, animated: true, completion: nil)
    }
}
