import SwiftUI
import ServiceManagement

/// Inline settings content for use within the popover
struct SettingsContentView: View {
    let onBack: () -> Void
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(spacing: 0) {
            // Header with back button
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)

                Text("Settings")
                    .font(.headline)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider()

            // Launch at login - using button instead of Toggle for better MenuBarExtra compatibility
            Button {
                toggleLaunchAtLogin()
            } label: {
                HStack {
                    Text("Launch at login")
                    Spacer()
                    Image(systemName: launchAtLogin ? "checkmark.square.fill" : "square")
                        .foregroundStyle(launchAtLogin ? .blue : .secondary)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)

            Divider()

            // Quit button
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                HStack {
                    Text("Quit Port Killer")
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.red)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
    }

    private func toggleLaunchAtLogin() {
        let newValue = !launchAtLogin
        do {
            if newValue {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            launchAtLogin = newValue
        } catch {
            print("Failed to set launch at login: \(error)")
        }
    }
}

#Preview {
    SettingsContentView(onBack: {})
        .frame(width: 280)
}
