//
//  File.swift
//  WishMaker
//
//  Created by maxik on 30.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit


open class  MaskField: UITextField, UITextFieldDelegate  {
    
    
    @IBInspectable open var maskExpression: String? {
        didSet {
            
            if guardMask {
                return
            }
            
            let brackets =  MaskFieldUtility.matchesInString(maskExpression!, pattern: "(?<=\\\(maskBlockBrackets.left)).*?(?=\\\(maskBlockBrackets.right))")
            
            if brackets.isEmpty {
                return
            }
            
            delegate = self
            
            maskTemplateText = maskExpression
            
            maskBlocks = [ MaskFieldBlock]()
            
            for (i, bracket) in brackets.enumerated() {
                
                // Characters
                
                var characters = [ MaskFieldBlockCharacter]()
                
                for y in 0..<bracket.range.length {
                    
                    let patternRange  = NSMakeRange(bracket.range.location + y, 1)
                    var templateRange = patternRange
                    templateRange.location -=  i * 2 + 1
                    
                    let pattern =  MaskFieldPatternCharacter(rawValue:  MaskFieldUtility.substring(maskExpression, withNSRange: patternRange))
                    
                    characters.append( MaskFieldBlockCharacter(
                        index : y,
                        blockIndex : i,
                        status : .clear,
                        pattern : pattern,
                        patternRange : patternRange,
                        template : maskTemplateDefault,
                        templateRange : templateRange))
                }
                
                maskBlocks.append( MaskFieldBlock(
                    index : i,
                    chars : characters))
                
                updateMaskTemplateTextFromBlock(i)
            }
            
            
            updateMaskTemplateText()
            
            #if  MaskFieldDEBUG
                debugmaskBlocks()
            #endif
        }
    }
    
    
    fileprivate var maskTemplateDefault: Character = "*"
    
    
    @IBInspectable open var maskTemplate: String = "*" {
        didSet {
            
            if guardMask {
                return
            }
            
            maskTemplateText = maskExpression
            
            var copy: Bool = true
            var _maskTemplate = String(maskTemplateDefault)
            
            if maskTemplate.characters.count == maskExpression!.characters.count - (maskBlocks.count * 2) {
                copy = false
                _maskTemplate = maskTemplate
            } else if maskTemplate.characters.count == 1 {
                _maskTemplate = maskTemplate
            }
            
            for block in maskBlocks {
                for char in block.chars {
                    maskBlocks[char.blockIndex].chars[char.index].template = copy
                        ? Character(_maskTemplate)
                        : Character( MaskFieldUtility.substring(maskTemplate, withNSRange: char.templateRange))
                }
                
                updateMaskTemplateTextFromBlock(block.index)
            }
            
            
            updateMaskTemplateText()
        }
    }
    
    public func setMask(_ mask: String, withMaskTemplate maskTemplate: String!) {
        maskExpression = mask
        self.maskTemplate = maskTemplate ?? String(maskTemplateDefault)
    }
    
    open var maskBlockBrackets:  MaskFieldBrackets =  MaskFieldBrackets(left: "{", right: "}")
    
    open override var text: String?  {
        didSet {
            
            guard let maskText = maskText else {
                super.text = text
                return
            }
            
            _ = textField(self, shouldChangeCharactersIn: NSMakeRange(0, maskText.characters.count), replacementString: text ?? "")
        }
    }
    
    
    open func refreshMask() {
        
        if guardMask {
            return
        }
        
        if maskStatus == .clear {
            if placeholder != nil {
                super.text = nil
            } else {
                super.text = maskTemplateText
            }
        } else {
            super.text = maskText
        }
        
        moveCarret()
    }
    
    
    open weak var maskDelegate:  MaskFieldDelegate?
    
    open var maskStatus:  MaskFieldStatus {
        
        let maskBlocksChars = maskBlocks.flatMap { $0.chars }
        let completedChars  = maskBlocksChars.filter { $0.status == .complete }
        
        switch completedChars.count {
        case 0                     : return .clear
        case maskBlocksChars.count : return .complete
        default                    : return .incomplete
        }
    }
    
    open var maskBlocks: [ MaskFieldBlock] = [ MaskFieldBlock]()
    
    open var jumpToPrevBlock: Bool = false
    
    
    fileprivate var maskText: String!
    
    fileprivate var maskTemplateText: String!
    
    open override var placeholder: String?  {
        didSet {
            refreshMask()
        }
    }
    
    
    deinit {
        #if  MaskFieldDEBUG
            print("\(type(of: self)) \(#function)")
        #endif
    }
    
    fileprivate var guardMask: Bool {
        guard let mask = maskExpression, !maskBlocks.isEmpty || !mask.isEmpty else {
            
            super.text = nil
            delegate = nil
            
            maskText = nil
            maskTemplateText = nil
            maskBlocks = []
            
            return true
        }
        return false
    }
    
