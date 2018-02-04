import UIKit

protocol InsightsViewDisplayLogic: class {
    func diplayFetchedMedia(instagramMediaSections: [InstagramMediaSection], weekday: String)
    func diplayFetchMediaFailureAlert(title: String, message: String)
}

class InsightsViewController: UITableViewController, InsightsViewDisplayLogic {

    // MARK: - Properties
    
    var interactor: InsightsInteractor?
    var presenter: InstagramMediaPresentation?
    var sections: [InstagramMediaSection]?
    var storedOffsets = [Int: CGFloat]()

    @IBOutlet weak var footerView: UIView?
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var refreshController: UIRefreshControl!
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
       let viewController = self
       let interactor = InsightsInteractor()
       let presenter = InsightsPresenter()
       viewController.interactor = interactor
       viewController.presenter = presenter
       interactor.presenter = presenter
       presenter.viewController = viewController
       sections = []
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMediaOnload()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        tableView.register(InstagramMediaSectionTableViewCell.self, forCellReuseIdentifier: AppConfiguration.TableViewCellIdentifiers.cell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        self.footerView?.isHidden = true
    }
    
    // MARK: - Fetch Media
    
    func fetchMediaOnload() {
        DispatchQueue.global(qos: .background).async {
            self.interactor?.loadMedia()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConfiguration.TableViewCellIdentifiers.cell, for: indexPath) as? InstagramMediaSectionTableViewCell else {
            return InstagramMediaSectionTableViewCell()
        }
        let instagramItemsSection = self.sections?[indexPath.row]
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.sectionNameLabel.text = instagramItemsSection?.sectionTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InstagramMediaSectionTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(_ sender: Any) {
        fetchMediaOnload()
    }
    
    @IBAction func displayAccount(_ sender: Any) {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
        
    func diplayFetchedMedia(instagramMediaSections: [InstagramMediaSection], weekday: String) {
        self.sections = instagramMediaSections
        DispatchQueue.main.async {
            self.footerView?.isHidden = false
            self.weekdayLabel.text = weekday
            self.refreshController.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func diplayFetchMediaFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AppConfiguration.Messages.okButton, style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension InsightsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Collections view data source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        let instagramMediaSection = self.sections?[index]
        return (instagramMediaSection?.instagramMediaViews.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = collectionView.tag
        let instagramMediaSection = self.sections?[index]
        let media = instagramMediaSection?.instagramMediaViews[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConfiguration.TableViewCellIdentifiers.cell, for: indexPath) as?
            InstagramMediaCollectionViewCell else { return InstagramMediaCollectionViewCell() }
        cell.mediaModelView = media
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.height - 10
        return CGSize(width: 324/2, height: h)
    }
}
