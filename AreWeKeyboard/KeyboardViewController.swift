//
//  KeyboardViewController.swift
//  AreWeKeyboard
//
//  Created by Romain Pouclet on 2016-09-07.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import UIKit
import MobileCoreServices

final class ActivityCell: UITableViewCell {

    let activityImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        activityImageView.contentMode = .ScaleAspectFit
        contentView.addSubview(activityImageView)

        NSLayoutConstraint.activateConstraints([
            activityImageView.heightAnchor.constraintEqualToAnchor(heightAnchor, constant: -20),
            activityImageView.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -20),
            activityImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            activityImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")

        return tableView
    }()

    private var activities = [NSURL]()

    private let cache = NSCache()

    override func updateViewConstraints() {
        super.updateViewConstraints()

        NSLayoutConstraint.activateConstraints([
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
    
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true

        let manager = NSFileManager.defaultManager()
        let url = manager.containerURLForSecurityApplicationGroupIdentifier("group.perfectly-cooked.arewe")?.URLByAppendingPathComponent("activities")
        self.activities = manager
            .enumeratorAtURL(url!, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants, errorHandler: nil)?
            .allObjects as? [NSURL] ?? []

    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}

extension KeyboardViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityCell
        let activity = activities[indexPath.row]

        if let image = cache.objectForKey(indexPath) as? UIImage {
            cell.activityImageView.image = image
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let imageContent = NSData(contentsOfURL: activity)!
                guard let image = UIImage(data: imageContent) else { return }
                self.cache.setObject(image, forKey: indexPath)

                dispatch_async(dispatch_get_main_queue(), { 
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ActivityCell
                    cell?.activityImageView.image = image
                })
            }
        }

        return cell
    }

}

extension KeyboardViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height * 9 / 16
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let image = cache.objectForKey(indexPath) as? UIImage else { return }

        UIPasteboard.generalPasteboard().image = image
    }
}
