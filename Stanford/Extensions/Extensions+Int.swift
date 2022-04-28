//
//  Extensions+Int.swift
//  Stanford
//
//  Created by Beqa Tabunidze on 27.04.22.
//

import Foundation

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}
