//
//  BookListing.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/3/24.
//

import SwiftUI

struct BookListing: View {
    let book: Book
    
    var body: some View {
        HStack {
            BookCard(img: book.volumeInfo.imageLinks?.thumbnail ?? "")
            
            VStack {
                HStack {
                  Text(book.volumeInfo.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    
                    Spacer()
                }
                
                HStack {
                    Text(book.volumeInfo.authors?[0] ?? "Unknown Author")
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                HStack {
                    Text(String(book.volumeInfo.publishedDate?.prefix(4) ?? ""))
                        .font(.caption)
                    Spacer()
                }
                
            }
            .padding()
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BookListing(book: Book.mock)
}
