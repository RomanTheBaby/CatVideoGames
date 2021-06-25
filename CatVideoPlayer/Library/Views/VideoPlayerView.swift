//
//  VideoPlayerView.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//


import UIKit
import AVFoundation


final class URLVideoPlayerView: UIView {
    
    
    // MARK: - Gravity
    
    enum Gravity {
        case resizeAspect
        case resizeAspectFill
    }
    
    
    // MARK: - public Properties
    
    var isPlaying: Bool {
        player.rate > 0
    }
    
    
    // MARK: - Private Properties
    
    private let playerLayer = AVPlayerLayer()
    private let player: AVPlayer
    
    private var gravity: Gravity
    
    
    // MARK: - Init
    
    init(url: URL, gravity: Gravity = .resizeAspect) {
        self.player = AVPlayer(url: url)
        self.gravity = gravity
        
        super.init(frame: .zero)

        player.play()
        
        setupLayer(playerLayer, with: player, for: gravity)
    }
    
    init(player: AVPlayer, gravity: Gravity = .resizeAspect) {
        self.player = player
        self.gravity = gravity
        
        super.init(frame: .zero)
        
        self.player.play()
        
        setupLayer(playerLayer, with: self.player, for: gravity)
    }
    
    override init(frame: CGRect) {
        fatalError("init(coder:) is not supported")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = bounds
    }
    
    
    // MARK: - Public Methods
    
    func pause() {
        player.pause()
//        isPlaying = false
    }
    
    func play() {
        player.play()
//        isPlaying = true
    }
    
    func togglePlay() {
        isPlaying ? pause() : play()
    }
    
    func replay() {
        player.seek(to: .zero)
        play()
    }
    
    func toggleGravity() {
        switch gravity {
        case .resizeAspect:
            gravity = .resizeAspectFill
            adjust(to: gravity)
            
        case .resizeAspectFill:
            gravity = .resizeAspect
            adjust(to: gravity)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func setupLayer(_ playerLayer: AVPlayerLayer, with player: AVPlayer, for gravity: Gravity) {
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        adjust(to: gravity)
    }
    
    private func adjust(to gravity: Gravity) {
        switch gravity {
        case .resizeAspect:
            playerLayer.contentsGravity = .resize
            playerLayer.videoGravity = .resizeAspect
            
        case .resizeAspectFill:
            playerLayer.contentsGravity = .resizeAspectFill
            playerLayer.videoGravity = .resizeAspectFill
            
        }
    }
}
