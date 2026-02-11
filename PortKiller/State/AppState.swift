import SwiftUI

@Observable
final class AppState {
    var processes: [PortProcess] = []
    var isScanning: Bool = false
    var searchText: String = ""

    var filteredProcesses: [PortProcess] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return processes }
        return processes.filter { process in
            String(process.port).contains(query)
            || process.processName.localizedCaseInsensitiveContains(query)
        }
    }

    private let scanner = PortScanner()

    @MainActor
    func refresh() async {
        isScanning = true

        // Single command to get all listening ports (instant)
        processes = scanner.scanAllListeningPorts()

        isScanning = false
    }

    func killProcess(_ process: PortProcess) {
        let success = scanner.kill(process)
        if success {
            processes.removeAll { $0.pid == process.pid }
        }
    }
}
