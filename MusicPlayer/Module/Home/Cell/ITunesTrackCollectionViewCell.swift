//
//  ITunesTrackCollectionViewCell.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import Kingfisher


//MARK:- delegates
// delegate for add and remove from database
protocol TrackRealmDelegate {
    func toggleFavotire(cell:ITunesTrackCollectionViewCell)
}
protocol PlayButtonClickable {
    func didClickedOnPlayButton(at cell:ITunesTrackCollectionViewCell)
}

protocol SharButtonClickable {
    func didClickOnShareButton(at cell:ITunesTrackCollectionViewCell)
}

class ITunesTrackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shareButton: UIImageView!
    static let cellID = "\(ITunesTrackCollectionViewCell.self)"
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    //MARK: - variables
    var favoriteDelegate:TrackRealmDelegate?
    var playButtonDelegate:PlayButtonClickable?
    var shareButtonDelegate:SharButtonClickable?
    var indexPath: IndexPath?
    
    
    let starImage = UIImage(named: "heart.png")
    let starFillImage = UIImage(named: "fill-heart.png")
    var trackCellViewModel:TrackCellViewModel? {
        didSet {
            trackName.text = trackCellViewModel?.trackName
            trackDuration.text = trackCellViewModel?.duration
            let resource = ImageResource(downloadURL: trackCellViewModel!.imageURL)
            trackImage.kf.indicatorType = .activity
            trackImage.kf.setImage(with: resource,placeholder: UIImage(named: "defalut.jpg"))
            favoriteButton.image = trackCellViewModel?.isFavorite ?? false ? starFillImage : starImage
        }
    }
    
    //MARK:- lifcycel
    override func awakeFromNib() {
        setupFavoritebuttonClick()
        setupSharebuttonClick()
    }
    
    //MARK:- functions
    func setupFavoritebuttonClick(){
           let starButtnTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteBtnDidTapped(tapGestureRecognizer:)))
           favoriteButton.isUserInteractionEnabled = true
           favoriteButton.addGestureRecognizer(starButtnTapGestureRecognizer)
       }
    func setupSharebuttonClick(){
              let starButtnTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareBtnDidTapped(tapGestureRecognizer:)))
              shareButton.isUserInteractionEnabled = true
              shareButton.addGestureRecognizer(starButtnTapGestureRecognizer)
          }
    
    @IBAction func playDidPressed(_ sender: Any) {
        playButtonDelegate?.didClickedOnPlayButton(at: self)
    }
    
    @objc func favoriteBtnDidTapped(tapGestureRecognizer: UITapGestureRecognizer){
        print("favoriteBtnDidTapped Cell")
        favoriteDelegate?.toggleFavotire(cell: self)
    }
    
    @objc func shareBtnDidTapped(tapGestureRecognizer: UITapGestureRecognizer){
        print("shareBtnDidTapped Cell")
        shareButtonDelegate?.didClickOnShareButton(at: self)
    }
}