    fileprivate func getNetCharacter(_ chars: [ MaskFieldBlockCharacter], fromLocation location: Int) -> (char:  MaskFieldBlockCharacter, outsideBlock: Bool) {
        
        var nextBlockIndex: Int!
        
        var lowerBound = 0
        var upperBound = chars.count
        
        while lowerBound < upperBound {
            
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            let charLocation = chars[midIndex].templateRange.location
            
            if charLocation == location {
                return (chars[midIndex], false)
            } else if charLocation < location {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
                nextBlockIndex = midIndex
            }
        }
        
        return (chars[nextBlockIndex], true)
    }
    
    
    fileprivate func matchTextCharacter(_ textCharacter: Character, withMaskCharacter maskCharacter:  MaskFieldBlockCharacter) -> Bool {
        return !MaskFieldUtility
            .matchesInString(String(textCharacter),
                             pattern: maskCharacter.pattern.pattern()).isEmpty
    }
    
    fileprivate func updateMaskTemplateText() {
         MaskFieldUtility
            .replacingOccurrencesOfString(&maskTemplateText,
                                          target     : "[\(maskBlockBrackets.left)\(maskBlockBrackets.right)]",
                withString : "")
        
        maskText = maskTemplateText
        
        refreshMask()
    }
    
    fileprivate func updateMaskTemplateTextFromBlock(_ index: Int) {
        
         MaskFieldUtility
            .replace(&maskTemplateText,
                     withString : maskBlocks[index].template,
                     inRange    : maskBlocks[index].patternRange)
    }
    
    fileprivate struct  MaskFieldProcessedBlock {
        var range  : NSRange?
        var string : String = ""
    }
    
    fileprivate func moveCarret() {
        var position: Int
        
        switch maskStatus {
        case .clear       : position = maskBlocks.first!.templateRange.location
        case .incomplete  : position = maskBlocks.flatMap { $0.chars.filter { $0.status == .clear } }.first!.templateRange.location
        case .complete    : position = maskBlocks.last!.templateRange.toRange()!.upperBound
        }
        
         MaskFieldUtility.maskField(self, moveCaretToPosition: position)
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldBeginEditing(self) ?? true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        
        maskDelegate?.maskFieldDidBeginEditing(self)
        
        if guardMask { return }
        
        moveCarret()
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldEndEditing(self) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        maskDelegate?.maskFieldDidEndEditing(self)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if guardMask { return false }
        
        let maskBlocksChars = maskBlocks.flatMap { $0.chars }
        
        var event:  MaskFieldEvent!
        
        var completed: Int = 0
        var cleared: Int   = 0
        
        
        var processedBlocks = [ MaskFieldProcessedBlock]()
        
        let intersertRanges =  MaskFieldUtility
            .findIntersection(maskBlocks.map { return $0.templateRange }, withRange: range)
        
        for (i, intersertRange) in intersertRanges.enumerated() {
            
            var processedBlock =  MaskFieldProcessedBlock()
            processedBlock.range = intersertRange
            
            if let intersertRange = intersertRange {
                processedBlock.range?.location = abs(maskBlocks[i].templateRange.location - intersertRange.location)
            }
            processedBlocks.append(processedBlock)
        }
        
        
        var location      = range.location
        var savedLocation = range.location
        
        for replacementCharacter in string.characters {
            if location == maskText?.characters.count { break }
            
            let nextCharacter = getNetCharacter(maskBlocksChars, fromLocation: location)
            
            var findMatches: Bool = false
            
            if nextCharacter.outsideBlock {
                
                if replacementCharacter != Character( MaskFieldUtility.substring(maskTemplateText, withNSRange: NSMakeRange(location, 1))) &&
                    replacementCharacter != " " {
                    
                    savedLocation = location
                    findMatches = true
                }
            } else {
                findMatches = true
            }
            
            if findMatches {
                if matchTextCharacter(replacementCharacter, withMaskCharacter: nextCharacter.char) {
                    
                    location = nextCharacter.char.templateRange.location
                    let blockIndex = nextCharacter.char.blockIndex
                    
                    processedBlocks[blockIndex].string.append(replacementCharacter)
                    
                    if processedBlocks[blockIndex].range == nil {
                        processedBlocks[blockIndex].range =  NSMakeRange(nextCharacter.char.index, 0)
                    }
                } else {
                    
                    location = savedLocation
                    
                    event = .error
                    break
                }
            }
            
            location += 1
        }
        
        for (i, processedBlock) in processedBlocks.enumerated() {
            if var _range = processedBlock.range {
                
                var _string = processedBlock.string
                
                let shouldChangeBlock = maskDelegate?
                    .maskField(self,
                               shouldChangeBlock : maskBlocks[i],
                               inRange           : &_range,
                               replacementString : &_string)
                    ?? true
                
                if shouldChangeBlock {
                    
                    if  processedBlock.range!.location != _range.location ||
                        processedBlock.range!.length   != _range.length {
                        
                        if let validatedRange =  MaskFieldUtility
                            .findIntersection([maskBlocks[i].templateRange], withRange: _range).first! as NSRange? {
                            
                            _range = validatedRange
                        }
                    }
                    
                    if processedBlock.string != _string {
                        
                        var validatedString = ""
                        
                        var _location = _range.location
                        
                        for replacementCharacter in _string.characters {
                            if _location > maskBlocks[i].templateRange.length { break }
                            
                            if matchTextCharacter(replacementCharacter, withMaskCharacter: maskBlocks[i].chars[_location]) {
                                validatedString.append(replacementCharacter)
                            } else {
                                event = .error
                                break
                            }
                            _location += 1
                        }
                        
                        _string = validatedString
                    }
                    
                    if !_string.isEmpty {
                        
                        var maskTextRange = NSMakeRange(_range.location, _string.characters.count)
                        
                        for index in [Int](maskTextRange.location..<maskTextRange.location+maskTextRange.length) {
                            
                            maskBlocks[i].chars[index].status = .complete
                            completed += 1
                        }
                        
                        maskTextRange.location += maskBlocks[i].templateRange.location
                        
                         MaskFieldUtility
                            .replace(&maskText,
                                     withString : _string,
                                     inRange    : maskTextRange)
                        
                        location = maskTextRange.toRange()!.upperBound
                        
                        event = .insert
                        
                        _range.location += maskTextRange.length
                        _range.length   -= maskTextRange.length
                    }
                    
                    if _range.length > 0 {
                        
                        var maskTextRange = _range
                        
                        for index in [Int](_range.location..<_range.location+_range.length) {
                            maskBlocks[i].chars[index].status = .clear
                            cleared += 1
                        }
                        
                        maskTextRange.location += maskBlocks[i].templateRange.location
                        
                        let cuttedTempalte =  MaskFieldUtility
                            .substring(maskTemplateText, withNSRange: maskTextRange)
                        
                         MaskFieldUtility
                            .replace(&maskText,
                                     withString : cuttedTempalte,
                                     inRange    : maskTextRange)
                        
                    }
                }
            }
        }
        
        refreshMask()
        
        if jumpToPrevBlock {
            for (i, maskBlock) in maskBlocks.enumerated().reversed() {
                
                if i > 0 {
                    
                    let min = maskBlock.templateRange.location
                    let max = maskBlocks[i-1].templateRange.location + maskBlocks[i-1].templateRange.length
                    
                    if min == location || (max < location && min > location) {
                        
                        location = max
                        
                        break
                    }
                }
            }
        }
        
         MaskFieldUtility.maskField(self, moveCaretToPosition: location)
        
        // EVENT
        
        if completed != 0 {
            event = cleared == 0 ? .insert : .replace
        } else {
            if cleared != 0 {
                event = .delete
            }
        }
        
        if let event = event {
            maskDelegate?.maskField(self, didChangedWithEvent: event)
        }
        
        
        
        return false
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        text = nil
        
        return false
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldReturn(self) ?? true
    }
    
