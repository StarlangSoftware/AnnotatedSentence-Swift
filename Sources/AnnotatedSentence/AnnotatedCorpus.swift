//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 8.04.2021.
//

import Foundation
import Corpus
import DependencyParser

public class AnnotatedCorpus : Corpus{
    
    /**
     * Empty constructor for {@link AnnotatedCorpus}.
     */
    public override init(){
        super.init()
    }
    
    /**
     * A constructor of {@link AnnotatedCorpus} class which reads all {@link AnnotatedSentence} files inside the given
     * folder. For each file inside that folder, the constructor creates an AnnotatedSentence and puts in inside the
     * list sentences.
     - Parameters:
        - folder: Folder to load annotated courpus
     */
    public init(folder: String){
        super.init()
        let fileManager = FileManager.default
        do {
            let listOfFiles = try fileManager.contentsOfDirectory(atPath: folder)
            for file in listOfFiles {
                let thisSourceFile = URL(fileURLWithPath: #file)
                let thisDirectory = thisSourceFile.deletingLastPathComponent()
                let url = thisDirectory.appendingPathComponent(file)
                let sentence = AnnotatedSentence(url: url)
                sentences.append(sentence)
            }
        } catch {
        }
    }
    
    /**
     * A constructor of {@link AnnotatedCorpus} class which reads all {@link AnnotatedSentence} files with the file
     * name satisfying the given pattern inside the given folder. For each file inside that folder, the constructor
     * creates an AnnotatedSentence and puts in inside the list parseTrees.
     - Parameters:
        - folder: Folder where all sentences reside.
        - pattern: File pattern such as "." ".train" ".test".
     */
    public init(folder: String, pattern: String){
        super.init()
        let fileManager = FileManager.default
        do {
            let listOfFiles = try fileManager.contentsOfDirectory(atPath: folder)
            for file in listOfFiles {
                if file.contains(pattern){
                    let thisSourceFile = URL(fileURLWithPath: #file)
                    let thisDirectory = thisSourceFile.deletingLastPathComponent()
                    let url = thisDirectory.appendingPathComponent(file)
                    let sentence = AnnotatedSentence(url: url)
                    sentences.append(sentence)
                }
            }
        } catch {
        }
    }
    
    /// Compares the corpus with the given corpus and returns a parser evaluation score for this comparison. The result
    /// is calculated by summing up the parser evaluation scores of sentence by sentence dependency relation comparisons.
    /// - Parameter corpus: Corpus to be compared.
    /// - Returns: A parser evaluation score object.
    public func compareParses(corpus: AnnotatedCorpus) -> ParserEvaluationScore{
        let result = ParserEvaluationScore()
        for i in 0..<sentences.count{
            let sentence1 = getSentence(index: i) as! AnnotatedSentence
            let sentence2 = corpus.getSentence(index: i) as! AnnotatedSentence
            result.add(parserEvaluationScore: sentence1.compareParses(sentence: sentence2))
        }
        return result
    }
    
}
