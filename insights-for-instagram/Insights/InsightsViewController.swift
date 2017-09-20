//
//  InsightTableViewController.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit
import Kingfisher

protocol InsightsViewDisplayLogic: class {
    func diplayFetchedMedia (instagramMediaSections: [InstagramMediaSection])
}

class InsightsViewController: UITableViewController, InsightsViewDisplayLogic {

    // MARK: - Properties
    
    var interactor: InsightsInteractor?
    var presenter: InsightsPresenter?
    var sections: [InstagramMediaSection]?
    var storedOffsets = [Int: CGFloat]()

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
    
    //MARK: - SetupUI
    
    private func setupUI() {
        tableView.register(InstagramMediaSectionTableViewCell.self, forCellReuseIdentifier:AppConfiguration.TableViewCellIdentifiers.cell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
    }
    
    // MARK: - Fetch Media
    
    func fetchMediaOnload(){
        DispatchQueue.global(qos: .background).async {
            self.interactor?.loadMedia()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConfiguration.TableViewCellIdentifiers.cell, for: indexPath) as! InstagramMediaSectionTableViewCell
        let instagramItemsSection = self.sections![indexPath.row]
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.sectionNameLabel.text = instagramItemsSection.sectionTitle
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
        
    func diplayFetchedMedia(instagramMediaSections: [InstagramMediaSection]) {
        self.sections = instagramMediaSections
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension InsightsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Collections view data source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        let instagramMediaSection = self.sections![index]
        return instagramMediaSection.instagramMediaViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = collectionView.tag
        let instagramMediaSection = self.sections![index]
        let media = instagramMediaSection.instagramMediaViews[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConfiguration.TableViewCellIdentifiers.cell, for: indexPath) as! InstagramMediaCollectionViewCell
        cell.likesLabel.text = media.likes
        cell.commentsLabel.text = media.comments
        if let url = URL(string: media.imageURL) {
        cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.height - 10
        return CGSize(width: 324/2, height: h)
    }
}

