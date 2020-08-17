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
    
    
    //MARK:- IBoutlet
    @IBOutlet weak var favoriteBtn: UIImageView!
    @IBOutlet weak var timePreviousLabel: UILabel!
    @IBOutlet weak var timeNextLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var progressViewSlider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    
    //MARK:- Properties
    var timer : Timer?
    var pause: UIBarButtonItem?
    public lazy var viewModel  = {
        return FavoriteViewModel()
    }()
    
    
    let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    var player = PlayerManger.shared.player
    var isPlaying:Bool = true
    var currentTrack:Result?
    var playList:[Result]?
    var playerDelegate:PlayerScreenDelegate?
    var currentTrackIndex:Int? {
        didSet {
            if currentTrackIndex! == playList!.count || currentTrackIndex! < 0 {
                self.dismissPopupBar(animated: true, completion: nil)
            }
            else {
                currentTrack = playList?[currentTrackIndex!]
            }
            
        }
    }
    var songTitle: String = "" {
        didSet {
            popupItem.title = songTitle
        }
    }
    var artistName: String = "" {
        didSet {
            popupItem.subtitle = artistName
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
    
    
    //MARK:- IBActions
    @IBAction func playButtonDidTapped(_ sender: Any) {
        updateUIButtonsWhenPlaying()
    }
    
    @IBAction func playPerviousDidTapped(_ sender: Any) {
        if currentTrackIndex != 0 {
            toggleChangeSong(state: .pervious)
        }
        
    }
    
    @IBAction func playNextDidTapped(_ sender: Any) {
        if currentTrackIndex! + 1 != playList?.count {
            toggleChangeSong(state: .next)
        }
        
        
    }
    
    //MARK:- lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        setupAudioSession()
        if let currentTrack = currentTrack {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupNotificationView()
            setupMediaPlayerNotificationView()
            playAudio(perviewUrl: (currentTrack.previewUrl)!, isPlaying: isPlaying)
            setupCurrentTrackOnUI(currentTrack: currentTrack)
            setupNotificationView()
            //setupMediaPlayerNotificationView()
            setupFavoritebuttonClick()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerViewController.updateSlider(_:)), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentTrack != nil {
            setupFavoriteUIBtn()
        }
        
        playerDelegate?.playerScreenWillAppear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        playerDelegate?.playerScreenDidDisappear(currentPlayingSong: currentTrack!)
    }
    
    //MARK:- init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Helper functions
    func setupFavoriteUIBtn(){
        if viewModel.checkIsTrackExist(track: currentTrack!) {
            favoriteBtn.image = UIImage(named: "fill-heart")
        }
        else {
            favoriteBtn.image = UIImage(systemName: "heart")
        }
    }
    
    func toggleChangeSong(state:ToggleChangeSongEnum){
        switch state {
        case .next:
            currentTrackIndex! += 1
        case .pervious:
            currentTrackIndex! -= 1
        }
        
        if currentTrackIndex! == playList!.count || currentTrackIndex! < 0 {
            timer?.invalidate()
                       popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
                   }
                   else {
                       currentTrack = playList![currentTrackIndex!]
                       playAudio(perviewUrl: (currentTrack?.previewUrl)!, isPlaying: isPlaying)
                       print("is playing ......... \(isPlaying)")
                       songTitle = currentTrack?.trackName  ?? "No name"
                       artistName = currentTrack?.artistName ?? "No name"
                       setupCurrentTrackOnUI(currentTrack: currentTrack!)
                       setupNotificationView()
                   }
        
        // updateUIButtonWhenChangeSong()
        
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
        updateUIButtonsWhenPlaying()
    }
    
    
    func updateUIButtonsWhenPlaying() {
        if isPlaying {
            pause?.image = LNSystemImage(named: "play.fill")
            playBtn.setImage(UIImage(named: "playing")!, for: .normal)
            //            player.pause()
            stopAudio()
            isPlaying = false
        }
        else {
            player.play()
            pause?.image = LNSystemImage(named: "pause.fill")
            playBtn.setImage(UIImage(named: "pause")!, for: .normal)
            isPlaying = true
        }
    }
    
    
    func updateUIButtonWhenChangeSong(){
        if isPlaying {
            pause?.image = LNSystemImage(named: "play.fill")
            playBtn.setImage(UIImage(named: "playing")!, for: .normal)
        }
        else {
            pause?.image = LNSystemImage(named: "pause.fill")
            playBtn.setImage(UIImage(named: "pause")!, for: .normal)
        }
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
    
    func playAudio(perviewUrl:String , isPlaying : Bool) {
        guard let url = URL.init(string: perviewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        let duration : CMTime = (playerItem.asset.duration)
        let seconds : Float64 = CMTimeGetSeconds(duration)
        progressViewSlider.maximumValue = Float(seconds)
        progressViewSlider.isContinuous = true
        
        progressViewSlider.addTarget(self, action: #selector(PlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        player.replaceCurrentItem(with: playerItem)
        
        if isPlaying {
            player.play()
        }
        // player.play()
        
        self.isPlaying = isPlaying
        //        updateUIButtonsWhenPlaying()
        hideActivityIndicator()
        
        
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player.seek(to: targetTime)
        
        if player.rate == 0
        {
            if isPlaying {
                player.play()
            }
        }
        setupNotificationView()
    }
    
    @objc func updateSlider(_ timer: Timer) {
        let duration = (player.currentTime())
        let currentDuration : Float = Float(CMTimeGetSeconds(duration))
        
        if currentDuration == progressViewSlider.maximumValue {
            print("Next will play")
            toggleChangeSong(state: .next)
        }
        else {
            progressViewSlider.value = currentDuration
            timePreviousLabel.text = "00:\(String(Int(currentDuration)))"
            timeNextLabel.text = "00:\(String(Int(30.0 - currentDuration)))"
            popupBar.popupItem?.progress = currentDuration
            
            
        }
        
    }
    
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }
    
    func stopAudio() {
        player.pause()
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
            self.albumArt = image!
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
        //        commandCenter.nextTrackCommand.isEnabled = true
        //        commandCenter.previousTrackCommand.isEnabled = true
        //        commandCenter.playCommand.isEnabled = true
        //        commandCenter.pauseCommand.isEnabled = true
        
        //add handler for play command
        commandCenter.playCommand.addTarget { [unowned self] event  in
            
            
              self.updateUIButtonsWhenPlaying()
            self.player.play()
           // self.updateUIButtonWhenChangeSong()
          //  self.isPlaying = true
            return.success
        }
        
        // add handler for pause command
        commandCenter.pauseCommand.addTarget { [unowned self] event  in
            //(self.stopAudio())
              self.updateUIButtonsWhenPlaying()
            self.stopAudio()
            
           // self.updateUIButtonWhenChangeSong()
            //self.isPlaying = false
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
        //let duration = 30
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack?.trackName ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack?.artistName ?? ""
        
        
        
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 30
       // nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
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

//MARK:- changeSongEnum
enum ToggleChangeSongEnum {
    case next
    case pervious
}

//MARK:- PlayerScreenDelegatefdcx rs x  cxszx
protocol PlayerScreenDelegate {
    func playerScreenDidDisappear(currentPlayingSong:Result)
    func playerScreenWillAppear()
}


class PlayerManger {
    var player = AVPlayer()
    private init() {}
    static let shared = PlayerManger()
}
