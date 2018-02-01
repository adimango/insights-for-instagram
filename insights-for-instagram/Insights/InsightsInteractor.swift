//
//  InsightsInteractor.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

class InsightsInteractor: BaseInteractor {
    
    // MARK: - Properties
    
    var presenter: InstagramMediaPresentation?
    
    // MARK: Object lifecycle
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(InsightsInteractor.loadMedia), name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Load media
    
    @objc override func loadMedia() {
        guard let name = AppUserAccount().name else {
            accountName = nil
            loadEmptyMedia()
            return
        }
        accountName = name
        loadStoredMedia()
        guard let request = createFetchMediaRequest(offset: nil) else {
            return
        }
        performFetchMedia(request: request)
    }
    
    override func loadEmptyMedia() {
        presenter?.presentNoAccountSections()
    }
    
    override func loadStoredMedia() {
        let bestEngagement = AppDataStore.getBestEngagement(with: 25)
        let lastWeeksPosted = AppDataStore.getLastWeeksPosted(weeks: 12)
        let topMostCommented = AppDataStore.getMostLiked(with: 25)
        let bestEngagementDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.zero, "items": bestEngagement]
        let mostCommentedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.one, "items": topMostCommented]
        let lastWeeksPostedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.two, "items": lastWeeksPosted]
        presenter?.presentLoadedSections(with: [bestEngagementDictionary, mostCommentedDictionary, lastWeeksPostedDictionary])
    }
    
    override func loadFetchMediaFailureAlert(error: Error) {
        presenter?.presentAlertController(with: error.localizedDescription)
    }
}
