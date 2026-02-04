import Testing
@testable import PortKiller

@Suite("Integration Tests")
struct IntegrationTests {

    @Test("Full scan workflow")
    func fullWorkflow() async {
        let state = AppState()

        // Initial state
        #expect(state.processes.isEmpty)
        #expect(state.isScanning == false)

        // Run refresh (scans real ports on the system)
        await state.refresh()

        // After refresh, scanning should be complete
        #expect(state.isScanning == false)

        // Processes array should be sorted by port
        if state.processes.count > 1 {
            for i in 0..<(state.processes.count - 1) {
                #expect(state.processes[i].port <= state.processes[i + 1].port)
            }
        }

        // All ports should be in range 3000-9999
        for process in state.processes {
            #expect(process.port >= 3000 && process.port <= 9999)
        }
    }

    @Test("Scan is instant (under 2 seconds)")
    func scanIsInstant() async {
        let state = AppState()
        let start = Date()

        await state.refresh()

        let elapsed = Date().timeIntervalSince(start)
        #expect(elapsed < 2.0, "Scan took \(elapsed) seconds, expected under 2")
    }
}
