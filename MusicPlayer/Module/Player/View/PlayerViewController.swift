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
    
    
    
    @IBOutlet weak var favoriteBtn: UIImageView!
    @IBOutlet weak var timePreviousLabel: UILabel!
    @IBOutlet weak var timeNextLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var progressViewSlider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    var timer : Timer?
    
    var pause: UIBarButtonItem?
    public lazy var viewModel  = {
        return FavoriteViewModel()
    }()
    
    
    let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    // var timer : Timer?
    var player : AVPlayer?
    
    var isPlaying:Bool = false
    var currentTrack:Result?
    
    var playList:[Result]?
    var currentTrackIndex:Int? {
        didSet {
            currentTrack = playList?[currentTrackIndex!]
        }
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
    
    @IBAction func playButtonDidTapped(_ sender: Any) {
        if isPlaying {
            
            playBtn.setImage(UIImage(named: "pause")!, for: .normal)
            player?.pause()
            isPlaying = false
        }
        else {
            player?.play()
            playBtn.setImage(UIImage(named: "playing")!, for: .normal)
            isPlaying = true
        }
    }
    
    @IBAction func playPerviousDidTapped(_ sender: Any) {
        toggleChangeSong(state: .pervious)
    }
    
    @IBAction func playNextDidTapped(_ sender: Any) {
        toggleChangeSong(state: .next)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        setupAudioSession()
        if let currentTrack = currentTrack {
            playAudio(perviewUrl: (currentTrack.previewUrl)!)
            setupCurrentTrackOnUI(currentTrack: currentTrack)
            setupNotificationView()
            setupMediaPlayerNotificationView()
            setupFavoritebuttonClick()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerViewController.updateSlider(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func setupFavoriteUIBtn(){
        if viewModel.checkIsTrackExist(track: currentTrack!) {
            print("MWGOOOOOOOD")
            favoriteBtn.image = UIImage(named: "fill-heart")
        }
        else {
            print("Msh mwgoood")
            favoriteBtn.image = UIImage(systemName: "heart")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentTrack = currentTrack {
            setupFavoriteUIBtn()
        }
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
    
    
    func setupFavoritebuttonClick(){
        let starButtnTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteBtnDidTapped(tapGestureRecognizer:)))
        favoriteBtn.isUserInteractionEnabled = true
        favoriteBtn.addGestureRecognizer(starButtnTapGestureRecognizer)
    }
    
    @objc func favoriteBtnDidTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        viewModel.toggleTrackFromFavourite(trackObject: currentTrack!)
        setupFavoriteUIBtn()
        
        
        
    }
    
    
    
    
    func playAudio(perviewUrl:String) {
        guard let url = URL.init(string: perviewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        let duration : CMTime = (playerItem.asset.duration)
        let seconds : Float64 = CMTimeGetSeconds(duration)
        progressViewSlider.maximumValue = Float(seconds)
        progressViewSlider.isContinuous = true
        
        progressViewSlider.addTarget(self, action: #selector(PlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        player?.play()
        isPlaying = true
        hideActivityIndicator()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupNotificationView()
        setupMediaPlayerNotificationView()
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    @objc func updateSlider(_ timer: Timer) {
        let duration = (player?.currentTime())!
        let seconds : Float = Float(CMTimeGetSeconds(duration))
        
        if seconds == progressViewSlider.maximumValue {
            toggleChangeSong(state: .next)
        }
        else {
            progressViewSlider.value = seconds
            timePreviousLabel.text = "00:\(String(Int(seconds)))"
            timeNextLabel.text = "00:\(String(Int(30.0 - seconds)))"
        }
        
    }
    
    
    func setupAudioSession() {
        do {
            //            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: .allowAirPlay)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
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
        // backgroundImage.kf.setImage(with: resource,placeholder: UIImage(named: "defalut.jpg"))
        
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.backgroundImage.image = image
            self.setBluredBackground()
        })
        
        
        UIView.transition(with:self.songNameLabel,
                          duration: 3.0,
                          options: [.autoreverse,.repeat],
                          animations: {
                            
                            
                            self.songNameLabel.transform = CGAffineTransform(translationX: ((self.view.frame.size.width) ), y:0)
                            
        },
                          completion: nil)
        
    }
    
    
    
    func setupMediaPlayerNotificationView() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        //add handler for play command
        commandCenter.playCommand.addTarget { [unowned self] event  in
            self.player?.play()
            return.success
        }
        
        // add handler for pause command
        commandCenter.pauseCommand.addTarget { [unowned self] event  in
            (self.player?.pause())!
            return .success
        }
        
        //add handler for previous
        commandCenter.previousTrackCommand.addTarget { [unowned self] event   in
            self.toggleChangeSong(state: .pervious)
            return .success
        }
        
        
        // add handler for next
        commandCenter.nextTrackCommand.addTarget { [unowned self] event   in
            self.toggleChangeSong(state: .next)
            return .success
        }
    }
    
    
    
    
    func setupNotificationView() {
        let duration = 30
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "song"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "artist"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: UIImage(named: "default")!.size, requestHandler: { (size) -> UIImage in
            return UIImage(named: "default")!
        })
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    
    func setBluredBackground() {
        let inputImage = CIImage(cgImage: (self.backgroundImage.image?.cgImage)!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(10, forKey: "inputRadius")
        let blurred = filter?.outputImage
        var newImageSize: CGRect = (blurred?.extent)!
        newImageSize.origin.x += (newImageSize.size.width - (self.backgroundImage.image?.size.width)!) / 2
        newImageSize.origin.y += (newImageSize.size.height - (self.backgroundImage.image?.size.height)!) / 2
        newImageSize.size = (self.backgroundImage.image?.size)!
        
        let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
        let context: CIContext = CIContext.init(options: nil)
        let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
        let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
        self.backgroundImage.image = blurredImage
    }
    
    
    
}
enum ToggleChangeSongEnum {
    case next
    case pervious
}

