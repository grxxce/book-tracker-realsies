//
//  BookCard.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//  ------------------------
//  This view is the book thumbnail.
//  ------------------------

import SwiftUI

struct BookCard: View {
    let img : String
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: img)) { phase in
                if let image = phase.image {
                    image
                } else if phase.error != nil {
                    Color.red
                } else {
                    ProgressView()
                }
                
            }
            .aspectRatio(contentMode: .fit)
            .frame(width:100, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
        }
    }
}

#Preview {
    BookCard(img: Book.mock.volumeInfo.imageLinks?.thumbnail ?? "")
}
