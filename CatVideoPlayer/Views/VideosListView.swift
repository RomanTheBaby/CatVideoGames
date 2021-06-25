//
//  VideosListView.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//

import SwiftUI


struct VideosListView: View {
    
    @State private var isShowingPlayer = false

    var body: some View {
        NavigationView {
            List {
                Button("Mouse Game") {
                    isShowingPlayer.toggle()
                }
                .sheet(isPresented: $isShowingPlayer, content: {
                    VideoPlayerView(url: Bundle.main.url(forResource: "GAME_Catching_Mice", withExtension: "mp4")!)
                        .ignoresSafeArea()
                })
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("First") {
                        print("Pressed")
                    }
                    
                    Spacer()
                    
                    Button("Second") {
                        print("Pressed")
                    }
                }
            }
        }
        
    }
}
