//
//  ITunesTrackCollectionViewCell.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import Kingfisher
class ITunesTrackCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "\(ITunesTrackCollectionViewCell.self)"
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    var playButtonDelegate:playButtonClickable?
    var indexPath: IndexPath?
    
    var trackCellViewModel:TrackCellViewModel? {
        didSet {
            trackName.text = trackCellViewModel?.trackName
            trackDuration.text = trackCellViewModel?.duration
            let resource = ImageResource(downloadURL: trackCellViewModel!.imageURL)
            trackImage.kf.indicatorType = .activity
            trackImage.kf.setImage(with: resource,placeholder: UIImage(named: "defalut.jpg"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func playDidPressed(_ sender: Any) {
        playButtonDelegate?.didClickedOnSourceLabel(at: self)
    }
}

protocol playButtonClickable {
    func didClickedOnSourceLabel(at cell:ITunesTrackCollectionViewCell)
}
