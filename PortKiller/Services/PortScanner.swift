import Foundation

final class PortScanner {

    /// Port range to include in results
    private let portRange: ClosedRange<Int> = 3000...9999

    /// Scan all listening TCP ports in one command (instant)
    func scanAllListeningPorts() -> [PortProcess] {
        // lsof -iTCP -sTCP:LISTEN -P -n
        // -iTCP: only TCP connections
        // -sTCP:LISTEN: only listening sockets
        // -P: show port numbers (not service names)
        // -n: no DNS resolution (faster)
        guard let output = executeCommand("/usr/sbin/lsof", arguments: ["+c0", "-iTCP", "-sTCP:LISTEN", "-P", "-n"]),
              !output.isEmpty else {
            return []
        }

        var processes: [PortProcess] = []
        let lines = output.components(separatedBy: "\n")

        // Skip header line, parse each subsequent line
        for line in lines.dropFirst() {
            guard let process = parseLsofLine(line) else { continue }

            // Filter to our port range
            if portRange.contains(process.port) {
                processes.append(process)
            }
        }

        // Sort by port and remove duplicates (same port can appear multiple times for IPv4/IPv6)
        let uniqueProcesses = Dictionary(grouping: processes, by: { $0.port })
            .compactMapValues { $0.first }
            .values
            .sorted { $0.port < $1.port }

        return Array(uniqueProcesses)
    }

    /// Parse a single line of lsof output
    /// Example: "node      12345 user   23u  IPv6 0x...      0t0  TCP *:3000 (LISTEN)"
    private func parseLsofLine(_ line: String) -> PortProcess? {
        let components = line.split(separator: " ", omittingEmptySubsequences: true)

        // Need at least: COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME
        guard components.count >= 9 else { return nil }

        let processName = String(components[0])

        guard let pid = Int(components[1]) else { return nil }

        // Find the component containing address:port (e.g., "*:3000", "127.0.0.1:8000", "[::1]:3000")
        // It's the one that contains ":" and is NOT "(LISTEN)"
        guard let addressPort = components.first(where: {
            $0.contains(":") && !$0.contains("LISTEN") && !$0.hasPrefix("0x")
        }) else { return nil }

        guard let port = extractPort(from: String(addressPort)) else { return nil }

        return PortProcess(port: port, pid: pid, processName: processName)
    }

    /// Extract port number from lsof NAME field
    private func extractPort(from name: String) -> Int? {
        // Remove " (LISTEN)" suffix if present
        let cleaned = name.replacingOccurrences(of: " (LISTEN)", with: "")

        // Find the last colon (handles IPv6 like [::1]:3000)
        guard let lastColonIndex = cleaned.lastIndex(of: ":") else { return nil }

        let portString = String(cleaned[cleaned.index(after: lastColonIndex)...])
        return Int(portString)
    }

    /// Kill a process by PID (SIGKILL)
    func kill(_ process: PortProcess) -> Bool {
        let result = executeCommand("/bin/kill", arguments: ["-9", "\(process.pid)"])
        return result != nil
    }

    /// Execute a shell command and return trimmed stdout
    func executeCommand(_ path: String, arguments: [String]) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()

            guard process.terminationStatus == 0 else {
                return nil
            }

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            return nil
        }
    }
}
