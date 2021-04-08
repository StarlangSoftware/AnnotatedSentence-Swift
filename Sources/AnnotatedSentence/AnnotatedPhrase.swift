//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 8.04.2021.
//

import Foundation
import Corpus

public class AnnotatedPhrase : Sentence{
    
    private var wordIndex: Int
    private var tag: String?
    
    /**
     * Constructor for AnnotatedPhrase. AnnotatedPhrase stores information about phrases such as
     * Shallow Parse phrases or named entity phrases.
     - Parameters:
        - wordIndex: Starting index of the first word in the phrase w.r.t. original sentence the phrase occurs.
        - tag : Tag of the phrase. Corresponds to the shallow parse or named entity tag.:
     */
    public init(wordIndex: Int, tag: String?){
        self.wordIndex = wordIndex
        self.tag = tag
        super.init()
    }
    
    /**
     * Accessor for the wordIndex attribute.
     - Returns: Starting index of the first word in the phrase w.r.t. original sentence the phrase occurs.
     */
    public func getWordIndex() -> Int{
        return wordIndex
    }
    
    /**
     * Accessor for the tag attribute.
     - Returns: Tag of the phrase. Corresponds to the shallow parse or named entity tag.
     */
    public func getTag() -> String?{
        return tag
    }
}
