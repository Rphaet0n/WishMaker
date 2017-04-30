//
//  AKMaskFieldBlock.swift
//  WishMaker
//
//  Created by maxik on 30.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation


public struct MaskFieldBlock {
    
    
    public var index: Int
    
    public var status: MaskFieldStatus {
        
        let completedChars: [MaskFieldBlockCharacter] = chars.filter { return $0.status != .clear }
        
        switch completedChars.count {
        case 0           : return .clear
        case chars.count : return .complete
        default          : return .incomplete
        }
    }
    
    public var chars: [MaskFieldBlockCharacter]
    
    public var pattern: String {
        
        var pattern: String = ""
        for char in chars {
            pattern += char.pattern.rawValue
        }
        return pattern
    }
    
    public var patternRange: NSRange {
        return NSMakeRange(chars.first!.patternRange.location, chars.count)
    }
    
    
    public var template: String {
        var template: String = ""
        for char in chars {
            template.append(char.template)
        }
        return template
    }
    
    public var templateRange: NSRange {
        return NSMakeRange(chars.first!.templateRange.location, chars.count)
    }
    
    
}
