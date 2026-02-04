import Testing
@testable import PortKiller

@Suite("PortScanner Tests")
struct PortScannerTests {

    let scanner = PortScanner()

    @Test("executeCommand returns output for valid command")
    func executeCommandReturnsOutput() {
        let result = scanner.executeCommand("/bin/echo", arguments: ["hello"])
        #expect(result == "hello")
    }

    @Test("executeCommand returns nil for failed command")
    func executeCommandReturnsNilOnFailure() {
        let result = scanner.executeCommand("/nonexistent/path", arguments: [])
        #expect(result == nil)
    }

    @Test("executeCommand trims whitespace from output")
    func executeCommandTrimsWhitespace() {
        let result = scanner.executeCommand("/bin/echo", arguments: ["  spaced  "])
        #expect(result == "spaced")
    }

    @Test("scanAllListeningPorts returns array")
    func scanAllListeningPortsReturnsArray() {
        let result = scanner.scanAllListeningPorts()
        // Should return an array (may be empty or have entries depending on system state)
        #expect(result.count >= 0)
    }

    @Test("scanAllListeningPorts returns sorted results")
    func scanAllListeningPortsReturnsSortedResults() {
        let result = scanner.scanAllListeningPorts()
        // Verify results are sorted by port
        if result.count > 1 {
            for i in 0..<(result.count - 1) {
                #expect(result[i].port <= result[i + 1].port)
            }
        }
    }

    @Test("scanAllListeningPorts filters to port range 3000-9999")
    func scanAllListeningPortsFiltersToRange() {
        let result = scanner.scanAllListeningPorts()
        // All returned ports should be in range 3000-9999
        for process in result {
            #expect(process.port >= 3000 && process.port <= 9999)
        }
    }

    @Test("kill returns false for non-existent PID")
    func killReturnsFalseForInvalidPid() {
        let fakeProcess = PortProcess(port: 3000, pid: 999999999, processName: "fake")
        let result = scanner.kill(fakeProcess)
        #expect(result == false)
    }
}
