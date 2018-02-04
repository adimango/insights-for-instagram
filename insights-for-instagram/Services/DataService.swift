import RealmSwift

enum Weekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

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
        let predicate = NSPredicate(format: "createdTime > %@", fromDate as NSDate)
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
    
    // Weekday
    // swiftlint:disable:next cyclomatic_complexity
    static func weekday() -> String {
        
        guard let realm = try? Realm() else { return "" }
        
        var predicateArray = [NSPredicate]()
        var groupbyArray = [[InstagramMedia]]()
        var summedEngagementArray = [(Int, Int)]()

        for weekday in 1...7 {
            let predicate = NSPredicate(format: "weekday == %d", weekday)
            predicateArray.append(predicate)
        }
        for weekday in predicateArray.indices {
            let medias = Array(realm.objects(InstagramMedia.self).filter(predicateArray[weekday]))
            groupbyArray.append(medias)
        }
        for weekday in groupbyArray.indices {
            let array = groupbyArray[weekday]
            summedEngagementArray.append(DataService.sumEngagement(for: array, day: weekday))
        }
        
        summedEngagementArray = summedEngagementArray.sorted(by: { $0.0 > $1.0 })

        switch summedEngagementArray[0].1 {
        case Weekday.sunday.rawValue:
            return "Sunday."
        case Weekday.monday.rawValue:
            return "Monday."
        case Weekday.tuesday.rawValue:
            return "Tuesday."
        case Weekday.wednesday.rawValue:
            return "Wednesday."
        case Weekday.thursday.rawValue:
            return "Thursday."
        case Weekday.friday.rawValue:
            return "Friday."
        case Weekday.saturday.rawValue:
            return "Saturday."
        default:
            return "Weekday."
        }
    }
    
    static func sumEngagement(for array: [InstagramMedia], day: Int) -> (Int, Int) {
        var engagmentSum = 0
        for media in array {
            engagmentSum += media.engagementCount
        }
        return (engagmentSum, day + 1)
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
