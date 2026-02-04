import Testing
@testable import PortKiller

@Suite("AppState Tests")
struct AppStateTests {

    @Test("AppState initializes with empty processes")
    func initializesEmpty() {
        let state = AppState()
        #expect(state.processes.isEmpty)
        #expect(state.isScanning == false)
    }

    @Test("AppState can add processes")
    func canAddProcesses() {
        let state = AppState()
        let process = PortProcess(port: 3000, pid: 123, processName: "node")
        state.processes.append(process)
        #expect(state.processes.count == 1)
    }
}
