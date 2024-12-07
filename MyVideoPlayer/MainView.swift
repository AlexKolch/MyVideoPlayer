//
//  MainView.swift
//  MyVideoPlayer
//
//  Created by Алексей Колыченков on 07.12.2024.
//

import SwiftUI
import AVKit

struct MainView: View {
    @State private var player: AVPlayer?
    
    let size: CGSize
    let safeArea: EdgeInsets
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
