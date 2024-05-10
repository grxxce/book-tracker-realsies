//
//  SearchFunction.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//  ------------------------
//  This creates the search API class.
//  ------------------------

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var booksResponse: BooksResponse?

    func performSearch() {
        searchText = String(searchText).lowercased()
        
        print("Text searched:", searchText)
        
        guard let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
                    
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, response, error in
                guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(BooksResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.booksResponse = response
                }
            } catch {
                print("decoding error: ", error)
            }
        }
        task.resume()
    }
}
