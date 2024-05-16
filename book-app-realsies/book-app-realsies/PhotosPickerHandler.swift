//
//  PhotosPickerHandler.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//  ------------------------
//  This is the Photo Picker class that displays the photo picker.
//  ------------------------

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
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
