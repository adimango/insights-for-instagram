import Foundation

class AppUserAccount {
    enum DefaultsKeys: String {
        case UserAccountKey
    }
    
    // MARK: - Initializers
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    // MARK: - Properties
    
    var name: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.UserAccountKey.rawValue)
            return key
        }
        set(newName) {
            guard let name = newName else {
            defaults.removeObject(forKey: DefaultsKeys.UserAccountKey.rawValue)
            defaults.synchronize()
            return
            }
            defaults.set(name, forKey: DefaultsKeys.UserAccountKey.rawValue)
            defaults.synchronize()
        }
    }
}
