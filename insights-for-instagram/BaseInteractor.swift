//
//  BaseInteractor.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import Moya

struct FetchMediaRequest {
    let accountName: String?
    let offset: String?
}

protocol InsightsWorkerMediaImporting: class {
    func didFinishImporting(_ output: InsightsWorkerOutput?)
}

class BaseInteractor: InsightsWorkerMediaImporting {
    
    // MARK: - Properties
    
    var worker: BaseInteractorWorker?
    var accountName: String?
    
    func performFetchMedia (request: FetchMediaRequest) {
        guard let accountName = request.accountName else { return }
        InstagramProvider.request(.userMedia(accountName)) { result in
            do {
                let response = try result.dematerialize()
                let value: [String: Any] = try response.mapNSArray()
                guard let media = value["data"] as? [[String: AnyObject]], media.isEmpty == false else {
                    self.loadStoredMedia()
                    return
                }
                self.initInsightsWorkerWithResponse(response: media)
            } catch {
                self.loadFetchMediaFailureAlert(error: error)
            }
        }
    }
    
    // MARK: - Create Fetch Items Request
    
    func createFetchMediaRequest(offset: String?) -> FetchMediaRequest? {
        guard self.accountName != nil else {
            return nil
        }
        return FetchMediaRequest(accountName: self.accountName, offset: offset)
    }
    
    // MARK: - Create Worker
    
    private func initInsightsWorkerWithResponse (response: [[String: AnyObject]]) {
        self.worker = BaseInteractorWorker(response: response)
        let iteractor = self
        worker?.iteractor = iteractor
        DispatchQueue.global(qos: .background).async {
            self.worker?.importFromJsonDictionary()
        }
    }
    
    // MARK: - InsightsWorkerDelegate
    
    func didFinishImporting(_ output: InsightsWorkerOutput?) {
        guard let localCount = output?.localCount, localCount > 0 else {
            loadEmptyMedia()
            return
        }
        loadStoredMedia()
    }
    
    // MARK: - Base interactor to be overriden actions
    
    func loadMedia() {
        preconditionFailure("loadMedia must be overridden")
    }
    
    func loadEmptyMedia() {
        preconditionFailure("loadEmptyMedia must be overridden")
    }
    
    func loadStoredMedia() {
        preconditionFailure("loadStoredMedia must be overridden")
    }
    
    func loadFetchMediaFailureAlert(error: Error) {
        preconditionFailure("loadFetchMediaFailureAlert must be overridden")
    }
}
