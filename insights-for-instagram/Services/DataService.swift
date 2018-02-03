import RealmSwift

class DataService {
    
    static func media( for userName: String, completion: @escaping ( _ error: String?) -> Void) {
        InstagramProvider.request(.userMedia(userName)) { result in
            do {
                let response = try result.dematerialize()
                let value: [String: Any] = try response.mapNSArray()
                guard let items = value["data"] as? [[String: Any]], items.isEmpty == false else {
                completion(AppConfiguration.Messages.privateAccountMessage)
                return
                }
                AppUserAccount().name = userName
                importInstagramMedia(instagramMedia: items, completion: {
                    completion(nil)
                })
            } catch {
                completion(error.localizedDescription)
            }
        }
    }
    
    // Returns the top n most liked
    static func mostLiked (with limit: Int ) -> [InstagramMedia] {
        // paginating behavior isn’t necessary at all: https://realm.io/docs/swift/latest/#limiting-results
        guard let realm = try? Realm() else { return [] }
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "commentsCount", ascending: false)
        if medias.count > limit {
            return Array(medias[0...limit])
        }
        return Array(medias)
    }
    
    // Returns last (n) weeks posted media
    static func lastWeeksPosted (weeks: Int) -> [InstagramMedia] {
        guard let realm = try? Realm() else { return [] }
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(7 * weeks), to: Date()) else { return [] }
        let predicate = NSPredicate(format: "createdTime > %@", fromDate as CVarArg)
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "createdTime", ascending: false).filter(predicate)
        return Array(medias)
    }
    
    // Returns best Engagement
    static func bestEngagement (with limit: Int) -> [InstagramMedia] {
        guard let realm = try? Realm() else { return [] }
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "engagementCount", ascending: false)
        if medias.count > limit {
            return Array(medias[0...limit])
        }
        return Array(medias)
    }
    
    // Returns the oldest media stored locally
    static func instagramMediaIndex() -> (offset: String?, count: Int) {
        guard let realm = try? Realm() else { return (nil, 0) }
        let entries = realm.objects(InstagramMedia.self).sorted(byKeyPath: "createdTime", ascending: true)
        if entries.isEmpty == false {
            guard let offset = entries[0]["id"] as? String else { return (nil, 0) }
            let count = entries.count
            return (offset, count)
        } else {
            return (nil, 0)
        }
    }
    
    // Creates/updates media
    static func importInstagramMedia(instagramMedia: [[String: Any]], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            guard let realm = try? Realm() else { return }
            realm.beginWrite()
            for media in instagramMedia {
                guard let instagramMedia = InstagramMedia(JSON: media) else {
                    continue
                }
                realm.add(instagramMedia, update: true)
            }
            try? realm.commitWrite()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func importInstagramMedia(instagramMedia: [[String: Any]], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            guard let realm = try? Realm() else { return }
            realm.beginWrite()
            for media in instagramMedia {
                guard let instagramMedia = InstagramMedia(JSON: media) else {
                    continue
                }
                print("add")
                realm.add(instagramMedia, update: true)
            }
            try? realm.commitWrite()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func deleteAll() {
        AppUserAccount().name = nil
        guard let realm = try? Realm() else { return }
        try? realm.write {
            realm.deleteAll()
        }
        NotificationCenter.default.post(name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
}
