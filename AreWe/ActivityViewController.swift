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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(didTapDone))
    }

    func didTapDone() {
        let manager = NSFileManager.defaultManager()
        let activitiesURL = manager.containerURLForSecurityApplicationGroupIdentifier("group.perfectly-cooked.arewe")?.URLByAppendingPathComponent("activities")
        let activitiesPath = activitiesURL!.path!

        if !manager.fileExistsAtPath(activitiesPath) {
            try! manager.createDirectoryAtPath(activitiesPath, withIntermediateDirectories: true, attributes: [:])
        }

        let screenshot = (view as! ActivityView).screenshot()
        let data = UIImagePNGRepresentation(screenshot)
        let filename = NSUUID().UUIDString + ".png"
        let fullpath = activitiesPath.stringByAppendingString("/\(filename)")
        print("path = \(fullpath)")
        try! data?.writeToFile(fullpath, options: .DataWritingAtomic)
    }

}

extension ActivityViewController: ActivityViewDelegate {
    func didTapShare() {
        let screenshot = (view as! ActivityView).screenshot()

        let sharingController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        presentViewController(sharingController, animated: true, completion: nil)
    }
}
