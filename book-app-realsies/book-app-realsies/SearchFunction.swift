//
//  SearchFunction.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var booksResponse: BooksResponse?

    func performSearch() {
        searchText = String(searchText).lowercased()
        
        print("Text searched:", searchText)
        
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q={\(searchText)}") else { return }
            
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
                guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                self.booksResponse = try decoder.decode(BooksResponse.self, from: data)
                DispatchQueue.main.async {
                    
                }
            } catch {
                print("decoding error")
            }
        }
        task.resume()
    }
}
