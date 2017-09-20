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
    let offset: String? //used as offset for pagination (Instagram max_id)
    let moreAvailable: Bool?
    let localCount: Int? //keeps track of the items limit (lite version)
}

class BaseInteractorWorker {
    
    // MARK: - Properties
    
    weak var iteractor: InsightsWorkerMediaImporting?
    var response: [String: AnyObject]
    
    // MARK: Object lifecycle

    init(response: [String: AnyObject]) {
        self.response = response
    }
    
    //Map and store instagramMedia using Mappable and Realm
    func importFromJsonDictionary() throws{
        guard let items = self.response["items"] as? [[String: Any]] else {
        throw InsightsWorkerError.invalidResponseKeyNotFound("items")
        }
        AppDataStore.importInstagramMedia(instagramMedia: items)
        try! self.prepareWorkerOutput()
    }
    
    private func prepareWorkerOutput() throws {
        let status = self.response["status"] as! String
        let itemIndex = AppDataStore.getInstagramMediaIndex()
        let moreAvailable = self.response["more_available"] as! Bool
        let output = InsightsWorkerOutput(status: status, offset: itemIndex.offset, moreAvailable: moreAvailable, localCount: itemIndex.count)
        self.iteractor?.didFinishImporting(output)
    }
}
