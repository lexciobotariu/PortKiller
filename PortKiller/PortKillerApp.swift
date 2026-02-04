import SwiftUI

@main
struct PortKillerApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            PortListView(state: appState)
        } label: {
            Image(systemName: "network")
        }
        .menuBarExtraStyle(.window)
    }
}
