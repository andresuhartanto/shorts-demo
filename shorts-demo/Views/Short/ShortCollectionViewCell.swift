//
//  ShortCollectionViewCell.swift
//  shorts-demo
//
//  Created by Andre on 2022/12/8.
//

import UIKit
import AVFoundation

protocol ShortCollectionViewCellDelegate: NSObject {
    func likeTapped(data: ShortDataModel, index: Int)
}

class ShortCollectionViewCell: UICollectionViewCell {
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    @IBOutlet weak var shortContentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    weak var delegate: ShortCollectionViewCellDelegate?
    
    var data: ShortDataModel!
    var index: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avPlayer = nil
        avPlayerLayer.removeFromSuperlayer()
    }

    func setupCell(data: ShortDataModel, index: Int) {
        self.data = data
        self.index = index
        
        print("Setup Short Cell")
        shortNameLabel.text = data.title
        avatarImageView.image = UIImage(named: data.user.avatar)
        usernameLabel.text = data.user.username
        likeCountLabel.text = "\(data.likes)"
        likeImageView.image = UIImage(named: data.isLiked ? "filled-heart" : "unfilled-heart")
        
        setupVideo(name: data.video)
    }
    
    private func setupVideo(name: String) {
        let theURL = Bundle.main.url(forResource: name, withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayer?.volume = 100
        avPlayer?.actionAtItemEnd = .none
        
        shortContentView.layoutIfNeeded()
        avPlayerLayer.frame = shortContentView.layer.bounds
        shortContentView.backgroundColor = .clear
        shortContentView.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseVideo), name: Notification.Name("pauseVideo"), object: nil)
        
        avPlayer?.play()
    }
    
    @objc func pauseVideo() {
        avPlayer?.pause()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let player: AVPlayerItem = notification.object as? AVPlayerItem else { return }
        player.seek(to: .zero)
    }
}

// MARK: - IBActions
extension ShortCollectionViewCell {
    @IBAction func likeButtonPressed(_ sender: Any) {
        data.isLiked.toggle()
        data.likes = data.isLiked ? data.likes + 1 : data.likes - 1
        likeImageView.image = UIImage(named: data.isLiked ? "filled-heart" : "unfilled-heart")
        likeCountLabel.text = "\(data.likes)"
        
        delegate?.likeTapped(data: data, index: index)
    }
}
