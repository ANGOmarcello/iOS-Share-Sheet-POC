//
//  ViewController.swift
//  Share-POC
//
//  Created by Angelo Cammalleri on 11.10.19.
//  Copyright © 2019 Angelo Cammalleri. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var airPrintSwitch: UISwitch!
    @IBOutlet weak var airDropSwitch: UISwitch!
    @IBOutlet weak var mailSwitch: UISwitch!
    @IBOutlet weak var iMessageSwitch: UISwitch!
    @IBOutlet weak var socialMediaSwitch: UISwitch!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Share Sheet Demo"
    }
    
    // MARK: Sharing
    
    @IBAction func shareTap(_ sender: Any) {
        // Get the file we want to share as data.
        let data = loadFile()
        
        // Put the data in an array because UIActivityViewController can work with multiple elements.
        var shareItems = [Any]()
        
        // As UIActivityViewController supports all kind of objects we need the objects we add to be of type any.
        shareItems.append(data as Any)
        
        // This array contains all the UIActivities we want to support. If this array is nil or empty all activities iOS finds suitable are supported.
        var excludedSharingOptions: [UIActivity.ActivityType] = []
        
         // According to our switches we want to fill the allowedSharingOptions with UIActivities now.
        if airDropSwitch.isOn {
            excludedSharingOptions.append(UIActivity.ActivityType.airDrop)
        }

        if airPrintSwitch.isOn {
            excludedSharingOptions.append(UIActivity.ActivityType.print)
        }
        
        if mailSwitch.isOn {
            excludedSharingOptions.append(UIActivity.ActivityType.mail)
        }
        
        if iMessageSwitch.isOn {
            excludedSharingOptions.append(UIActivity.ActivityType.message)
        }
        
        if socialMediaSwitch.isOn {
            let socialMedia: [UIActivity.ActivityType] = [.postToVimeo, .postToFacebook, .postToWeibo, .postToFlickr, .postToTwitter, .postToTencentWeibo]
            excludedSharingOptions.append(contentsOf: socialMedia)
        }

        // Create an UIActivityViewController in order to present it, so that the user can see the iOS share sheet.
        let share = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        // Add our exclusion list.
        share.excludedActivityTypes = excludedSharingOptions
            
        // Display the share sheet.
        present(share, animated: true)
    }
    
    @IBAction func listTap(_ sender: Any) {
        guard let url = URL(string: "https://developer.apple.com/documentation/uikit/uiactivity/activitytype") else {
            // The string contained no valid url.
            return
        }
        
        let sfVC = SFSafariViewController(url: url)
        present(sfVC, animated: true)
    }
    
    // MARK: Utilities
    
    /// This method is used to load our example pdf file from the projects bundle. If the file could not be found this will return nil.
    func loadFile() -> Data? {
        // Get the URL of the file we want to load.
        if let url = Bundle.main.url(forResource: "security-overview", withExtension: "pdf") {
            do {
                // Actually attempt to load the file with the url we recieved.
                let data = try Data(contentsOf: url)
                return data
            } catch {
                // We had an error loading or opening the file.
                return nil
            }
        } else {
            // We could not find the file to retrieve it's location in the bundle.‚
            return nil
        }
    }
}

