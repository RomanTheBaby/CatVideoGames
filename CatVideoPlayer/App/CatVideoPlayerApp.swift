//
//  CatVideoPlayerApp.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-16.
//

import SwiftUI

@main
struct CatVideoPlayerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            VideosListView()
//            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
