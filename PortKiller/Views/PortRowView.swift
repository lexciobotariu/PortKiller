import SwiftUI

struct PortRowView: View {
    let process: PortProcess
    let onKill: () -> Void

    var body: some View {
        HStack {
            Text(verbatim: ":\(process.port)")
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .frame(width: 60, alignment: .leading)

            Text(process.processName)
                .font(.system(.body))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button("Kill") {
                onKill()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    VStack(spacing: 0) {
        PortRowView(
            process: PortProcess(port: 3000, pid: 123, processName: "node"),
            onKill: {}
        )
        PortRowView(
            process: PortProcess(port: 8080, pid: 456, processName: "java"),
            onKill: {}
        )
    }
    .frame(width: 340)
}
