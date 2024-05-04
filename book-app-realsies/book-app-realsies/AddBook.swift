//
//  AddBook.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else {return}
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
}


struct AddBook: View {
    @State private var searchText = ""
    @State private var booksResponse: BooksResponse?
    
    @State private var showPhotos = false
    
    @State private var showPhotosPicker = false
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    var body: some View {
        VStack {
            Text("Add a Book")
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                TextField("Search books...",text: $searchText, onCommit:performSearch )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                Button("pick", systemImage: "camera.fill") {
                    showPhotos = true
                }
                    .confirmationDialog("Options", isPresented: $showPhotos, titleVisibility: .hidden) {
                        Button("Take Photo") {
                            // implement take photo
                        }
                        
                        Button("Choose Existing") {
                            showPhotosPicker = true
                        }
                        
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 30))
                    .padding(.trailing, 10)
                
            }
            .padding(.horizontal)
            .photosPicker(isPresented: $showPhotosPicker,  selection: $viewModel.imageSelection, matching: .images)
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            
            ScrollView {
                VStack {
                    ForEach(booksResponse?.items ?? [Book.mock]) {book in
                        BookListing(book: book)
                    }
                }
            }
            
            
            Spacer()
        }
        .padding([.top])
        
    }
    
    func performSearch() {
        print("Searching: \(searchText)")
        
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q={\(searchText)}") else { return }
        print("url is: \(url)")
            
        let task = URLSession.shared.dataTask(with: url) { 
            data, response, error in
                guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                booksResponse = try decoder.decode(BooksResponse.self, from: data)
                DispatchQueue.main.async {
                    
                }
            } catch {
                print("decoding error")
            }
        }
        task.resume()
    }
}

#Preview {
    NavigationView {
        AddBook()
    }
    
}
