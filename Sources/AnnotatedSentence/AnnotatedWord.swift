import Foundation
import Dictionary
import MorphologicalAnalysis
import NamedEntityRecognition
import PropBank
import FrameNet
import DependencyParser
import SentiNet

public class AnnotatedWord : Word {
    
    private var parse: MorphologicalParse? = nil
    private var metamorphicParse: MetamorphicParse? = nil
    private var semantic: String? = nil
    private var namedEntityType: NamedEntityType? = nil
    private var argument: Argument? = nil
    private var frameElement: FrameElement? = nil
    private var universalDependency: UniversalDependencyRelation? = nil
    private var shallowParse: String? = nil
    private var polarity: PolarityType? = nil
    private var slot: Slot? = nil
    
    /**
     * Constructor for the {@link AnnotatedWord} class. Gets the word with its annotation layers as input and sets the
     * corresponding layers.
     - Parameters:
        - word: Input word with annotation layers
     */
    public init(word: String){
        super.init(name: "")
        let splitLayers = word.components(separatedBy: CharacterSet(charactersIn: "{}"))
        for layer in splitLayers{
            if layer == ""{
                continue
            }
            if !layer.contains("="){
                setName(name: layer)
            }
            let layerType = String(layer[layer.startIndex..<layer.range(of: "=")!.lowerBound])
            let layerValue = String(layer[layer.index(layer.firstIndex(of: "=")!, offsetBy: 1)...])
            switch layerType{
                case "turkish":
                    setName(name: layerValue)
                case "morphologicalAnalysis":
                    parse = MorphologicalParse(parse: layerValue)
                case "metaMorphemes":
                    metamorphicParse = MetamorphicParse(parse: layerValue)
                case "semantics":
                    semantic = layerValue
                case "namedEntity":
                    namedEntityType = NamedEntityTypeStatic.getNamedEntityType(entityType: layerValue)
                case "propbank":
                    argument = Argument(argument: layerValue)
                case "shallowParse":
                    shallowParse = layerValue
                case "universalDependency":
                    let values = layerValue.split(separator: "$")
                    universalDependency = UniversalDependencyRelation(toWord: Int(String(values[0]))!, dependencyType: String(values[1]))
                case "framenet":
                    frameElement = FrameElement(frameElement: layerValue)
                case "slot":
                    slot = Slot(slot: layerValue)
                case "polarity":
                    setPolarity(polarity: layerValue)
                default:
                    break
            }
        }
    }
    
    /**
     * Converts an {@link AnnotatedWord} to string. For each annotation layer, the method puts a left brace, layer name,
     * equal sign and layer value finishing with right brace.
     - Returns: String form of the {@link AnnotatedWord}.
     */
    public override func description() -> String {
        var result : String = "{turkish=" + getName() + "}"
        if parse != nil {
            result = result + "{morphologicalAnalysis=" + (parse?.description())! + "}"
        }
        if metamorphicParse != nil {
            result = result + "{metaMorphemes=" + metamorphicParse!.description() + "}"
        }
        if semantic != nil {
            result = result + "{semantics=" + semantic! + "}"
        }
        if namedEntityType != nil {
            result = result + "{namedEntity=" + namedEntityType!.rawValue + "}"
        }
        if argument != nil {
            result = result + "{propbank=" + argument!.description() + "}"
        }
        if frameElement != nil {
            result = result + "{framenet=" + frameElement!.description() + "}"
        }
        if shallowParse != nil {
            result = result + "{shallowParse=" + shallowParse! + "}"
        }
        if universalDependency != nil {
            result = result + "{universalDependency=" + String(universalDependency!.to()) + "$" + universalDependency!.description() + "}"
        }
        if slot != nil {
            result = result + "{slot=" + slot!.description() + "}"
        }
        if polarity != nil {
            result = result + "{polarity=" + getPolarityString() + "}"
        }
        return result
    }
    
    /**
     * Another constructor for {@link AnnotatedWord}. Gets the word and a namedEntityType and sets two layers.
     - Parameters:
        - name: Lemma of the word.
        - namedEntityType: Named entity of the word.
     */
    public init(name: String, namedEntityType: NamedEntityType){
        super.init(name: name)
        self.namedEntityType = namedEntityType
    }
    
