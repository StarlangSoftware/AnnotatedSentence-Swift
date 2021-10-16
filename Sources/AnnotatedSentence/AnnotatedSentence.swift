//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 8.04.2021.
//

import Foundation
import Corpus
import PropBank
import FrameNet
import MorphologicalAnalysis
import WordNet
import DependencyParser

public class AnnotatedSentence : Sentence{
    
    /**
     * Empty constructor for the {@link AnnotatedSentence} class.
     */
    public override init(){
        super.init()
    }
    
    /**
     * Reads an annotated sentence from a text file.
     - Parameters:
        - url: File containing the annotated sentence.
     */
    public override init(url: URL) {
        super.init()
        do{
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            let lines : [String] = fileContent.split(whereSeparator: \.isNewline).map(String.init)
            let line = lines[0]
            let wordList = line.split(separator: " ")
            for word in wordList{
                words.append(AnnotatedWord(word: String(word)))
            }
        }catch{
        }
    }
    
    /**
     * The method constructs all possible shallow parse groups of a sentence.
     - Returns: Shallow parse groups of a sentence.
     */
    public func getShallowParseGroups() -> [AnnotatedPhrase] {
        var shallowParseGroups : [AnnotatedPhrase] = []
        var previousWord : AnnotatedWord? = nil
        var current : AnnotatedPhrase? = nil
        for i in 0..<wordCount() {
            let annotatedWord = getWord(index: i) as! AnnotatedWord
            if previousWord == nil {
                current = AnnotatedPhrase(wordIndex: i, tag: annotatedWord.getShallowParse()!)
            } else {
                if previousWord!.getShallowParse() != nil && previousWord!.getShallowParse() != annotatedWord.getShallowParse(){
                    shallowParseGroups.append(current!)
                    current = AnnotatedPhrase(wordIndex: i, tag: annotatedWord.getShallowParse())
                }
            }
            current!.addWord(word: annotatedWord)
            previousWord = annotatedWord
        }
        shallowParseGroups.append(current!)
        return shallowParseGroups
    }
    
    /**
     * The method checks all words in the sentence and returns true if at least one of the words is annotated with
     * PREDICATE tag.
     - Returns: True if at least one of the words is annotated with PREDICATE tag; false otherwise.
     */
    public func containsPredicate() -> Bool{
        for word in words {
            let annotatedWord = word as! AnnotatedWord
            if annotatedWord.getArgument() != nil && annotatedWord.getArgument()!.getArgumentType() == "PREDICATE"{
                return true
            }
        }
        return false
    }
    
    /**
     * The method checks all words in the sentence and returns true if at least one of the words is annotated with
     * PREDICATE tag.
     - Returns: True if at least one of the words is annotated with PREDICATE tag; false otherwise.
     */
    public func containsFramePredicate() -> Bool{
        for word in words {
            let annotatedWord = word as! AnnotatedWord
            if annotatedWord.getFrameElement() != nil && annotatedWord.getFrameElement()!.getFrameElementType() == "PREDICATE"{
                return true
            }
        }
        return false
    }
    
    /**
     * The method returns all possible words, which is
     * 1. Verb
     * 2. Its semantic tag is assigned
     * 3. A frameset exists for that semantic tag
     - Parameters:
        - framesetList: Frameset list that contains all frames for Turkish
     - Returns: An array of words, which are verbs, semantic tags assigned, and framesetlist assigned for that tag.
     */
    public func predicateCandidates(framesetList: FramesetList) -> [AnnotatedWord]{
        var candidateList : [AnnotatedWord] = []
        for word in words {
            let annotatedWord = word as! AnnotatedWord
            if annotatedWord.getParse() != nil && annotatedWord.getParse()!.isVerb() && annotatedWord.getSemantic() != nil && framesetList.frameExists(synSetId: annotatedWord.getSemantic()!) {
                candidateList.append(annotatedWord)
            }
        }
        for i in 0..<2 {
            for j in 0..<words.count - i - 1 {
                let annotatedWord = words[j] as! AnnotatedWord
                let nextAnnotatedWord = words[j + 1] as! AnnotatedWord
                if !candidateList.contains(annotatedWord) && candidateList.contains(nextAnnotatedWord) && annotatedWord.getSemantic() != nil && annotatedWord.getSemantic() == nextAnnotatedWord.getSemantic(){
                    candidateList.append(annotatedWord)
                }
            }
        }
        return candidateList
    }
    
