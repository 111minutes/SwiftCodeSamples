//
//  CIUserSession.swift
//  CiraSync
//
//  Created by Andriy Fedin on 12/7/16.
//  Copyright © 2016 111 Minutes. All rights reserved.
//

import Foundation

class CIUserSession: NSObject {
    
    private let defaults = UserDefaults.standard
    static let shared = CIUserSession()
    
    var user: CIUser? {
        didSet {
            if let email = user?.email {
                defaults.set(email, forKey: CIConstants.CIUserDefaultsKeys.userEmail.rawValue)
            }
        }
    }
    
    private override init() { //This prevents others from using the default '()' initializer for this class.
        super.init()
        
        if let userData = UserDefaults.standard.object(forKey: CIConstants.CIUserDefaultsKeys.userEmail.rawValue) as? NSData {
            user = NSKeyedUnarchiver.unarchiveObject(with: userData as Data) as? CIUser
        }
    }
    
    func saveUser() {
        if let user = self.user {
            let userData = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(userData, forKey: CIConstants.CIUserDefaultsKeys.userData.rawValue)
        }
    }
    
    func signOut() {
        user = nil
        CIAPIManager.cancelRequest(request: .All)
        UserDefaults.standard.removeObject(forKey: CIConstants.CIUserDefaultsKeys.userData.rawValue)
    }
    
    func setupUserWith(_ token: String) {
        user = CIUser()
        user?.token = token
        saveUser()
    }
}
