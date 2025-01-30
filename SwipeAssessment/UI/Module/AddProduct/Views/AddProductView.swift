//
//  AddProductView.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//


import SwiftUI

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @Binding var isSuccess: Bool
    @State var isSubmitButtonEnabled: Bool = false
    
    let onSuccess: (ProductListingResponse) -> Void

    var body: some View {
        
        ZStack {
            
        VStack(spacing: 20) {
            HStack {
                Button {
                    withAnimation {
                        self.isSuccess = false
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                Text("Add Product")
                    .font(.secondary(.h20))
                Spacer()
            }
            .padding([.vertical, .horizontal], 12)
            ScrollView(showsIndicators: false) {
                
                InputTextField(title: "Product Name", placeholder: "Enter product name", text: $viewModel.productName)
                    .autocapitalization(.words)
                
                ProductTypePicker(selection: $viewModel.selectedProductType)
                
                InputTextField(title: "Selling Price", placeholder: "Enter selling price", text: $viewModel.sellingPrice, keyboardType: .decimalPad, isNumberField: true)
                
                InputTextField(title: "Tax Rate (%)", placeholder: "Enter tax rate", text: $viewModel.taxRate, keyboardType: .decimalPad, isNumberField: true)
                
                ImagePicker(selectedImageData: $viewModel.selectedImageData)
                    .padding(.vertical, 12)
                Spacer()
                
                SubmitButton(isDisabled: self.$isSubmitButtonEnabled, action: {
                    withAnimation {
                        viewModel.submitProduct()
                    }
                })
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Submission Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            
        }
        .onChange(of: viewModel.isSuccess) {
            withAnimation {
                self.isSuccess = false
                if let response = self.viewModel.addResponse {
                    self.onSuccess(response)
                }
            }
        }
            if self.viewModel.showLoader {
                
            }
        }
        .onChange(of: viewModel.productName) {
            updateSubmitButtonStatus()
        }
        .onChange(of: viewModel.selectedProductType) {
            withAnimation {
                updateSubmitButtonStatus()
            }
        }
        .onChange(of: viewModel.sellingPrice) {
            withAnimation {
                updateSubmitButtonStatus()
            }
        }
        .onChange(of: viewModel.taxRate) {
            withAnimation {
                updateSubmitButtonStatus()
            }
        }
        .onChange(of: viewModel.selectedImageData) {
            withAnimation {
                updateSubmitButtonStatus()
            }
        }
        
        .cornerRadius(6)
    }
    
    private func updateSubmitButtonStatus() { // New function
            isSubmitButtonEnabled = !viewModel.productName.isEmpty &&
                                    !viewModel.selectedProductType.isEmpty &&
                                    viewModel.isValidDecimal(viewModel.sellingPrice) &&
                                    viewModel.isValidDecimal(viewModel.taxRate)
        }
}

struct InputTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    @State private var isError: Bool = false // New state for error
    var isNumberField: Bool = false // Flag for number fields

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.primary(.c18))
            TextField(placeholder, text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isError ? Color.red : Color.gray, lineWidth: 1) // Red border on error
                )
                
                .keyboardType(keyboardType)
                .onChange(of: text) { newValue in
                    if isNumberField { // Only validate if it's a number field
                        let filtered = newValue.filter { "0123456789.".contains($0) } //Allow .
                        if filtered != newValue {
                            text = filtered
                        }
                        isError = !isValidDecimal(text) // Update error state
                    }
                }
                .background(Color.white)
                .cornerRadius(6)
                
            if isError { // Show error message
                Text("Please enter numbers only.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }

    func isValidDecimal(_ value: String) -> Bool {
        let decimalRegex = "^[0-9]*\\.?[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", decimalRegex)
        return predicate.evaluate(with: value)
    }
}

struct ProductTypePicker: View {
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Product Type")
                .font(.primary(.c18))
            Picker("Select Product Type", selection: $selection) {
                ForEach(AddProductViewModel().productTypes, id: \.self) { type in
                    Text(type)
                        .font(.primary(.c18))
                }
            }
            
            .pickerStyle(.wheel)
//            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .background(Color.white)
            .cornerRadius(6)
            .frame(height: 120)
        }
        
    }
}

struct ImagePicker: View {
    @Binding var selectedImageData: Data?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
//        HStack {
            VStack {
                Text("Product Image")
                    .font(.primary(.c18))
                
                Button {
                    withAnimation {
                        showingImagePicker = true
                    }
                } label: {
                    if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .background(Color.white)
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    SwiftUIImagePicker(image: $inputImage)
                }
            }
            
            
//        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }

        let resizedImage = inputImage.resized(to: CGSize(width: 500, height: 500)) // Resize before conversion

        guard let imageData = resizedImage.jpegData(compressionQuality: 0.9) else {  // Higher quality, check for nil
            print("Error converting resized image to JPEG data")
            selectedImageData = nil // Clear any previous bad data
            return
        }

        selectedImageData = imageData
        print("Image Data Length: \(selectedImageData?.count ?? 0) bytes") // Print data length
    }
}


struct SwiftUIImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: SwiftUIImagePicker

        init(_ parent: SwiftUIImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}



struct SubmitButton: View {
    @Binding var isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Submit Product")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(self.isDisabled ? Color.themeGreenMedium : Color.themeGreenMedium.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
                
        }
        .disabled(!isDisabled)
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self // Return original if resize fails
    }
}

#Preview {
    AddProductView(isSuccess: Binding.constant(false), isSubmitButtonEnabled: false, onSuccess: {_ in })
}
