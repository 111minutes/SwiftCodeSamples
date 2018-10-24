//
//  CISigninViewController.swift
//  CiraSync
//
//  Created by Andriy Fedin on 11/15/16.
//  Copyright © 2016 111 Minutes. All rights reserved.
//

import UIKit

class CISigninViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = defaults.string(forKey: CIConstants.CIUserDefaultsKeys.userEmail.rawValue) {
            emailTextField.text = email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let aboutDetails = CIAboutManager.shared.aboutInformation {
            copyrightLabel.text = aboutDetails.copyright!
        } else {
            CIAPIManager.getAboutInformation(completion: { (aboutDetails) in
                self.copyrightLabel.text = CIAboutManager.shared.aboutInformation?.copyright
            }, errorHandler: { (error) in
                CIAlertService.showErrorWith(error: error, completion: {})
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let navigationController = segue.destination as? UINavigationController,
            let webAuthViewController = navigationController.viewControllers.first as? CIAuthWebViewController {
            webAuthViewController.userMail = emailTextField.text
        }
    }
    
    @IBAction func procceedLogin(_ sender: UIButton) {
        defaults.set(emailTextField.text, forKey: CIConstants.CIUserDefaultsKeys.userEmail.rawValue)
    }
}
