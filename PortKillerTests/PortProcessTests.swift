import Foundation
import Testing
@testable import PortKiller

@Suite("PortProcess Model Tests")
struct PortProcessTests {

    @Test("PortProcess initializes with correct values")
    func initializesCorrectly() {
        let process = PortProcess(port: 3000, pid: 12345, processName: "node")

        #expect(process.port == 3000)
        #expect(process.pid == 12345)
        #expect(process.processName == "node")
    }

    @Test("PortProcess has unique IDs")
    func hasUniqueIds() {
        let process1 = PortProcess(port: 3000, pid: 12345, processName: "node")
        let process2 = PortProcess(port: 3000, pid: 12345, processName: "node")

        #expect(process1.id != process2.id)
    }

    @Test("PortProcess conforms to Identifiable")
    func conformsToIdentifiable() {
        let process = PortProcess(port: 8080, pid: 999, processName: "java")
        let _: any Identifiable = process  // Compile-time check
        #expect(process.id != UUID())
    }
}
