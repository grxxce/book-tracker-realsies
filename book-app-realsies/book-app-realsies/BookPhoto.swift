//
//  BookPhoto.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/4/24.
//

// THIS VIEW HANDLES THE ML TO READ THE TEXT IN AN IMAGE

import SwiftUI
import Vision

struct BookPhoto: View {
    let bookPhoto: UIImage
    
    @State var recognizedTitle = ""
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        
        VStack {
            Text("Searching: " + recognizedTitle)
                .font(.footnote)
            }
        .onAppear{
            read(bookPhoto: UIImage(imageLiteralResourceName: "theanthreviewed")) { recognizedText in
                DispatchQueue.main.async {
                    if let title = recognizedText {
                        self.recognizedTitle = title
                        self.searchViewModel.searchText = title
                        self.searchViewModel.performSearch()
                    }
                }
            }
        }
    }
            
    func read(bookPhoto: UIImage, completion: @escaping (String?) -> Void) {
        
        if let cgImage = bookPhoto.cgImage {
            
            // Request handler
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                
                // Parse the results as text
                guard let result = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                // Determine the largest text block (likely the title)
                let areas = result.map { observation -> (text: String?, area: CGFloat) in
                    let area = observation.boundingBox.width * observation.boundingBox.height
                    let text = observation.topCandidates(1).first?.string
                    return (text, area)
                }
                
                guard let largestArea = areas.max(by: { $0.area < $1.area })?.area else { return }
                let threshold = largestArea * 0.6
                
                // Filter and collect texts that are within the threshold of the largest text's area
                let relevantTexts = areas.filter { $0.area >= threshold }.compactMap { $0.text }
                
                if relevantTexts != [] {
                    completion(relevantTexts.joined(separator: " "))
                } else {
                    completion(nil)
                }
            }
            
            // Process the request
            recognizeRequest.usesLanguageCorrection = true
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
        }
    }
}
