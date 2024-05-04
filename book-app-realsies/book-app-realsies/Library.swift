//
//  Library.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//

import SwiftUI

struct Library: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Library")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 40)
                
                Spacer()
                
                NavigationLink(destination: AddBook()) {
                    Label("Add Book", systemImage: "plus.circle.fill")
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 50))
                .foregroundStyle(.tint)
                .padding(.top, 6)
                
                
                
            }
            .padding(40)
            ScrollView {
                LazyVGrid (columns: columns, spacing: 20){
                    ForEach(1..<14) { _ in
                        BookCard(img: Book.mock.volumeInfo.imageLinks?.thumbnail ?? "")
                    }
                }
                .padding([.horizontal], 20)
            }
            Spacer()
            
        }
    }
}

#Preview {
    
    NavigationView {
        Library()
    }
}
