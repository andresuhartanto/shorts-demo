//
//  ShortsViewController.swift
//  shorts-demo
//
//  Created by Andre on 2022/12/8.
//

import UIKit

class ShortsViewController: UIViewController {
    @IBOutlet weak var playPauseImageView: UIImageView! {
        didSet {
            playPauseImageView.alpha = 0
        }
    }
    @IBOutlet weak var shortsCollectionView: UICollectionView! {
        didSet {
            shortsCollectionView.dataSource = self
            shortsCollectionView.delegate = self
            shortsCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
            shortsCollectionView.register(UINib(nibName: ShortCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ShortCollectionViewCell.className)
        }
    }
    
    var shorts: [ShortDataModel] = [
        ShortDataModel(user: UserDataModel(username: "Pikachu", avatar: "pikachu"), title: "Sintel Story Fight", likes: 1226, isLiked: false, video: "video1"),
        ShortDataModel(user: UserDataModel(username: "Bulbasaur", avatar: "bulbasaur"), title: "Big Buck Bunny", likes: 3323, isLiked: true, video: "video2"),
        ShortDataModel(user: UserDataModel(username: "Charmander", avatar: "charmander"), title: "Swimming Jellyfish", likes: 512, isLiked: false, video: "video3"),
        ShortDataModel(user: UserDataModel(username: "Eevee", avatar: "eevee"), title: "Sintel Story Fight", likes: 214, isLiked: false, video: "video4"),
        ShortDataModel(user: UserDataModel(username: "Magikarp", avatar: "magikarp"), title: "Big Buck Bunny", likes: 644, isLiked: false, video: "video5"),
        ShortDataModel(user: UserDataModel(username: "Squirtle", avatar: "squirtle"), title: "Swimming Jellyfish", likes: 566, isLiked: true, video: "video6")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CollectionView Delegate and Data Source
extension ShortsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shorts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortCollectionViewCell.className, for: indexPath) as? ShortCollectionViewCell else {
            fatalError()
        }
        
        cell.delegate = self
        cell.setupCell(data: shorts[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return shortsCollectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Short tapped at index row: \(indexPath.row)")
        guard let cell = shortsCollectionView.cellForItem(at: indexPath) as? ShortCollectionViewCell, let player = cell.avPlayer else { return }
        
        player.isPlaying ? player.pause() : player.play()
        playPauseImageView.image = UIImage(named: player.isPlaying ? "play" : "pause")
        
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.playPauseImageView.alpha = 1
        } completion: { completed in
            UIView.animate(withDuration: 0.8, delay: 0) {
                self.playPauseImageView.alpha = 0
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = shortsCollectionView.contentOffset
        visibleRect.size = shortsCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = shortsCollectionView.indexPathForItem(at: visiblePoint), let cell = shortsCollectionView.cellForItem(at: indexPath) as? ShortCollectionViewCell else { return }
        NotificationCenter.default.post(name: Notification.Name("pauseVideo"), object: nil)
        cell.avPlayer?.play()
    }
}

// MARK: - ShortCollectionViewCell Delegate
extension ShortsViewController: ShortCollectionViewCellDelegate {
    func likeTapped(data: ShortDataModel, index: Int) {
        shorts[index] = data
    }
}
