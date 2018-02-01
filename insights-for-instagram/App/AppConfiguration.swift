//
//  AppConfiguration.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import Foundation

class AppConfiguration {
    
    // MARK: - AppConfiguration.TableViewSection
    
    struct TableViewSections {
        static let zero = NSLocalizedString("Best Engagement", comment: "")
        static let one = NSLocalizedString("Top 25 Most Commented", comment: "")
        static let two = NSLocalizedString("Recently Posted", comment: "")
    }
    
    // MARK: - AppConfiguration.TableViewCellIdentifiers
    
    struct TableViewCellIdentifiers {
        static let cell = "cellID"
    }
    
    struct DefaultsNotifications {
        static let reload = Notification.Name(rawValue: "reload")
    }
    
    // MARK: - AppConfiguration.Messages
    
    struct Messages {
        static let okButton = NSLocalizedString("OK", comment: "")
        static let doneButton = NSLocalizedString("Done", comment: "")
        static let cancelButton = NSLocalizedString("Cancel", comment: "")
        static let deleteAllButton = NSLocalizedString("Delete All", comment: "")
        static let somethingWrongMessage = NSLocalizedString("Something went wrong", comment: "")
        static let privateAccountMessage = NSLocalizedString("This account is private", comment: "")
        static let reportsCompletedTitle = NSLocalizedString("Reports Completed", comment: "")
        static let reportsCompletedMessage = NSLocalizedString("Please go back to the Insights screen", comment: "")
        static let deleteReportsTitle = NSLocalizedString("Delete Reports", comment: "")
        static let deleteReportsMessage = NSLocalizedString("Remove my account and delete all the reports", comment: "")
    }
}
