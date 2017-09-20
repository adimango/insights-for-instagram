//
//  AddAccountViewController.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

protocol AddAccountDisplayLogic: class {
    func diplayAddAccount(with leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func diplayLoadingAccount(with leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func diplayUpdateAccount(with accountName:String, leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem)
}

class AddAccountViewController: UIViewController, AddAccountDisplayLogic {

    // MARK: - Properties

    @IBOutlet weak var usernameTextfield: UITextField!
    var interactor: AddAccountInteractor?
    var presenter: AddAccountPresenter?
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddAccountInteractor()
        let presenter = AddAccountPresenter()
        viewController.interactor = interactor
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextfield.becomeFirstResponder()
        self.interactor?.loadAccount()
    }
    
    // MARK: - Actions
    
    func doneTapped(){
        guard let username = usernameTextfield.text, !username.isEmpty else {
            return
        }
        self.usernameTextfield.resignFirstResponder()
        self.interactor?.validateAccount(with: username)
    }
    
    func cancelTapped(){
        self.usernameTextfield.text = ""
        self.interactor?.deleteAccount()
    }
    
    // MARK: - AddAccountDisplayLogic
    
    func diplayAddAccount(with leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem){
        self.usernameTextfield.isEnabled = true
        self.navigationItem.hidesBackButton = false
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func diplayLoadingAccount(with leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem){
        self.usernameTextfield.isEnabled = false
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func diplayUpdateAccount(with accountName:String, leftBarButton:UIBarButtonItem, rightBarButton: UIBarButtonItem){
        self.usernameTextfield.text = accountName
        self.usernameTextfield.isEnabled = true
        self.usernameTextfield.becomeFirstResponder()
        self.navigationItem.hidesBackButton = false
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
}
