import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddItemViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                    TextField("Barcode", text: $viewModel.barcode)
                }
                
                Section("Packaging") {
                    TextField("Packaging Type", text: $viewModel.packaging)
                    Picker("Weight Unit", selection: $viewModel.weightUnit) {
                        ForEach(["kg", "g", "lb", "oz"], id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
                
                Section("Expiration") {
                    DatePicker(
                        "Expiration Date",
                        selection: $viewModel.expirationDate,
                        displayedComponents: .date
                    )
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Item")
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
                            await viewModel.saveItem()
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
    AddItemView()
} 