import SwiftUI

struct VisitDetailView: View {
    @ObservedObject var viewModel: VisitListViewModel
    let visitID: UUID

    @State private var isPresentingRoomAlert = false
    @State private var roomName = ""

    var body: some View {
        if let visit = viewModel.visit(id: visitID) {
            List {
                Section("Visit") {
                    LabeledContent("Reference", value: visit.reference)
                    LabeledContent("Twin", value: visit.twinKind.title)
                    LabeledContent("Created") {
                        Text(visit.createdAt.formatted(date: .abbreviated, time: .shortened))
                    }
                }

                Section("Rooms") {
                    ForEach(visit.rooms) { room in
                        NavigationLink(room.name) {
                            RoomDetailView(viewModel: viewModel, visitID: visitID, roomID: room.id)
                        }
                    }

                    Button("Add Room") {
                        roomName = ""
                        isPresentingRoomAlert = true
                    }
                }
            }
            .navigationTitle(visit.reference)
            .alert("Add Room", isPresented: $isPresentingRoomAlert) {
                TextField("Room name", text: $roomName)
                Button("Cancel", role: .cancel) {}
                Button("Add") {
                    viewModel.addRoom(to: visitID, named: roomName)
                }
            } message: {
                Text("Create a room to continue structured capture.")
            }
        } else {
            Text("Visit not found")
                .foregroundStyle(.secondary)
        }
    }
}
