//
//  AddAccountInteractor.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

class AddAccountInteractor: BaseInteractor {
    
    // MARK: - Properties    
    
    var presenter: AddAccountPresenter?
    
    // MARK: - Load media
    
    override func loadMedia() {
        guard let name = AppUserAccount().name else {
            accountName = nil
            return
        }
        accountName = name
        guard let request = createFetchMediaRequest(offset: nil) else {
            return
        }
        performFetchMedia(request: request)
    }
    
    override func loadStoredMedia () {
        presenter?.presentReportsCompleted()
        NotificationCenter.default.post(name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
    
    override func loadEmptyMedia() {}
    
    // MARK: - Storing/updating account logic
    
    func validateAccount(with userName: String) {
        presenter?.presentLoadingIndicator()
        if AppUserAccount().name != userName { //remove old account data
            AppDataStore.deleteAll()
        }
        InstagramProvider.request(.userMedia(userName)) { result in
            do {
                let response = try result.dematerialize()
                let value: [String: Any] = try response.mapNSArray()
                guard let items = value["data"] as? [[String: Any]], items.isEmpty == false else {
                    self.stopLoading(with: AppConfiguration.Messages.privateAccountMessage)
                    return
                }
                AppUserAccount().name = userName
                self.loadMedia()
            } catch {
                self.stopLoading(with: error.localizedDescription)
            }
        }
    }
    
    func loadAccount() {
        guard let name = AppUserAccount().name  else {
            presenter?.presentAddAccount()
            return
        }
        presenter?.presentUpdateAccount(account: name)
    }
    
    func deleteAccount() {
        accountName = nil
        presenter?.presentAddAccount()
        AppDataStore.deleteAll()
    }
    
    private func stopLoading(with message: String) {
        presenter?.presentAlertController(title: AppConfiguration.Messages.somethingWrongMessage, message: message)
    }
}
