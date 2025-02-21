import SwiftUI

struct InventoryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: InventoryEntryViewModel
    let item: Item
    
    init(item: Item) {
        self.item = item
        _viewModel = StateObject(wrappedValue: InventoryEntryViewModel(item: item))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Quantity") {
                    Stepper("Quantity: \(viewModel.quantity)", value: $viewModel.quantity, in: 1...100)
                }
                
                Section("Weight") {
                    HStack {
                        TextField("Weight", value: $viewModel.weight, format: .number)
                            .keyboardType(.decimalPad)
                        
                        Text(item.weightUnit ?? "kg")
                    }
                }
                
                Section("Notes") {
                    TextField("Notes (optional)", text: $viewModel.notes)
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Inventory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.saveInventoryEntry()
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading || !viewModel.isValid)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    InventoryEntryView(item: Item(
        id: UUID(),
        name: "Test Item",
        weightUnit: "kg",
        createdAt: "",
        updatedAt: ""
    ))
} 