    /**
     * Another constructor for {@link AnnotatedWord}. Gets the word and morphological parse and sets two layers.
     - Parameters:
        - name: Lemma of the word.
        - parse: Morphological parse of the word.
     */
    public init(name: String, parse: MorphologicalParse){
        super.init(name: name)
        self.parse = parse
    }
    
    /**
     * Another constructor for {@link AnnotatedWord}. Gets the word and morphological parse and sets two layers.
     - Parameters:
        - name: Lemma of the word.
        - parse: Morphological parse of the word.
     */
    public init(name: String, parse: FsmParse){
        super.init(name: name)
        self.parse = parse;
        setMetamorphicParse(parseString: parse.withList())
    }
    
    /**
     * Returns the value of a given layer.
     - Parameters:
        - viewLayerType: Layer for which the value questioned.
     - Returns: The value of the given layer.
     */
    public func getLayerInfo(viewLayerType: ViewLayerType) -> String?{
        switch viewLayerType {
            case ViewLayerType.INFLECTIONAL_GROUP:
                if parse != nil {
                    return parse?.description()
                }
            case ViewLayerType.META_MORPHEME:
                if metamorphicParse != nil {
                    return metamorphicParse?.description()
                }
            case ViewLayerType.SEMANTICS:
                return semantic
            case ViewLayerType.NER:
                if namedEntityType != nil {
                    return namedEntityType?.rawValue
                }
            case ViewLayerType.SHALLOW_PARSE:
                return shallowParse
            case ViewLayerType.TURKISH_WORD:
                return getName()
            case ViewLayerType.PROPBANK:
                if argument != nil {
                    return argument?.description()
                }
            case ViewLayerType.DEPENDENCY:
                if universalDependency != nil {
                    return String(universalDependency!.to()) + "$" + (universalDependency?.description())!
                }
            case ViewLayerType.FRAMENET:
                if frameElement != nil {
                    return frameElement?.description()
                }
            case ViewLayerType.SLOT:
                if slot != nil {
                    return slot?.description()
                }
            case ViewLayerType.POLARITY:
                if polarity != nil {
                    return getPolarityString()
                }
            default:
                return nil
        }
        return nil
    }
    
    /**
     * Returns the morphological parse layer of the word.
     - Returns: The morphological parse of the word.
     */
    public func getParse() -> MorphologicalParse?{
        return parse
    }
    
    /**
     * Sets the morphological parse layer of the word.
     - Parameters:
        - parseString: The new morphological parse of the word in string form.
     */
    public func setParse(parseString: String?){
        if parseString != nil {
            parse = MorphologicalParse(parse: parseString!)
        } else {
            parse = nil
        }
    }
    
    /**
     * Returns the metamorphic parse layer of the word.
     - Returns: The metamorphic parse of the word.
     */
    public func getMetamorphicParse() -> MetamorphicParse?{
        return metamorphicParse
    }
    
    /**
     * Sets the metamorphic parse layer of the word.
     - Parameters:
        - parseString: The new metamorphic parse of the word in string form.
     */
    public func setMetamorphicParse(parseString: String){
        metamorphicParse = MetamorphicParse(parse: parseString)
    }
    
    /**
     * Returns the semantic layer of the word.
     - Returns: Sense id of the word.
     */
    public func getSemantic() -> String?{
        return semantic
    }
    
    /**
     * Sets the semantic layer of the word.
     - Parameters:
        - semantic: New sense id of the word.
     */
    public func setSemantic(semantic: String){
        self.semantic = semantic
    }
    
    /**
     * Returns the named entity layer of the word.
     - Returns: Named entity tag of the word.
     */
    public func getNamedEntityType() -> NamedEntityType?{
        return namedEntityType
    }
    
    /**
     * Sets the named entity layer of the word.
     - Parameters:
        - namedEntity: New named entity tag of the word.
     */
    public func setNamedEntityType(namedEntity: String?){
        if namedEntity != nil {
            namedEntityType = NamedEntityTypeStatic.getNamedEntityType(entityType: namedEntity!)
        } else {
            namedEntityType = nil
        }
    }
    
