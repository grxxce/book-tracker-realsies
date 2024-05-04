//
//  ContentView.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showWelcome = true

    var body: some View {
        ZStack {
            Library()
                .opacity(showWelcome ? 0 : 1)
                .animation(.easeInOut(duration: 2), value: showWelcome)
            
            if showWelcome {
                WelcomePage()
                    .opacity(showWelcome ? 1 : 0)
                    .animation(.easeInOut(duration: 2), value: showWelcome)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showWelcome = false
                        }
                    }
            }
        }
    }
        
}

#Preview {
    NavigationView {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}