    fileprivate func debugmaskBlocks() {
        for block in maskBlocks {
            print("BLOCK :")
            print("index          : \(block.index)")
            print("status         : \(block.status)")
            print("pattern        : \(block.pattern)")
            print("patternRange   : \(block.patternRange)")
            print("template       : \(block.template)")
            print("templateRange  : \(block.templateRange)")
            print("CHARS :")
            for char in block.chars {
                print("   index           : \(char.index)")
                print("   blockIndex      : \(char.blockIndex)")
                print("   status          : \(char.status)")
                print("   pattern         : \(char.pattern)")
                print("   patternRange    : \(char.patternRange)")
                print("   template        : \(char.template)")
                print("   templateRange   : \(char.templateRange)")
            }
            print("")
        }
    }
}


public protocol  MaskFieldDelegate: class {
    
    
    func maskFieldShouldBeginEditing(_ maskField:  MaskField) -> Bool
    
    
    func maskFieldDidBeginEditing(_ maskField:  MaskField)
    
    func maskFieldShouldEndEditing(_ maskField:  MaskField) -> Bool
    
    func maskFieldDidEndEditing(_ maskField:  MaskField)
    
    
    func maskField(_ maskField:  MaskField, didChangedWithEvent event:  MaskFieldEvent)
    
    
    func maskField(_ maskField:  MaskField, shouldChangeBlock block:  MaskFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool
    
    
    func maskFieldShouldReturn(_ maskField:  MaskField) -> Bool
}

public extension  MaskFieldDelegate {
    
    func maskFieldShouldBeginEditing(_ maskField:  MaskField) -> Bool {
        return true
    }
    
    func maskFieldDidBeginEditing(_ maskField:  MaskField) {}
    
    func maskFieldShouldEndEditing(_ maskField:  MaskField) -> Bool {
        return true
    }
    
    func maskFieldDidEndEditing(_ maskField:  MaskField) {}
    
    func maskField(_ maskField:  MaskField, didChangedWithEvent event:  MaskFieldEvent) {}
    
    func maskField(_ maskField:  MaskField, shouldChangeBlock block:  MaskFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool {
        return true
    }
    
    func maskFieldShouldReturn(_ maskField:  MaskField) -> Bool {
        return true
    }
}
