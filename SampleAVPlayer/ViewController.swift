//
//  ViewController.swift
//  SampleAVPlayer
//
//  Created by Cahyanto Setya Budi on 27/09/20.
//  Copyright © 2020 Cahyanto Setya Budi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    private let playerVC = AVPlayerViewController()
    private var player: AVPlayer!
    private var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupAVPlayer()
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player.removeObserver(self, forKeyPath: "timeControlStatus")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            let height = self.playerVC.contentOverlayView?.bounds.size.height
            let width = self.playerVC.contentOverlayView?.bounds.size.width

            if height == UIScreen.main.bounds.height && width == UIScreen.main.bounds.width {
                self.activityIndicator.center = playerVC.contentOverlayView?.center as! CGPoint
            } else {
                self.activityIndicator.center = playerVC.view.center
            }

            if let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    DispatchQueue.main.async {[weak self] in
                        if newStatus == .playing || newStatus == .paused {
                            self?.activityIndicator.stopAnimating()
                        } else {
                            self?.activityIndicator.startAnimating()
                        }
                    }
                }
            }
        }
    }

    func setupAVPlayer() {
        let playerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let videoURL = URL(string: "https://ctv.saponlineserver.com/services/video/yt_convertor_v3.php?rule_id=109&v_id=HrxX9TBj2zY")!
        player = AVPlayer(url: videoURL)
        
        playerVC.player = player
        playerVC.view.frame = playerFrame
        
        self.addChild(playerVC)
        self.view.addSubview(playerVC.view)
//        playerVC.didMove(toParent: self)
        playerVC.player?.playImmediately(atRate: 1.0)
        playerVC.showsPlaybackControls = false
        addActivityIndicator()
    }
    
    func addActivityIndicator() {
        activityIndicator.color = .white
        activityIndicator.style = .large
        
        if playerVC.view.subviews.count != 0 {
            let activityIndicatorView = playerVC.view.subviews[0].subviews.last
            activityIndicator.center = playerVC.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            activityIndicatorView?.addSubview(activityIndicator)
            activityIndicatorView?.bringSubviewToFront(activityIndicator)
        }
    }

}

