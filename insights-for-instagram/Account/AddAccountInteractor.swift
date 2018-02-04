import UIKit

class AddAccountInteractor {
    
    // MARK: - Properties    
    
    var presenter: AddAccountPresenter?
    
    // MARK: - Storing/updating account logic
    
    func validateAccount(with userName: String) {
        presenter?.presentLoadingIndicator()
        if AppUserAccount().name != userName { //remove old account data
            DataService.deleteAll()
        }
        
        DataService.media(for: userName) { (error) in
            guard let error = error else {
                self.presenter?.presentReportsCompleted()
                NotificationCenter.default.post(name: AppConfiguration.DefaultsNotifications.reload, object: nil)
                return
            }
            self.stopLoading(with: error)
        }
    }
    
    func loadAccount() {
        guard let name = AppUserAccount().name  else {
            presenter?.presentAddAccount()
            return
        }
        presenter?.presentUpdateAccount(account: name)
    }
    
    func deleteAccount() {
        presenter?.presentAddAccount()
        DataService.deleteAll()
    }
    
    private func stopLoading(with message: String) {
        presenter?.presentAlertController(title: AppConfiguration.Messages.somethingWrongMessage, message: message)
    }
}
