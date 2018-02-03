import Foundation
import UIKit

class InstagramMediaSectionTableViewCell: UITableViewCell {
    
    // MARK: Object lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        contentView.backgroundColor = UIColor.clear
        addSubview(itemsCollectionView)
        addSubview(dividerLineView)
        addSubview(sectionNameLabel)
        itemsCollectionView.addConstraint(NSLayoutConstraint(item: itemsCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (420/2)))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[sectionNameLabel]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["sectionNameLabel": sectionNameLabel]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[dividerLineView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["dividerLineView": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[itemsCollectionView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["itemsCollectionView": itemsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dividerLineView(0.5)][sectionNameLabel(40)][itemsCollectionView]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["itemsCollectionView": itemsCollectionView, "dividerLineView": dividerLineView, "sectionNameLabel": sectionNameLabel]))
        itemsCollectionView.register(InstagramMediaCollectionViewCell.self, forCellWithReuseIdentifier: AppConfiguration.TableViewCellIdentifiers.cell)
    }
}

// MARK: UICollectionViewDataSource

extension InstagramMediaSectionTableViewCell {
    //Following https://github.com/ashfurrow/ design
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        itemsCollectionView.delegate = dataSourceDelegate
        itemsCollectionView.dataSource = dataSourceDelegate
        itemsCollectionView.tag = row
        itemsCollectionView.setContentOffset(itemsCollectionView.contentOffset, animated: false)
        itemsCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { itemsCollectionView.contentOffset.x = newValue }
        get { return itemsCollectionView.contentOffset.x }
    }
}

// MARK: InstagramMediaViewCell

class InstagramMediaCollectionViewCell: UICollectionViewCell {
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        image.image = UIImage(named: "placeHolder")
        return image
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(likesLabel)
        addSubview(commentsLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        likesLabel.frame = CGRect(x: 0, y: frame.width + 6, width: frame.width, height: 16)
        commentsLabel.frame = CGRect(x: 0, y: frame.width + 25, width: frame.width, height: 16)
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeHolder")
    }
}
