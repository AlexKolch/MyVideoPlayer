//
//  VideoPlayer.swift
//  MyVideoPlayer
//
//  Created by Алексей Колыченков on 07.12.2024.
//

import SwiftUI
import AVKit

struct VideoPlayer: UIViewControllerRepresentable {
    
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = true //настроим свои контроллы
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
