import UIKit

class InsightsInteractor {
    
    // MARK: - Properties
    
    var presenter: InstagramMediaPresentation?
    
    // MARK: Object lifecycle
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(InsightsInteractor.loadMedia), name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Load media
    
    @objc func loadMedia() {
        guard let userName = AppUserAccount().name else {
            loadEmptyMedia()
            return
        }
        loadStoredMedia()
        DataService.media(for: userName) { (error) in
            if error == nil {
                self.loadStoredMedia()
            }
        }
    }
    
    func loadEmptyMedia() {
        presenter?.presentNoAccountSections()
    }
    
    func loadStoredMedia() {
        let bestEngagement = DataService.bestEngagement(with: 25)
        let lastWeeksPosted = DataService.lastWeeksPosted(weeks: 12)
        let topMostCommented = DataService.mostLiked(with: 25)
        let bestEngagementDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.zero, "items": bestEngagement]
        let mostCommentedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.one, "items": topMostCommented]
        let lastWeeksPostedDictionary: [String: Any] = ["sectionTitle": AppConfiguration.TableViewSections.two, "items": lastWeeksPosted]
        presenter?.presentLoadedSections(with: [bestEngagementDictionary, mostCommentedDictionary, lastWeeksPostedDictionary])
    }
    
    func loadFetchMediaFailureAlert(error: Error) {
        presenter?.presentAlertController(with: error.localizedDescription)
    }
}