    /**
     * The method returns all possible words, which is
     * 1. Verb
     * 2. Its semantic tag is assigned
     * 3. A frameset exists for that semantic tag
     - Parameters:
        - frameNet: FrameNet list that contains all frames for Turkish
     - Returns: An array of words, which are verbs, semantic tags assigned, and framenet assigned for that tag.
     */
    public func predicateFrameCandidates(frameNet: FrameNet) -> [AnnotatedWord]{
        var candidateList : [AnnotatedWord] = []
        for word in words {
            let annotatedWord = word as! AnnotatedWord
            if annotatedWord.getParse() != nil && annotatedWord.getParse()!.isVerb() && annotatedWord.getSemantic() != nil && frameNet.lexicalUnitExists(synSetId: annotatedWord.getSemantic()!) {
                candidateList.append(annotatedWord)
            }
        }
        for i in 0..<2 {
            for j in 0..<words.count - i - 1 {
                let annotatedWord = words[j] as! AnnotatedWord
                let nextAnnotatedWord = words[j + 1] as! AnnotatedWord
                if !candidateList.contains(annotatedWord) && candidateList.contains(nextAnnotatedWord) && annotatedWord.getSemantic() != nil && annotatedWord.getSemantic() == nextAnnotatedWord.getSemantic(){
                    candidateList.append(annotatedWord)
                }
            }
        }
        return candidateList
    }

    /**
     * Returns the i'th predicate in the sentence.
     - Parameters:
        - index: Predicate index
     - Returns: The predicate with index index in the sentence.
     */
    public func getPredicate(index: Int) -> String{
        var count1 : Int = 0
        var count2 : Int = 0
        var data : String = ""
        var word : [AnnotatedWord] = []
        var parse : [MorphologicalParse?] = []
        var i : Int
        if index < wordCount() {
            for i in 0..<wordCount() {
                word.append(getWord(index: i) as! AnnotatedWord)
                parse.append(word[i].getParse())
            }
            i = index
            while i >= 0 {
                if parse[i] != nil && parse[i]!.getRootPos() == "VERB" && parse[i]!.getPos() == "VERB" {
                    count1 = index - i
                    break
                }
                i -= 1
            }
            i = index
            while i < wordCount() - index {
                if parse[i] != nil && parse[i]!.getRootPos() == "VERB" && parse[i]!.getPos() == "VERB" {
                    count2 = i - index
                    break
                }
                i += 1
            }
            if count1 > count2 {
                data = word[count1].getName()
            } else {
                data = word[count2].getName()
            }
        }
        return data
    }
    
    /**
     * Removes the i'th word from the sentence
     - Parameters:
        - index: Word index
     */
    public func removeWord(index: Int){
        for value in words {
            let word = value as! AnnotatedWord
            if word.getUniversalDependency() != nil {
                if word.getUniversalDependency()!.to() == index + 1 {
                    word.setUniversalDependency(to: -1, dependencyType: "ROOT")
                } else {
                    if word.getUniversalDependency()!.to() > index + 1 {
                        word.setUniversalDependency(to: word.getUniversalDependency()!.to() - 1, dependencyType: (word.getUniversalDependency()?.description())!)
                    }
                }
            }
        }
        words.remove(at: index)
    }
    
