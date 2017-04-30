//
//  AKMaskFieldBlockCharacter.swift
//  WishMaker
//
//  Created by maxik on 30.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation

public struct MaskFieldBlockCharacter {
    
    public var index: Int
    
    public var blockIndex: Int
    
    public var status: MaskFieldStatus
    
    public var pattern: MaskFieldPatternCharacter!
    
    public var patternRange: NSRange
    
    public var template: Character!
        
    public var templateRange: NSRange
}
