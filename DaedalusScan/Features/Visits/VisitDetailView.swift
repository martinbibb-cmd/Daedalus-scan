import SwiftUI

struct VisitDetailView: View {
    @ObservedObject var viewModel: VisitListViewModel
    let visitID: UUID

    @State private var isPresentingRoomAlert = false
    @State private var isPresentingSummary = false
    @State private var isPresentingShareSheet = false
    @State private var isPresentingContext = false
    @State private var isPresentingRooms = false

    @State private var shareURL: URL?
    @State private var roomName = ""

    var body: some View {
        if let visit = viewModel.visit(id: visitID) {
            SurveySectionCaptureView(
                viewModel: viewModel,
                visitID: visitID
            )
            .navigationTitle(visit.reference)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Context") { isPresentingContext = true }
                        Button("Rooms") { isPresentingRooms = true }
                        Button("Summary") { isPresentingSummary = true }
                        Button("Share / Save .daedalusscan") {
                            if let url = viewModel.makeExportTempURL(for: visitID) {
                                shareURL = url
                                isPresentingShareSheet = true
                            }
                        }
                    } label: {
                        Label("Visit Actions", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $isPresentingSummary) {
                VisitSummaryView(visit: visit)
            }
            .sheet(isPresented: $isPresentingShareSheet) {
                if let url = shareURL {
                    ActivityView(url: url)
                }
            }
            .sheet(isPresented: $isPresentingContext) {
                VisitContextSheet(viewModel: viewModel, visitID: visitID)
            }
            .sheet(isPresented: $isPresentingRooms) {
                VisitRoomsSheet(
                    viewModel: viewModel,
                    visitID: visitID,
                    onAddRoom: {
                        roomName = ""
                        isPresentingRoomAlert = true
                    }
                )
            }
            .alert("Add Room", isPresented: $isPresentingRoomAlert) {
                TextField("Room name", text: $roomName)
                Button("Cancel", role: .cancel) {}
                Button("Add") {
                    viewModel.addRoom(to: visitID, named: roomName)
                }
            } message: {
                Text("Rooms are available from the secondary Rooms menu.")
            }
        } else {
            Text("Visit not found")
                .foregroundStyle(.secondary)
        }
    }
}

private struct VisitContextSheet: View {
    @ObservedObject var viewModel: VisitListViewModel
    let visitID: UUID

    private var visit: Visit? {
        viewModel.visit(id: visitID)
    }

    var body: some View {
        NavigationStack {
            if let visit {
                List {
                    Picker(
                        "Capture mode",
                        selection: Binding(
                            get: { visit.captureMode },
                            set: { viewModel.setCaptureMode($0, for: visitID) }
                        )
                    ) {
                        ForEach(CaptureMode.allCases, id: \.self) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }

                    Picker(
                        "Current system",
                        selection: Binding(
                            get: { visit.currentSystemType },
                            set: { viewModel.setCurrentSystemType($0, for: visitID) }
                        )
                    ) {
                        ForEach(HeatingSystemType.allCases, id: \.self) { system in
                            Text(system.title).tag(system)
                        }
                    }

                    Picker(
                        "Proposed system",
                        selection: Binding(
                            get: { visit.proposedSystemType },
                            set: { viewModel.setProposedSystemType($0, for: visitID) }
                        )
                    ) {
                        ForEach(HeatingSystemType.allCases, id: \.self) { system in
                            Text(system.title).tag(system)
                        }
                    }
                }
                .navigationTitle("Context")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Visit not found", systemImage: "exclamationmark.triangle")
            }
        }
    }
}

private struct VisitRoomsSheet: View {
    @ObservedObject var viewModel: VisitListViewModel
    let visitID: UUID
    let onAddRoom: () -> Void

    private var visit: Visit? {
        viewModel.visit(id: visitID)
    }

    var body: some View {
        NavigationStack {
            if let visit {
                List {
                    if visit.rooms.isEmpty {
                        Text("No rooms captured")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(visit.rooms) { room in
                        NavigationLink(room.name) {
                            RoomDetailView(viewModel: viewModel, visitID: visitID, roomID: room.id)
                        }
                    }
                }
                .navigationTitle("Rooms")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Room") {
                            onAddRoom()
                        }
                    }
                }
            } else {
                ContentUnavailableView("Visit not found", systemImage: "exclamationmark.triangle")
            }
        }
    }
}
