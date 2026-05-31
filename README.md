This resource allows for matching of Turkish words or expressions with their corresponding entries within the Turkish dictionary, the Turkish PropBank TRopBank, morphological analysis, named entity recognition, word senses from Turkish WordNet KeNet, shallow parsing, and universal dependency relation.

## Data Format

The structure of a sample annotated word is as follows:

	{turkish=Gelir}
	{morphologicalAnalysis=gelir+NOUN+A3SG+PNON+NOM}
	{metaMorphemes=gelir}
	{semantics=TUR10-0289950}
	{namedEntity=NONE}
	{propbank=ARG0$TUR10-0798130}
	{shallowParse=ÖZNE}
	{universalDependency=10$NSUBJ}

As is self-explanatory, 'turkish' tag shows the original Turkish word; 'morphologicalAnalysis' tag shows the correct morphological parse of that word; 'semantics' tag shows the ID of the correct sense of that word; 'namedEntity' tag shows the named entity tag of that word; 'shallowParse' tag shows the semantic role of that word; 'universalDependency' tag shows the index of the head word and the universal dependency for this word; 'propbank' tag shows the semantic role of that word for the verb synset id (frame id in the frame file) which is also given in that tag.

Video Lectures
============

[<img src="https://github.com/StarlangSoftware/AnnotatedSentence/blob/master/video1.jpg" width="50%">](https://youtu.be/FtoCdIELkG8)[<img src="https://github.com/StarlangSoftware/AnnotatedSentence/blob/master/video2.jpg" width="50%">](https://youtu.be/jHxZ2aMimoQ)

For Developers
============

You can also see [Python](https://github.com/starlangsoftware/AnnotatedSentence-Py), [Java](https://github.com/starlangsoftware/AnnotatedSentence), [C++](https://github.com/starlangsoftware/AnnotatedSentence-CPP), [C](https://github.com/starlangsoftware/AnnotatedSentence-C), [Swift](https://github.com/starlangsoftware/AnnotatedSentence-Swift), [Js](https://github.com/starlangsoftware/AnnotatedSentence-Js), [Php](https://github.com/starlangsoftware/AnnotatedSentence-Php), or [C#](https://github.com/starlangsoftware/AnnotatedSentence-CS) repository.

## Requirements

* Xcode Editor
* [Git](#git)

### Git

Install the [latest version of Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Download Code

In order to work on code, create a fork from GitHub page. 
Use Git for cloning the code to your local or below line for Ubuntu:

	git clone <your-fork-git-link>

A directory called AnnotatedSentence-Swift will be created. Or you can use below link for exploring the code:

	git clone https://github.com/starlangsoftware/AnnotatedSentence-Swift.git

## Open project with XCode

To import projects from Git with version control:

* XCode IDE, select Clone an Existing Project.

* In the Import window, paste github URL.

* Click Clone.

Result: The imported project is listed in the Project Explorer view and files are loaded.


## Compile

**From IDE**

After being done with the downloading and opening project, select **Build** option from **Product** menu. After compilation process, user can run AnnotatedSentence-Swift.

Detailed Description
============

+ [AnnotatedCorpus](#annotatedcorpus)
+ [AnnotatedSentence](#annotatedsentence)
+ [AnnotatedWord](#annotatedword)

## AnnotatedCorpus

To load the annotated corpus:

	AnnotatedCorpus(folder: String, pattern: String)
	let a = AnnotatedCorpus("/Turkish-Phrase", ".train")
	let b = AnnotatedCorpus("/Turkish-Phrase")

To access all the sentences in a AnnotatedCorpus:

	for i in 0..<a.sentenceCount(){
		let annotatedSentence = a.getSentence(i)
	}

## AnnotatedSentence

Bir AnnotatedSentence'daki tüm kelimelere ulaşmak için de

	for j in 0..<annotatedSentence.wordCount(){
		annotatedWord = annotatedSentence.getWord(j)
	}

## AnnotatedWord

An annotated word is kept in AnnotatedWord class. To access the morphological analysis of 
the annotated word:

	getParse() -> MorphologicalParse

Meaning of the annotated word:

	getSemantic() -> String

NER annotation of the annotated word:

	getNamedEntityType() -> NamedEntityType

Shallow parse tag of the annotated word (e.g., subject, indirect object):

	getShallowParse() -> String

Dependency annotation of the annotated word:

	getUniversalDependency() -> UniversalDependencyRelation

# Cite

	@INPROCEEDINGS{8374369,
  	author={O. T. {Yıldız} and K. {Ak} and G. {Ercan} and O. {Topsakal} and C. {Asmazoğlu}},
  	booktitle={2018 2nd International Conference on Natural Language and Speech Processing (ICNLSP)}, 
  	title={A multilayer annotated corpus for Turkish}, 
  	year={2018},
  	volume={},
  	number={},
  	pages={1-6},
  	doi={10.1109/ICNLSP.2018.8374369}}

For Contibutors
============

### Package.swift file

1. Dependencies should be given w.r.t github.
```
    dependencies: [
        .package(name: "MorphologicalAnalysis", url: "https://github.com/StarlangSoftware/TurkishMorphologicalAnalysis-Swift.git", .exact("1.0.6"))],
```
2. Targets should include direct dependencies, files to be excluded, and all resources.
```
    targets: [
        .target(
	dependencies: ["MorphologicalAnalysis"],
	exclude: ["turkish1944_dictionary.txt", "turkish1944_wordnet.xml",
	"turkish1955_dictionary.txt", "turkish1955_wordnet.xml",
	"turkish1959_dictionary.txt", "turkish1959_wordnet.xml",
	"turkish1966_dictionary.txt", "turkish1966_wordnet.xml",
	"turkish1969_dictionary.txt", "turkish1969_wordnet.xml",
	"turkish1974_dictionary.txt", "turkish1974_wordnet.xml",
	"turkish1983_dictionary.txt", "turkish1983_wordnet.xml",
	"turkish1988_dictionary.txt", "turkish1988_wordnet.xml",
	"turkish1998_dictionary.txt", "turkish1998_wordnet.xml"],
	resources:
[.process("turkish_wordnet.xml"),.process("english_wordnet_version_31.xml"),.process("english_exception.xml")]),
```
3. Test targets should include test directory.
```
	.testTarget(
		name: "WordNetTests",
		dependencies: ["WordNet"]),
```

### Data files
1. Add data files to the project folder.

### Swift files

1. Do not forget to comment each function.
```
   /**
     * Returns the value to which the specified key is mapped.
     - Parameters:
        - id: String id of a key
     - Returns: value of the specified key
     */
    public func singleMap(id: String) -> String{
        return map[id]!
    }
```
2. Do not forget to define classes as open in order to be able to extend them in other packages.
```
	open class Word : Comparable, Equatable, Hashable
```
3. Function names should follow caml case.
```
	public func map(id: String)->String?
```
4. Write getter and setter methods.
```
	public func getSynSetId() -> String{
	public func setOrigin(origin: String){
```
5. Use separate test class extending XCTestCase for testing purposes.
```
final class WordNetTest: XCTestCase {
    var turkish : WordNet = WordNet()
    
    func testSize() {
        XCTAssertEqual(78326, turkish.size())
    }
```
6. Enumerated types should be declared as enum.
```
public enum CategoryType : String{
    case MATHEMATICS
    case SPORT
    case MUSIC
```
7. Implement == operator and hasher method for hashing purposes.
```
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    public static func == (lhs: Relation, rhs: Relation) -> Bool {
        return lhs.name == rhs.name
    }
```
8. Make classes Comparable for comparison, Equatable for equality, and Hashable for hashing check.
```
	open class Word : Comparable, Equatable, Hashable
```
9. Implement < operator for comparison purposes.
```
    public static func < (lhs: Word, rhs: Word) -> Bool {
        return lhs.name < rhs.name
    }
```
10. Implement description for toString method.
```
	open func description() -> String{
```
11. Use Bundle and XMLParserDelegate for parsing Xml files.
```
	let url = Bundle.module.url(forResource: fileName, withExtension: "xml")
	var parser : XMLParser = XMLParser(contentsOf: url!)!
	parser.delegate = self
	parser.parse()
```
also use parser method.
```
public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
```
