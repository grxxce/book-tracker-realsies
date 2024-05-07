//
//  BookSearch.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//

import SwiftUI


struct BookSearch: View {
    @State private var searchText = ""
    @ObservedObject var searchViewModel: SearchViewModel
   
    var body: some View {
        
        VStack {
            
            TextField("Search books...",text: $searchText, onCommit:{
                self.searchViewModel.searchText = searchText
                self.searchViewModel.performSearch()
            } )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
    }
}

//#Preview {
//    BookSearch()
//}
