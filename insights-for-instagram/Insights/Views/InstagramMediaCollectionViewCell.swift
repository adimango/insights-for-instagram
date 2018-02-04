import UIKit
import Kingfisher

class InstagramMediaCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var mediaModelView: InstagramMediaView? {
        didSet {
            updateViews()
        }
    }
    
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
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(likesLabel)
        addSubview(commentsLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        likesLabel.frame = CGRect(x: 0, y: frame.width + 6, width: frame.width, height: 16)
        commentsLabel.frame = CGRect(x: 0, y: frame.width + 25, width: frame.width, height: 16)
    }
    
    func updateViews() {
        self.likesLabel.text = mediaModelView?.likes
        self.commentsLabel.text = mediaModelView?.comments
        if let imageUrl = mediaModelView?.imageURL, let url = URL(string: imageUrl) {
            self.imageView.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeHolder")
    }
}
