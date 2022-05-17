//
//  Theme.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 27.04.22.
//

import UIKit

enum Theme: Int {
    
    case Food, Smiley, Animal, Fruit
    
    var cardColor: UIColor {
        
        switch self {
            
        case .Food:
            return #colorLiteral(red: 0.6706523895, green: 0.2718360722, blue: 0, alpha: 1)
            
        case .Smiley:
            return #colorLiteral(red: 0.4817671776, green: 0.1368642449, blue: 0.6649351716, alpha: 1)
            
        case .Animal:
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            
        case .Fruit:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
    
    var emojis: [String] {
        
        switch self {
        case .Food:
            return ["🍔", "🍟", "🌭", "🥓", "🥬", "🥒", "🥑", "🍕"]
            
        case .Smiley:
            return ["😀", "🙄", "😡", "🤢", "🤡", "😱", "😍", "🤠"]
            
        case .Animal:
            return ["🦒", "🐋", "🦁", "🐬", "🐓", "🐈", "🕊", "🐙"]
            
        case .Fruit:
            return ["🍌", "🍍", "🍆", "🍠", "🍉", "🍇", "🥝", "🍒"]
        }
    }
    
}
