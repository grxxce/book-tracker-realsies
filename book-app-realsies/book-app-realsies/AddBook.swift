//
//  AddBook.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//

import SwiftUI


struct AddBook: View {
    @State private var searchText = ""
    @State private var booksResponse: BooksResponse?
    
    @State private var showPhotos = false
    @State private var photosType = "None"
    
    var body: some View {
        VStack {
            Text("Search")
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
                            photosType = "Take"
                        }
                        
                        Button("Choose Existing") {
                            photosType = "Existing"
                        }
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 30))
                    .padding(.trailing, 10)
                
            }
            .padding(.horizontal)
            
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
