import UIKit

protocol AddAccountDisplayLogic: class {
    func diplayAddAccount(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func diplayLoadingAccount(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func diplayUpdateAccount(with accountName: String, leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func diplayAlert(title: String, message: String)
}

class AddAccountViewController: UIViewController, AddAccountDisplayLogic {

    // MARK: - Properties

    @IBOutlet weak var usernameTextfield: UITextField!
    var interactor: AddAccountInteractor?
    var presenter: AddAccountPresenter?
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddAccountInteractor()
        let presenter = AddAccountPresenter()
        viewController.interactor = interactor
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.becomeFirstResponder()
        interactor?.loadAccount()
    }
    
    // MARK: - Actions
    
    @objc func doneTapped() {
        guard let username = usernameTextfield.text, !username.isEmpty else {
            return
        }
        usernameTextfield.resignFirstResponder()
        interactor?.validateAccount(with: username)
    }
    
     @objc func cancelTapped() {
        usernameTextfield.text = ""
        interactor?.deleteAccount()
    }
    
    // MARK: - AddAccountDisplayLogic
    
    func diplayAddAccount(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextfield.isEnabled = true
        navigationItem.hidesBackButton = false
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func diplayLoadingAccount(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextfield.isEnabled = false
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func diplayUpdateAccount(with accountName: String, leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextfield.text = accountName
        usernameTextfield.isEnabled = true
        usernameTextfield.becomeFirstResponder()
        navigationItem.hidesBackButton = false
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func diplayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AppConfiguration.Messages.okButton, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
