import SwiftUI

struct PortListView: View {
    @Bindable var state: AppState
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            if showSettings {
                settingsContent
            } else {
                mainContent
            }
        }
        .frame(width: 280)
        .task {
            await state.refresh()
        }
    }

    // MARK: - Main Content

    private var mainContent: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Port Killer")
                    .font(.headline)

                Spacer()

                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider()

            // Content
            if state.processes.isEmpty && !state.isScanning {
                emptyStateView
            } else {
                processListView
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Text("No processes found")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("on dev ports")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var processListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(state.processes) { process in
                    PortRowView(process: process) {
                        state.killProcess(process)
                    }

                    if process.id != state.processes.last?.id {
                        Divider()
                            .padding(.leading, 12)
                    }
                }
            }
        }
        .frame(maxHeight: 300)
    }

    // MARK: - Settings Content

    private var settingsContent: some View {
        SettingsContentView(onBack: { showSettings = false })
    }
}

#Preview {
    let state = AppState()
    state.processes = [
        PortProcess(port: 3000, pid: 123, processName: "node"),
        PortProcess(port: 5173, pid: 456, processName: "node"),
        PortProcess(port: 8000, pid: 789, processName: "python3"),
    ]
    return PortListView(state: state)
}
