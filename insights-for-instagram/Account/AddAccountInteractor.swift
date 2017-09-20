//
//  AddAccountInteractor.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit
import Moya

class AddAccountInteractor:BaseInteractor {
    
    // MARK: - Properties    
    
    var presenter: AddAccountPresenter?
    
    // MARK: - Load media
    
    override func loadMedia() {
        guard let name = AppUserAccount().name else {
            self.accountName = nil
            return
        }
        self.accountName = name
        guard let request = createFetchMediaRequest(offset: nil) else {
            return
        }
        performFetchMedia(request: request)
    }
    
    override func loadStoredMedia (){
        self.presenter?.presentAddAccount()
        AppHelper.showAlert(with: AppConfiguration.Messages.reportsCompletedTitle, message: AppConfiguration.Messages.goBackToInsightsMessage)
        NotificationCenter.default.post(name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
    
    override func loadEmptyMedia() {
        
    }
    
    // MARK: - Storing/updating account logic
    
    func validateAccount(with userName:String) {
        self.presenter?.presentLoadingIndicator()
        if AppUserAccount().name != userName { //remove old account data
            AppDataStore.deleteAll()
        }
        InstagramProvider.request(.userMedia(userName,"")){ result in
            do {
                let response = try result.dematerialize()
                let value:[String: Any] = try response.mapNSArray()
                let items = value["items"] as? [[String: Any]]
                if (items?.count)! > 0 {
                    AppUserAccount().name = userName
                    self.downloadItems()
                }else {
                    self.stopLoading(with: AppConfiguration.Messages.privateAccountMessage)
                }
            } catch {
                self.stopLoading(with: error.localizedDescription)
            }
        }
    }
    
    func loadAccount(){
        if let name = AppUserAccount().name {
            self.presenter?.presentUpdateAccount(account: name)
        }else{
            self.presenter?.presentAddAccount()
        }
    }
    
    func deleteAccount() {
        self.accountName = nil
        self.presenter?.presentAddAccount()
        AppDataStore.deleteAll()
    }
    
    private func stopLoading(with message:String){
        self.presenter?.presentAddAccount()
        AppHelper.showAlert(with: nil, message: message)
    }
    
    private func downloadItems() {
        self.loadMedia()
    }
}
