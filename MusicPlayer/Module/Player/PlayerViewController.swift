//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/12/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit

import LNPopupController
import MediaPlayer
import Kingfisher

class PlayerViewController: UIViewController {
    
    var pause: UIBarButtonItem?
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playBtn: UIButton!
    @IBAction func playButtonDidTapped(_ sender: Any) {
        
        if isPlaying {
            playBtn.setTitle("||", for: .normal)
            player?.pause()
            isPlaying = false
        }
        else {
            player?.play()
            playBtn.setTitle("play", for: .normal)
            isPlaying = true
        }
    }
    
    @IBAction func playPerviousDidTapped(_ sender: Any) {
        
        toggleChangeSong(state: .pervious)
    }
    
    @IBAction func playNextDidTapped(_ sender: Any) {
        toggleChangeSong(state: .next)
    }
    
    func toggleChangeSong(state:ToggleChangeSongEnum){
        switch state {
        
        case .next:
            currentTrackIndex! += 1
        case .pervious:
            currentTrackIndex! += -1
        }
        
        currentTrack = playList![currentTrackIndex!]
        playAudio(perviewUrl: (currentTrack?.previewUrl)!)
        setupCurrentTrackOnUI(currentTrack: currentTrack!)
    }
    
    
    let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    var timer : Timer?
    var player : AVPlayer?
    
    var isPlaying:Bool = false
    var currentTrack:Result?
    
    var playList:[Result]?
    var currentTrackIndex:Int? {
        didSet {
            currentTrack = playList?[currentTrackIndex!]
        }
    }
    
    fileprivate func LNSystemImage(named: String) -> UIImage {
        if #available(iOS 13.0, *) {
            let config : UIImage.SymbolConfiguration
            if UserDefaults.standard.object(forKey: "PopupSettingsBarStyle") as? LNPopupBarStyle == LNPopupBarStyle.compact {
                config = UIImage.SymbolConfiguration(scale: .unspecified)
            } else {
                config = UIImage.SymbolConfiguration(scale: .medium)
            }
            
            return UIImage(systemName: named, withConfiguration: config)!
        } else {
            return UIImage(named: "gears")!
        }
    }
    
    func configure() {
        
         pause = UIBarButtonItem(image: LNSystemImage(named: "pause.fill"), style: .plain, target: self, action: #selector(pauseBtnDidTapped(tapGestureRecognizer:)))
        
        pause?.accessibilityLabel = NSLocalizedString("Pause", comment: "")
        let next = UIBarButtonItem(image: LNSystemImage(named: "forward.fill"), style: .plain, target: self, action: nil)
        next.accessibilityLabel = NSLocalizedString("Next Track", comment: "")
        
        if UserDefaults.standard.object(forKey: "PopupSettingsBarStyle") as? LNPopupBarStyle == LNPopupBarStyle.compact {
            popupItem.leadingBarButtonItems = [ pause! ]
            popupItem.trailingBarButtonItems = [ next ]
        } else {
            popupItem.barButtonItems = [ pause!, /*next*/ ]
        }
        
        accessibilityDateComponentsFormatter.unitsStyle = .spellOut
    }
    @objc func pauseBtnDidTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if isPlaying {
            pause?.image = LNSystemImage(named: "forward.fill")
            player?.pause()
            isPlaying = false
        }
        else {
            player?.play()
            pause?.image = LNSystemImage(named: "pause.fill")
            isPlaying = true
        }
       
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var songTitle: String = "" {
        didSet {
            if isViewLoaded {
                print("songNameLabel.text = songTitle")
                songNameLabel.text = "aaa"
            }
            
            popupItem.title = songTitle
        }
    }
    var albumTitle: String = "" {
        didSet {
            if isViewLoaded {
                print("albumNameLabel.text = albumTitle")
            }
            #if !targetEnvironment(macCatalyst)
            if ProcessInfo.processInfo.operatingSystemVersion.majorVersion <= 9 {
                popupItem.subtitle = albumTitle
            }
            #endif
        }
    }
    var albumArt: UIImage = UIImage() {
        didSet {
            if isViewLoaded {
                print("albumArtImageView.image = albumArt")
            }
            popupItem.image = albumArt
            popupItem.accessibilityImageLabel = NSLocalizedString("Album Art", comment: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if #available(iOS 13.0, *) {
            //                albumArtImageView.layer.cornerCurve = .continuous
        }
        //            albumArtImageView.layer.cornerRadius = 16
        showActivityIndicator()
        playAudio(perviewUrl: (currentTrack?.previewUrl)!)
        if let currentTrack = currentTrack {
            setupCurrentTrackOnUI(currentTrack: currentTrack)
        }
        
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerViewController._timerTicked(_:)), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerViewController._timerTicked(_:)), userInfo: nil, repeats: true)
    }
    
    
    func playAudio(perviewUrl:String) {
        
        
        guard let url = URL.init(string: perviewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
        isPlaying = true
        hideActivityIndicator()
    }
    
    
    func stopAudio() {
        player?.pause()
    }
    
    func setupCurrentTrackOnUI(currentTrack:Result) {
        songNameLabel.text = currentTrack.trackName
        artistNameLabel.text = currentTrack.artistName
        guard  let imageUrl = URL(string: currentTrack.artworkUrl100 ?? "") else {
            return
        }
        let resource = ImageResource(downloadURL: imageUrl)
        playerImageView.kf.indicatorType = .activity
        playerImageView.kf.setImage(with: resource,placeholder: UIImage(named: "defalut.jpg"))
    }
    
    
    @objc func _timerTicked(_ timer: Timer) {
        popupItem.progress += 0.0010;
        popupItem.accessibilityProgressLabel = NSLocalizedString("Playback Progress", comment: "")
        
        let totalTime = TimeInterval(3000)
        popupItem.accessibilityProgressValue = "\(accessibilityDateComponentsFormatter.string(from: TimeInterval(popupItem.progress) * totalTime)!) \(NSLocalizedString("of", comment: "")) \(accessibilityDateComponentsFormatter.string(from: totalTime)!)"
        
                    progressView.progress = popupItem.progress
        
        if popupItem.progress >= 1.0 {
            timer.invalidate()
//            toggleChangeSong(state: .next)
//            popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
        }
    }
}

enum ToggleChangeSongEnum {
    case next
    case pervious
}
