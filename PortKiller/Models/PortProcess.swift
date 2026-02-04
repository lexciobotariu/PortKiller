import Foundation

struct PortProcess: Identifiable, Equatable {
    let id = UUID()
    let port: Int
    let pid: Int
    let processName: String

    static func == (lhs: PortProcess, rhs: PortProcess) -> Bool {
        lhs.port == rhs.port && lhs.pid == rhs.pid && lhs.processName == rhs.processName
    }
}
