//
//  VideosListView.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//

import SwiftUI


struct VideosListView: View {
    
    @State private var isShowingPlayer = false
//    private var playerData: VideoPlayerData = .empty
    @State private var playerURL: URL? = nil
    @State private var isShowingInputSheet = false

    var body: some View {
        NavigationView {
            List {
                Button("Mouse Game") {
                    playerURL = Bundle.main.url(forResource: "GAME_Catching_Mice", withExtension: "mp4")!
                }
            }
            //            .navigationTitle("Your Games")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button("Add Video From URL") {
                        isShowingInputSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $isShowingInputSheet, content: {
                VideoURLInputView() { url in
                    playerURL = url
                    //                    playerData.url = url
                }
            })
            .fullScreenCover(item: $playerURL) {
                print(">>>PLAYER: ", playerURL)
            } content: { url in
                VideoPlayerView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}


struct VidesListVide_Previews: PreviewProvider {
    static var previews: some View {
        VideosListView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