    /**
     * Returns the semantic role layer of the word.
     - Returns: Semantic role tag of the word.
     */
    public func getArgument() -> Argument?{
        return argument
    }

    /**
     * Sets the semantic role layer of the word.
     - Parameters:
        - argument: New semantic role tag of the word.
     */
    public func setArgument(argument: String?){
        if argument != nil {
            self.argument = Argument(argument: argument!)
        } else {
            self.argument = nil
        }
    }
    
    /**
     * Returns the frameNet layer of the word.
     - Returns: FrameNet tag of the word.
     */
    public func getFrameElement() -> FrameElement? {
        return frameElement
    }
    
    /**
     * Sets the framenet layer of the word.
     - Parameters:
        - frameElement: New frame element tag of the word.
     */
    public func setFrameElement(frameElement: String?) {
        if frameElement != nil {
            self.frameElement = FrameElement(frameElement: frameElement!)
        } else {
            self.frameElement = nil
        }
    }
    
    /**
     * Returns the slot filling layer of the word.
     - Returns: Slot tag of the word.
     */
    public func getSlot() -> Slot?{
        return slot
    }
    
    /**
     * Sets the slot filling layer of the word.
     - Parameters:
        - slot: New slot tag of the word.
     */
    public func setSlot(slot: String?) {
        if slot != nil {
            self.slot = Slot(slot: slot!)
        } else {
            self.slot = nil
        }
    }
    
    /**
     * Returns the polarity layer of the word.
     - Returns: Polarity tag of the word.
     */
    public func getPolarity() -> PolarityType?{
        return polarity
    }
    
    /**
     * Returns the polarity layer of the word.
     - Returns: Polarity string of the word.
     */
    public func getPolarityString() -> String{
        switch polarity! {
            case PolarityType.POSITIVE:
                return "positive"
            case PolarityType.NEGATIVE:
                return "negative"
            case PolarityType.NEUTRAL:
                return "neutral"
        }
    }
    
    /**
     * Sets the polarity layer of the word.
     - Parameters:
        - polarity: New polarity tag of the word.
     */
    public func setPolarity(polarity: String?){
        if polarity != nil {
            switch polarity!.lowercased() {
                case "positive", "pos":
                    self.polarity = PolarityType.POSITIVE
                    break;
                case "negative", "neg":
                    self.polarity = PolarityType.NEGATIVE;
                    break;
                default:
                    self.polarity = PolarityType.NEUTRAL
            }
        } else {
            self.polarity = nil
        }
    }
    
    /**
     * Returns the shallow parse layer of the word.
     - Returns: Shallow parse tag of the word.
     */
    public func getShallowParse() -> String?{
        return shallowParse
    }
    
    /**
     * Sets the shallow parse layer of the word.
     - Parameters:
        - parse: New shallow parse tag of the word.
     */
    public func setShallowParse(parse: String) {
        shallowParse = parse
    }
    
    /**
     * Returns the universal dependency layer of the word.
     - Returns: Universal dependency relation of the word.
     */
    public func getUniversalDependency() -> UniversalDependencyRelation? {
        return universalDependency
    }
    
    /**
     * Sets the universal dependency layer of the word.
     - Parameters:
        - to: Word related to.
        - dependencyType: type of dependency the word is related to.
     */
    public func setUniversalDependency(to: Int, dependencyType: String){
        if to < 0 {
            universalDependency = nil
        } else {
            universalDependency = UniversalDependencyRelation(toWord: to, dependencyType: dependencyType)
        }
    }
    
    public func checkGazetteer(gazetteer: Gazetteer){
        let wordLowercase = Word.lowercase(s: getName())
        if gazetteer.contains(word: wordLowercase) && parse!.containsTag(tag: MorphologicalTag.PROPERNOUN) {
            setNamedEntityType(namedEntity: gazetteer.getName())
        }
        let substring = String(wordLowercase[wordLowercase.startIndex..<wordLowercase.range(of: "'")!.lowerBound])
        if wordLowercase.contains("'") && gazetteer.contains(word: substring) && parse!.containsTag(tag: MorphologicalTag.PROPERNOUN) {
            setNamedEntityType(namedEntity: gazetteer.getName());
        }
    }
}
