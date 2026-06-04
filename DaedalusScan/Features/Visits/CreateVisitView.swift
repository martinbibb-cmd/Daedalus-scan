import DaedalusContracts
import SwiftUI

struct CreateVisitView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var reference = ""
    @State private var twinKind: TwinKind = .home

    let onCreate: (String, TwinKind) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Visit reference", text: $reference)
                    .textInputAutocapitalization(.characters)

                Picker("Twin", selection: $twinKind) {
                    ForEach(TwinKind.allCases) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
            }
            .navigationTitle("Create Visit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        onCreate(reference, twinKind)
                        dismiss()
                    }
                    .disabled(reference.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
