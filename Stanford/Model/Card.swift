//
//  Card.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 26.04.22.
//

import Foundation

struct Card {
    
    private let identifier: Int
    
    var isMatched = false
    var isFaceUp = false
    var hasBeenFlipped = false
    
    init() {
        
        identifier = Card.makeIdentifier()
    }
    
    mutating func flipCard() {
        isFaceUp = !isFaceUp
    }
    
    mutating func setFaceDown() {
        if isFaceUp {
            isFaceUp = false
        }
    }
    
    private static var identifiersCount = -1
    
    static func resetIdentifiersCount() {
        identifiersCount = -1
    }
    
    static func makeIdentifier() -> Int {
        identifiersCount += 1
        return identifiersCount
    }
    
}

extension Card: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
