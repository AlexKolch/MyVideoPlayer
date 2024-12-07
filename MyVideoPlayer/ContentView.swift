//
//  ContentView.swift
//  MyVideoPlayer
//
//  Created by Алексей Колыченков on 07.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            //размеры родительской вью
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            MainView(size: size, safeArea: safeArea)
        })
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
