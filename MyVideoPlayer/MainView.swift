//
//  MainView.swift
//  MyVideoPlayer
//
//  Created by Алексей Колыченков on 07.12.2024.
//

import SwiftUI
import AVKit

struct MainView: View {
    @State private var player: AVPlayer? = {
        guard let filePath = Bundle.main.path(forResource: "SDE", ofType: "MP4") else { return nil }
        let url = URL(filePath: filePath)
        let player = AVPlayer(url: url)
        return player
    }()
    
    @State private var showControls = false
    @State private var isPlaying = false
    
    let size: CGSize
    let safeArea: EdgeInsets
    
    var body: some View {
        VStack(spacing: 0.0) {
            let playerSize = CGSize(width: size.width, height: size.height / 3.4)
            
            ZStack {
                if let player {
                    VideoPlayer(player: player)
                    //setting controls
                        .overlay {
                            Rectangle()
                                .fill(.black.opacity(0.4))
                                .opacity(showControls ? 1 : 0)
                                .overlay {
                                    if showControls {
                                        createControls()
                                    }
                                }
                        }
                        .onTapGesture {
                            withAnimation {
                                showControls.toggle()
                            }
                        }
                }
            }
            .frame(width: playerSize.width, height: playerSize.height)
            
        }
    }
    
    @ViewBuilder private func createControls() -> some View {
        HStack(spacing: 40, content: {
            Button(action: {
                
            }, label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        Circle().fill(.black.opacity(0.4))
                    }
            })
            
            Button(action: {
                
            }, label: {
                Image(systemName: "play.fill")
                    .font(.title)
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.white)
                    .padding(20)
                    .background {
                        Circle().fill(.black.opacity(0.4))
                    }
            })
            
            Button(action: {
                
            }, label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        Circle().fill(.black.opacity(0.4))
                    }
            })
        })
    }
}

#Preview {
    ContentView()
}
