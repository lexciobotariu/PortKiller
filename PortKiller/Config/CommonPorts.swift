import Foundation

enum CommonPorts {
    /// Commonly used development ports - scanned first for instant results
    static let list: [Int] = [
        // Frontend dev servers
        3000, 3001, 3002, 3003,     // React, Next.js, Create React App
        4000, 4200, 4321,           // Various frameworks, Angular, Astro
        5173, 5174, 5175,           // Vite
        5000, 5001,                 // Flask, various

        // Backend
        8000, 8001, 8080, 8081,     // Django, Spring, common HTTP
        8888,                       // Jupyter
        9000, 9001,                 // PHP, SonarQube

        // Databases & services
        5432,                       // PostgreSQL
        3306,                       // MySQL
        6379,                       // Redis
        27017,                      // MongoDB

        // Other common
        4040,                       // Spark UI
        6006,                       // TensorBoard
        8443,                       // HTTPS alt
        9090,                       // Prometheus
    ]

    /// Full range for background scanning (excluding common ports)
    static let backgroundRange: ClosedRange<Int> = 3000...9999

    /// Ports to skip in background scan (already covered by common list)
    static var backgroundPorts: [Int] {
        Array(backgroundRange).filter { !list.contains($0) }
    }
}
