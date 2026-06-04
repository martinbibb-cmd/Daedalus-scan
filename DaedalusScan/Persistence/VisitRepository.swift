import DaedalusContracts
import Foundation

@MainActor
final class VisitRepository {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func loadVisits() throws -> [Visit] {
        let url = try visitsFileURL()
        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode([Visit].self, from: data)
    }

    func save(visits: [Visit]) throws {
        let url = try visitsFileURL()
        let data = try encoder.encode(visits)
        try data.write(to: url, options: .atomic)
    }

    func exportPackage(visits: [Visit]) -> VisitPackage {
        VisitPackage(visits: visits)
    }

    func importPackage(from url: URL) throws -> [Visit] {
        let scoped = url.startAccessingSecurityScopedResource()
        defer {
            if scoped {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let data = try Data(contentsOf: url)
        let package = try decoder.decode(VisitPackage.self, from: data)
        try save(visits: package.visits)
        return package.visits
    }

    func makeEvidenceFileURL(fileExtension: String, visitID: UUID, roomID: UUID) throws -> URL {
        let directory = try evidenceDirectoryURL()
        let fileName = [visitID.uuidString, roomID.uuidString, UUID().uuidString]
            .joined(separator: "-") + ".\(fileExtension)"
        return directory.appendingPathComponent(fileName)
    }

    private func visitsFileURL() throws -> URL {
        try storageDirectoryURL().appendingPathComponent("visits.json")
    }

    private func evidenceDirectoryURL() throws -> URL {
        let directory = try storageDirectoryURL().appendingPathComponent("Evidence", isDirectory: true)
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }

    private func storageDirectoryURL() throws -> URL {
        let baseDirectory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let storageDirectory = baseDirectory.appendingPathComponent("DaedalusScan", isDirectory: true)
        if !fileManager.fileExists(atPath: storageDirectory.path) {
            try fileManager.createDirectory(at: storageDirectory, withIntermediateDirectories: true)
        }
        return storageDirectory
    }
}
