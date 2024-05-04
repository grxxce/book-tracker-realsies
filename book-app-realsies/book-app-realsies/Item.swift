//
//  Item.swift
//  book-app-realsies
//
//  Created by Grace Li on 5/2/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
