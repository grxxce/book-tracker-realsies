//
//  AddBook.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//  ------------------------
//  This is the parent page for searching for a book. It contains the following compontents:
//  1) Search bar - BookSearch()
//  2) Camera icon
//  3) Search by image - BookPhoto()
//  4) Book listing - BookListing()
//  ------------------------

import SwiftUI

struct AddBook: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var showPhotos = false
    @State private var showPhotosPicker = false
    
    
    @State private var showView = false
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        VStack {
            Text("Add a Book")
                .font(.title)
                .fontWeight(.bold)
            
            VStack {
                HStack {
                    //                SEARCH BAR
                    BookSearch(searchViewModel: searchViewModel)
                    
                    
                    
                    //                CAMERA ICON
                    Button("pick", systemImage: "camera.fill") {
                        showPhotos = true
                    }
                    .confirmationDialog("Options", isPresented: $showPhotos, titleVisibility: .hidden) {
                        Button("Take Photo") {
                            // TODO: implement take photo
                            model.startCamera()
                            showView = true
                            
                            
                        }
                        Button("Choose Existing") {
                            showPhotosPicker = true
                        }
                        
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 30))
                    .padding(.trailing, 10)
                    .photosPicker(isPresented: $showPhotosPicker,  selection: $viewModel.imageSelection, matching: .images)
                    
                    NavigationLink(destination: FrameView(model: model), isActive: $showView) { EmptyView() }

                }
                
                //                SEARCHING BY IMAGE
                if let image = viewModel.selectedImage {
                    BookPhoto(bookPhoto: image, searchViewModel: searchViewModel)
                }
                
                
//                if showView {
//                    VStack{
//                        FrameView(image: model.frame)
//                    }
//                }
                
                //                BOOK LISTING
                ScrollView {
                    VStack {
                        ForEach(BookSearch(searchViewModel: searchViewModel).searchViewModel.booksResponse?.items ?? [Book.mock]) {book in
                            BookListing(book: book)
                        }
                    }
                }
                .padding(.horizontal)
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
