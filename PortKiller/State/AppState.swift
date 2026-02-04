import SwiftUI

@Observable
final class AppState {
    var processes: [PortProcess] = []
    var isScanning: Bool = false

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