    /**
     * The toStems method returns an accumulated string of each word's stems in words {@link ArrayList}.
     * If the parse of the word does not exist, the method adds the surfaceform to the resulting string.
     *
        - Returns: String result which has all the stems of each item in words {@link ArrayList}.
     */
    public func toStems() -> String{
        var annotatedWord : AnnotatedWord
        var result : String
        if words.count > 0 {
            annotatedWord = words[0] as! AnnotatedWord
            if annotatedWord.getParse() != nil {
                result = annotatedWord.getParse()!.getWord().getName()
            } else {
                result = annotatedWord.getName()
            }
            for i in 1..<words.count {
                annotatedWord = words[i] as! AnnotatedWord
                if annotatedWord.getParse() != nil {
                    result = result + " " + annotatedWord.getParse()!.getWord().getName()
                } else {
                    result = result + " " + annotatedWord.getName()
                }
            }
            return result
        } else {
            return ""
        }
    }
    
    public func compareParses(sentence : AnnotatedSentence) -> ParserEvaluationScore{
        let score = ParserEvaluationScore()
        for i in 0..<wordCount(){
            let relation1 = (getWord(index: i) as! AnnotatedWord).getUniversalDependency()
            let relation2 = (sentence.getWord(index: i) as! AnnotatedWord).getUniversalDependency()
            if relation1 != nil && relation2 != nil{
                score.add(parserEvaluationScore: relation1!.compareRelations(relation: relation2!))
            }
        }
        return score
    }

    /**
     * Creates a list of literal candidates for the i'th word in the sentence. It combines the results of
     * 1. All possible root forms of the i'th word in the sentence
     * 2. All possible 2-word expressions containing the i'th word in the sentence
     * 3. All possible 3-word expressions containing the i'th word in the sentence
     - Parameters:
        - wordNet: Turkish wordnet
        - fsm: Turkish morphological analyzer
        - wordIndex: Word index
     - Returns: List of literal candidates containing all possible root forms and multiword expressions.
     */
    public func constructLiterals(wordNet: WordNet, fsm: FsmMorphologicalAnalyzer, wordIndex: Int) -> [Literal]{
        let word = getWord(index: wordIndex) as! AnnotatedWord
        var possibleLiterals : [Literal] = []
        let morphologicalParse = word.getParse()
        let metamorphicParse = word.getMetamorphicParse()
        possibleLiterals.append(contentsOf: wordNet.constructLiterals(word: morphologicalParse!.getWord().getName(), parse: morphologicalParse!, metaParse: metamorphicParse!, fsm: fsm));
        var firstSucceedingWord : AnnotatedWord? = nil
        var secondSucceedingWord : AnnotatedWord? = nil
        if wordCount() > wordIndex + 1 {
            firstSucceedingWord = getWord(index: wordIndex + 1) as? AnnotatedWord
            if wordCount() > wordIndex + 2 {
                secondSucceedingWord = getWord(index: wordIndex + 2) as? AnnotatedWord
            }
        }
        if firstSucceedingWord != nil {
            if secondSucceedingWord != nil {
                possibleLiterals.append(contentsOf: wordNet.constructIdiomLiterals(morphologicalParse1: word.getParse()!, morphologicalParse2: firstSucceedingWord!.getParse()!, morphologicalParse3: secondSucceedingWord!.getParse()!, metaParse1: word.getMetamorphicParse()!, metaParse2: firstSucceedingWord!.getMetamorphicParse()!, metaParse3: secondSucceedingWord!.getMetamorphicParse()!, fsm: fsm))
            }
            possibleLiterals.append(contentsOf: wordNet.constructIdiomLiterals(morphologicalParse1: word.getParse()!, morphologicalParse2: firstSucceedingWord!.getParse()!, metaParse1: word.getMetamorphicParse()!, metaParse2: firstSucceedingWord!.getMetamorphicParse()!, fsm: fsm));
        }
        possibleLiterals.sort(by: {$0.name >= $1.name})
        return possibleLiterals
    }
    
