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
        .frame(width: 340)
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

            // Search
            if !state.processes.isEmpty || state.isScanning {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.tertiary)
                    TextField("Search port or process…", text: $state.searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

                Divider()
            }

            // Content
            if state.processes.isEmpty && !state.isScanning {
                emptyStateView
            } else if state.filteredProcesses.isEmpty {
                noResultsView
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

    private var noResultsView: some View {
        Text("No matching processes")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
    }

    private var processListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(state.filteredProcesses) { process in
                    PortRowView(process: process) {
                        state.killProcess(process)
                    }

                    if process.id != state.filteredProcesses.last?.id {
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
