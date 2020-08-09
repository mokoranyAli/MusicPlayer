//
//  ITunesTrackCollectionViewCell.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit

class ITunesTrackCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "\(ITunesTrackCollectionViewCell.self)"
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
