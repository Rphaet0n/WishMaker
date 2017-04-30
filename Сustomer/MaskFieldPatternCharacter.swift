//
//  MaskFieldPatternCharacter.swift
//  WishMaker
//
//  Created by maxik on 01.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

public enum MaskFieldPatternCharacter: String {
    
    case NumberDecimal = "d"
    case NonDecimal    = "D"
    case NonWord       = "W"
    case Alphabet      = "a"
    case AnyChar       = "."
    
    public func pattern() -> String {
        switch self {
        case .NumberDecimal   : return "\\d"
        case .NonDecimal      : return "\\D"
        case .NonWord         : return "\\W"
        case .Alphabet        : return "[a-zA-Z]"
        default               : return "."
        }
    }
}