    /**
     * Creates a list of synset candidates for the i'th word in the sentence. It combines the results of
     * 1. All possible synsets containing the i'th word in the sentence
     * 2. All possible synsets containing 2-word expressions, which contains the i'th word in the sentence
     * 3. All possible synsets containing 3-word expressions, which contains the i'th word in the sentence
     - Parameters:
        - wordNet: Turkish wordnet
        - fsm: Turkish morphological analyzer
        - wordIndex: Word index
     - Returns: List of synset candidates containing all possible root forms and multiword expressions.
     */
    public func constructSynSets(wordNet: WordNet, fsm: FsmMorphologicalAnalyzer, wordIndex: Int) -> [SynSet]{
        let word = getWord(index: wordIndex) as! AnnotatedWord
        var possibleSynSets : [SynSet] = []
        let morphologicalParse : MorphologicalParse = word.getParse()!
        let metamorphicParse = word.getMetamorphicParse()
        possibleSynSets.append(contentsOf: wordNet.constructSynSets(word: morphologicalParse.getWord().getName(), parse: morphologicalParse, metaParse: metamorphicParse!, fsm: fsm))
        var firstPrecedingWord : AnnotatedWord? = nil
        var secondPrecedingWord : AnnotatedWord? = nil
        var firstSucceedingWord : AnnotatedWord? = nil
        var secondSucceedingWord : AnnotatedWord? = nil
        if wordIndex > 0 {
            firstPrecedingWord = getWord(index: wordIndex - 1) as? AnnotatedWord
            if wordIndex > 1 {
                secondPrecedingWord = getWord(index: wordIndex - 2) as? AnnotatedWord
            }
        }
        if wordCount() > wordIndex + 1 {
            firstSucceedingWord = getWord(index: wordIndex + 1) as? AnnotatedWord
            if wordCount() > wordIndex + 2 {
                secondSucceedingWord = getWord(index: wordIndex + 2) as? AnnotatedWord
            }
        }
        if firstPrecedingWord != nil {
            if secondPrecedingWord != nil {
                possibleSynSets.append(contentsOf: wordNet.constructIdiomSynSets(morphologicalParse1: secondPrecedingWord!.getParse()!, morphologicalParse2: firstPrecedingWord!.getParse()!, morphologicalParse3: word.getParse()!, metaParse1: secondPrecedingWord!.getMetamorphicParse()!, metaParse2: firstPrecedingWord!.getMetamorphicParse()!, metaParse3: word.getMetamorphicParse()!, fsm: fsm))
            }
            possibleSynSets.append(contentsOf: wordNet.constructIdiomSynSets(morphologicalParse1: firstPrecedingWord!.getParse()!, morphologicalParse2: word.getParse()!, metaParse1: firstPrecedingWord!.getMetamorphicParse()!, metaParse2: word.getMetamorphicParse()!, fsm: fsm))
        }
        if firstPrecedingWord != nil && firstSucceedingWord != nil {
            possibleSynSets.append(contentsOf: wordNet.constructIdiomSynSets(morphologicalParse1: firstPrecedingWord!.getParse()!, morphologicalParse2: word.getParse()!, morphologicalParse3: firstSucceedingWord!.getParse()!, metaParse1: firstPrecedingWord!.getMetamorphicParse()!, metaParse2: word.getMetamorphicParse()!, metaParse3: firstSucceedingWord!.getMetamorphicParse()!, fsm: fsm))
        }
        if firstSucceedingWord != nil {
            if secondSucceedingWord != nil {
                possibleSynSets.append(contentsOf: wordNet.constructIdiomSynSets(morphologicalParse1: word.getParse()!, morphologicalParse2: firstSucceedingWord!.getParse()!, morphologicalParse3: secondSucceedingWord!.getParse()!, metaParse1: word.getMetamorphicParse()!, metaParse2: firstSucceedingWord!.getMetamorphicParse()!, metaParse3: secondSucceedingWord!.getMetamorphicParse()!, fsm: fsm))
            }
            possibleSynSets.append(contentsOf: wordNet.constructIdiomSynSets(morphologicalParse1: word.getParse()!, morphologicalParse2: firstSucceedingWord!.getParse()!, metaParse1: word.getMetamorphicParse()!, metaParse2: firstSucceedingWord!.getMetamorphicParse()!, fsm: fsm))
        }
        possibleSynSets.sort(by: {$0.getId() >= $1.getId()})
        return possibleSynSets
    }
}
