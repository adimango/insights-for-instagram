//
//  MainAccountViewController
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
   
    // MARK: - Properties

    @IBOutlet weak var accountNameTableCell: UITableViewCell!

    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView()
        guard let name = AppUserAccount().name else {
            accountNameTableCell.textLabel?.text = NSLocalizedString("Account Name", comment: "")
            return
        }
        accountNameTableCell.textLabel?.text = name
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        accountNameTableCell.isSelected = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
           let cell = tableView.cellForRow(at: indexPath)
           cell?.isSelected = false
           diplayDeleteAllReportsAlert()
        }
    }
    
    // MARK: - Actions
    
    private func diplayDeleteAllReportsAlert(){
    
    let alertController = UIAlertController(title: AppConfiguration.Messages.deleteReportsTitle, message: AppConfiguration.Messages.deleteReportsMessage, preferredStyle: UIAlertControllerStyle.alert)
        
    let deleteAllAction = UIAlertAction(title: AppConfiguration.Messages.deleteAllButton, style: UIAlertActionStyle.destructive) {
        (result : UIAlertAction) -> Void in
        self.accountNameTableCell.textLabel?.text = NSLocalizedString("Account Name", comment: "")
        AppDataStore.deleteAll()
    }
        
    let cancelAction = UIAlertAction(title: AppConfiguration.Messages.cancelButton, style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAllAction)
    present(alertController, animated: true, completion: nil)
    
    }
}
