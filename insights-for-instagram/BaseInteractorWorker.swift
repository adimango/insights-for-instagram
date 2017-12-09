//
//  BaseInteractorWorker.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

// MARK: - Types

enum InsightsWorkerError: Error {
    case invalidResponseKeyNotFound(String)
}

struct InsightsWorkerOutput {
    let status: String?
    let localCount: Int? //keeps track of the items limit (lite version)
}

class BaseInteractorWorker {
    
    // MARK: - Properties
    
    weak var iteractor: InsightsWorkerMediaImporting?
    var response:  [[String: AnyObject]]
    
    // MARK: Object lifecycle

    init(response: [[String: AnyObject]]) {
        self.response = response
    }
    
    //Map and store instagramMedia using Mappable and Realm
    func importFromJsonDictionary(){
        AppDataStore.importInstagramMedia(instagramMedia: response) {
            self.prepareWorkerOutput()
        }
    }
    
    private func prepareWorkerOutput(){
        let itemIndex = AppDataStore.getInstagramMediaIndex()
        let output = InsightsWorkerOutput(status: nil, localCount: itemIndex.count)
        iteractor?.didFinishImporting(output)
    }
}
