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
    
    //св-ва контролла
    @State private var showControls = false
    @State private var isPlaying = false
    @State private var timeoutTask: DispatchWorkItem?
    
    //св-ва слайдера
    @State private var isSeeking = false
    @State private var isFinished = false
    @State private var progress: CGFloat = 0.0
    @State private var lastProgress: CGFloat = 0.0
    @GestureState private var isDragging = false
    
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
                        .overlay(alignment: .bottom) {
                            //Добавляется seeker
                            createSliderView(size: playerSize)
                        }
                }
            }
            .frame(width: playerSize.width, height: playerSize.height)
            .onAppear {
                playerObserver()
            }
            
        }
    }
    
    ///Наблюдатель за проигрыванием плеера
    fileprivate func playerObserver() {
        //получаем текущий прогресс видео из плеера
        player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1),
                                        queue: .main, using: { time in
            if let currentVideo = player?.currentItem {
                let totalDuration = currentVideo.duration.seconds
                guard let currentDuration = player?.currentTime().seconds else {return}
                
                let currentProgress = currentDuration / totalDuration
                
                if !isSeeking {
                    progress = currentProgress
                    lastProgress = progress
                }
                if currentProgress == 1 {
                    isFinished = true
                    isPlaying = false
                }
            }
        })
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
            }).disabled(true)
                .opacity(0.6)
            
            Button(action: {
                if isFinished {
                    isFinished = false
                    player?.seek(to: .zero)
                    progress = .zero
                    lastProgress = .zero
                }
                
                switch isPlaying {
                case true:
                    player?.pause()
                    if let timeoutTask {
                        timeoutTask.cancel() //отменяем чтобы не скрывались контролы
                    }
                case false:
                    player?.play()
                    hideControls()
                }
                isPlaying.toggle()
            }, label: {
                Image(systemName: isFinished ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
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
            }).disabled(true)
                .opacity(0.6)
        })
    }
    
    @ViewBuilder private func createSliderView(size videoPlayer: CGSize) -> some View {
        ZStack(alignment: .leading) {
            //GRAY
            Rectangle()
                .fill(.gray)
            //RED
            Rectangle()
                .fill(.red)
                .frame(width: size.width * progress) //ширина относительно значения прогресса
        }
        .frame(height: 3)
        .overlay(alignment: .leading) {
            //Point seeker
            Circle()
                .fill(.red)
                .frame(width: 16, height: 16)
                .scaleEffect(showControls || isDragging ? 1 : 0)
                .frame(width: 50, height: 50)
                .contentShape(Rectangle())
                .offset(x: videoPlayer.width * progress - 25)
                .gesture(
                    DragGesture()
                    //Обработчики состояний
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged { value in
                            if let timeoutTask { timeoutTask.cancel() } //отмена hide контроллов
                            //Вычисление прогресса
                            let progressSwipe = value.translation.width //определяет сдвиг
                            let newProgress = progressSwipe / videoPlayer.width + lastProgress
                            self.progress = newProgress
                            
                            isSeeking = true
                        }
                        .onEnded { value in
                            lastProgress = progress
                            //перемотка видео к времени слайдера
                            if let currentVideo = player?.currentItem {
                                let totalDuration = currentVideo.duration.seconds
                                player?.seek(to: CMTime(seconds: totalDuration * progress, preferredTimescale: 1))
                            }
                            if isPlaying {
                                hideControls()
                            }
                            //Восстанавливаем состояние наблюдателя
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isSeeking = false
                            }
                        }
                )
        }
    }
    
    func hideControls() {
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = DispatchWorkItem(block: {
            withAnimation {
                showControls = false
            }
        })
        
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: timeoutTask)
        }
    }
}

#Preview {
    ContentView()
}
