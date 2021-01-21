//
//  Int+AbbreviationValue.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 21.01.2021.
//

import Foundation

extension Int {
    var abbreviationValue: String {
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [
            (1_000_000.0, 1_000, "k"),
            (Double(MAXFLOAT), 1_000_000.0, "m")
        ]
        
        if self < 1000 {
            return String(self)
        } else {
            var value = Double(self)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.decimalSeparator = ","
            formatter.maximumFractionDigits = 1
            
            for abbreviation in abbreviations {
                if value < abbreviation.threshold {
                    value = value / abbreviation.divisor
                    formatter.positiveSuffix = abbreviation.suffix
                    break
                }
            }
            
            let number = NSNumber(value: value)
            let formattedValue = formatter.string(from: number)!
            
            return formattedValue
        }
    }
}
