//
//  HitlistApp.swift
//  Hitlist
//
//  Created by Shahwat Hasnaine on 13/3/24.
//

import SwiftUI

@main
struct HitlistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
