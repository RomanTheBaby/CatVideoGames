//
//  VidePlayerViewController.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//

import UIKit
import SwiftUI

struct VideoPlayerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = VidePlayerViewController
    
    
    // MARK: - Private Properties
    
    private let videoURL: URL
    
    // MARK: - Init
    
    init(url: URL) {
        videoURL = url
    }
    
    
    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> VidePlayerViewController {
        return VidePlayerViewController(url: videoURL)
    }
    
    func updateUIViewController(_ uiViewController: VidePlayerViewController, context: Context) {
        
    }
    
}


// MARK: - VidePlayerViewController

final class VidePlayerViewController: UIViewController {

    
    // MARK: - Private Properties
    
    var isVideointeractionEnabled: Bool {
        !lockInteractionsButton.isSelected
    }
    
    private lazy var lockInteractionsButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let button = InteractionButton(normalImage: UIImage(systemName: "lock.open.fill", withConfiguration: imageConfiguration),
                                       selectedImage: UIImage(systemName: "lock.fill", withConfiguration: imageConfiguration))
        button.addTarget(self, action: #selector(actionLockInteractions(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var togglePlayStateButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let button = InteractionButton(normalImage: UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration),
                                       selectedImage: UIImage(systemName: "play.fill", withConfiguration: imageConfiguration))
        button.addTarget(self, action: #selector(actionTogglePlayState(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var replayVideoButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let button = InteractionButton(normalImage: UIImage(systemName: "gobackward", withConfiguration: imageConfiguration))
        button.addTarget(self, action: #selector(actionReplay(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var toggleGravityButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let button = InteractionButton(normalImage: UIImage(systemName: "square.dashed", withConfiguration: imageConfiguration))
        button.addTarget(self, action: #selector(actionToggleGravity(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let button = InteractionButton(normalImage: UIImage(systemName: "xmark", withConfiguration: imageConfiguration))
        button.addTarget(self, action: #selector(actionDismiss(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let videoPlayerView: URLVideoPlayerView
    
    
    // MARK: - Init
    
    init(url: URL) {
        videoPlayerView = URLVideoPlayerView(url: url)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupPlayerLayer()
        setupButtons()
    }
    
    private func setupPlayerLayer() {
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoPlayerView)
        
        NSLayoutConstraint.activate([
            videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupButtons() {
        let buttonHeight: CGFloat = 40

        let actionButtons = [dismissButton, toggleGravityButton, replayVideoButton, togglePlayStateButton, lockInteractionsButton]
        /// Need to add buttons in specific order, for proper animation overlap
        actionButtons.forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
        }
        
        actionButtons.enumerated().forEach { index, button in
            let isLast = index == actionButtons.count - 1
            let previousAnchor = isLast ? view.safeAreaLayoutGuide.leadingAnchor : actionButtons[index + 1].trailingAnchor
            let spacingMultiplier = isLast ? 4 : 1.5
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
                button.leadingAnchor.constraint(equalToSystemSpacingAfter: previousAnchor, multiplier: spacingMultiplier),
                button.widthAnchor.constraint(equalTo: button.heightAnchor),
                button.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        }
    }
    
    
    // MARK: - Actions Handling
    
    @objc private func actionLockInteractions(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.3) { [self] in
            [dismissButton, toggleGravityButton, replayVideoButton, togglePlayStateButton].forEach { button in
                let buttonTransform: CGAffineTransform = {
                    guard !isVideointeractionEnabled else { return .identity }
                    return CGAffineTransform(translationX: lockInteractionsButton.frame.minX - button.frame.minX, y: 0)
                }()
                
                button.isUserInteractionEnabled = !sender.isSelected
                button.alpha = sender.isSelected ? 0 : 1
                button.transform = buttonTransform
            }
        }
    }
    
    @objc private func actionTogglePlayState(_ sender: UIButton) {
        guard isVideointeractionEnabled else { return }
        
        sender.isSelected = !sender.isSelected
        videoPlayerView.togglePlay()
    }
    
    @objc private func actionReplay(_ sender: UIButton) {
        guard isVideointeractionEnabled else { return }
        togglePlayStateButton.isSelected = false
        videoPlayerView.replay()
    }
    
    @objc private func actionToggleGravity(_ sender: UIButton) {
        guard isVideointeractionEnabled else { return }
        videoPlayerView.toggleGravity()
    }
    
    @objc private func actionDismiss(_ sender: UIButton) {
        guard isVideointeractionEnabled else { return }
        dismiss(animated: true)
    }

}



// MARK: - InteractionButton

private class InteractionButton: UIButton {
    
    
    // MARK: - Private Properties
    
    private var shadowLayer: CAShapeLayer!
    
    
    // MARK: - Init
    
    init(normalImage: UIImage?, selectedImage: UIImage? = nil) {
        super.init(frame: .zero)
        
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
        
        setTitle(nil, for: .normal)
        setTitle(nil, for: .selected)
        tintColor = .black
        backgroundColor = .white
        
        layer.cornerRadius = 8
//        button.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero//CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}
