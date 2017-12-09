//
//  AppDataStore.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import RealmSwift
import UIKit

class AppDataStore {
    
    // Returns the top n most liked
    class func getMostLiked (with limit:Int ) -> [InstagramMedia]{
        // paginating behavior isn’t necessary at all: https://realm.io/docs/swift/latest/#limiting-results
        let realm = try! Realm()
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "commentsCount", ascending: false)
        if medias.count > limit {
            return Array(medias[0...limit])
        }
        return Array(medias)
    }
    
    // Returns last (n) weeks posted media
    class func getLastWeeksPosted (weeks:Int) -> [InstagramMedia]{
        let realm = try! Realm()
        let fromDate = Calendar.current.date(byAdding: .day, value: -(7 * weeks), to: Date())! as NSDate
        let predicate = NSPredicate(format: "createdTime > %@", fromDate)
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "createdTime", ascending: false).filter(predicate)
        return Array(medias)
    }
    
    // Returns best Engagement
    class func getBestEngagement (with limit:Int) -> [InstagramMedia] {
        // paginating behavior isn’t necessary at all: https://realm.io/docs/swift/latest/#limiting-results
        let realm = try! Realm()
        let medias = realm.objects(InstagramMedia.self).sorted(byKeyPath: "engagementCount", ascending: false)
        if medias.count > limit {
            return Array(medias[0...limit])
        }
        return Array(medias)
    }
    
    // Returns the oldest media stored locally
    class func getInstagramMediaIndex() -> (offset: String?, count: Int) {
        let realm = try! Realm()
        let entries = realm.objects(InstagramMedia.self).sorted(byKeyPath: "createdTime", ascending: true)
        if entries.count > 0 {
            let offset = entries[0]["id"] as! String
            let count = entries.count
            return (offset, count)
        }else {
            return (nil, 0)
        }
    }
    
    // Creates/updates media
    class func importInstagramMedia(instagramMedia: [[String: Any]], completion: @escaping () -> Void){
        DispatchQueue.global().async {
            let realm = try! Realm()
            realm.beginWrite()
            for media in instagramMedia {
                let instagramMedia = InstagramMedia(JSON: media)
                realm.add(instagramMedia!, update: true)
            }
            try! realm.commitWrite()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    class func deleteAll() {
        AppUserAccount().name = nil
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        NotificationCenter.default.post(name: AppConfiguration.DefaultsNotifications.reload, object: nil)
    }
}
