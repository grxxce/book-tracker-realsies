//
//  WelcomePage.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//  ------------------------
//  This is the welcome page of the app.
//  ------------------------

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            
            ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.tint)
                        
                    
                    Image(systemName: "books.vertical")
                        .font(.system(size: 70))
                        .foregroundStyle(.white)
                }
            
            Text("Welcome to Your Library")
                .font(.title)
            .fontWeight(.bold)
        }
    }
}

#Preview {
    WelcomePage()
}
