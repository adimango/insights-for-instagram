//
//  AppHelper.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

class AppHelper {
    
    // MARK: - Create Alert
    
    class func showAlert(with title:String?, message:String){
        var alert:UIAlertController
        
        if title != nil {
            alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        } else {
            alert = UIAlertController(title: AppConfiguration.Messages.somethingWrongMessage, message: message, preferredStyle: .actionSheet)
        }
        let action = UIAlertAction(title: NSLocalizedString(AppConfiguration.Messages.okButton, comment: message),
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async(execute: {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        })
    }
}

