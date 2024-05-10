//
//  BookData.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/3/24.
//  ------------------------
//  This is the book datastructure declaration.
//  ------------------------
import Foundation

// Define top-level response structure
struct BooksResponse: Codable {
    let items: [Book]? 
    
}

// Define the book structure
struct Book: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
}

// Define the volume information structure
struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
}

// Define image links for book covers
struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

// Define the sale information structure
struct SaleInfo: Codable {
    let country: String
    let saleability: String
    let isEbook: Bool
}


// Create testing book
extension Book {
    static var mock: Book {
        Book( id: "1",
            volumeInfo: VolumeInfo(
                title: "Sample Book Title",
                subtitle: "A Subtitle Here",
                authors: ["Author One", "Author Two"],
                publishedDate: "2024-01-01",
                description: "A detailed description of the book goes here.",
                imageLinks: ImageLinks(
                    smallThumbnail: "http://books.google.com/books/content?id=nPy-zgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
                    thumbnail: "http://books.google.com/books/content?id=nPy-zgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
                )
            ),
            saleInfo: SaleInfo(
                country: "US",
                saleability: "FOR_SALE",
                isEbook: true
            )
        )
    }
}

//



