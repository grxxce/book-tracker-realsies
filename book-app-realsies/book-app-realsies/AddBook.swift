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
        print("picker initiated")
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
    @StateObject private var searchViewModel = SearchViewModel()
    
//    Add requirements for Photos Picker
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var showPhotos = false
    @State private var showPhotosPicker = false
    
    var body: some View {
        VStack {
            Text("Add a Book")
                .font(.title)
                .fontWeight(.bold)
            
            VStack {
                HStack {
                    //                SEARCH BAR
                    BookSearch(searchViewModel: searchViewModel)
                    
                    
                    //                CAMERA
                    Button("pick", systemImage: "camera.fill") {
                        showPhotos = true
                    }
                    .confirmationDialog("Options", isPresented: $showPhotos, titleVisibility: .hidden) {
                        Button("Take Photo") {
                            // TODO: implement take photo
                        }
                        Button("Choose Existing") {
                            showPhotosPicker = true
                        }
                        
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 30))
                    .padding(.trailing, 10)
                }
                
//                SEARCHING BY IMAGE
                if let image = viewModel.selectedImage {
                    BookPhoto(bookPhoto: image, searchViewModel: searchViewModel)
                }
                
//                BOOK LISTING
                ScrollView {
                    VStack {
                        ForEach(BookSearch(searchViewModel: searchViewModel).searchViewModel.booksResponse?.items ?? [Book.mock]) {book in
                            BookListing(book: book)
                        }
                    }
                }
                .padding(.horizontal)
                .photosPicker(isPresented: $showPhotosPicker,  selection: $viewModel.imageSelection, matching: .images)
            }
            
            Spacer()
        }
        .padding([.top])
    }
}

#Preview {
    NavigationView {
        AddBook()
    }
    
}
