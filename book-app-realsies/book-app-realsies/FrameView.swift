//
//  FrameView.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/7/24.
//

import SwiftUI

struct FrameView: View {
    private let label = Text("frame")
    @ObservedObject var model: FrameHandler
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)  // background color
        
            if let image = model.frame {
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()  // Make sure image can resize
                    .scaledToFit()  // Ensures the image fits within the view bounds
            } else {
                Text("No Camera Feed")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            
            VStack {
                Spacer()  // Pushes everything to the bottom
                Button {
                     model.takePhoto()
                } label: {
                    Label {
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 3)
                                .background(Circle().fill(Color.black.opacity(0.5)))  // Adding a background to ensure visibility
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .padding(.bottom)  // Provides padding at the bottom
            }
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(model: FrameHandler())
    }
}
