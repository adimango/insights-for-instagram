//
//  AddAccountPresenter.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import Foundation
import UIKit

class AddAccountPresenter {
    
    // MARK: - Properties
    
    weak var viewController: AddAccountDisplayLogic?
    
    // MARK: AddCoountPresentation Logic
    
    func presentAddAccount() {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Account"
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: viewController, action: #selector(AddAccountViewController.doneTapped))
        DispatchQueue.main.async {
            self.viewController?.diplayAddAccount(with: leftBarButton, rightBarButton: rightBarButton)
        }
    }
    
    func presentLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = UIColor.black
        activityIndicator.startAnimating()
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: viewController, action: #selector(AddAccountViewController.cancelTapped))
        let rightBarButton = UIBarButtonItem(customView: activityIndicator)
        DispatchQueue.main.async {
            self.viewController?.diplayLoadingAccount(with: leftBarButton, rightBarButton: rightBarButton)
        }
    }
    
    func presentUpdateAccount(account:String) {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Account"
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: viewController, action: #selector(AddAccountViewController.doneTapped))
        DispatchQueue.main.async {
            self.viewController?.diplayUpdateAccount(with: account, leftBarButton: leftBarButton, rightBarButton: rightBarButton)
        }
    }
}
