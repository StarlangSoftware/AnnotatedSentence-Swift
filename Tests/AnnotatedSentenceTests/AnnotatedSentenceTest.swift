import XCTest
import PropBank
@testable import AnnotatedSentence

final class AnnotatedSentenceTest: XCTestCase {
    
    var sentence0: AnnotatedSentence = AnnotatedSentence()
    var sentence1: AnnotatedSentence = AnnotatedSentence()
    var sentence2: AnnotatedSentence = AnnotatedSentence()
    var sentence3: AnnotatedSentence = AnnotatedSentence()
    var sentence4: AnnotatedSentence = AnnotatedSentence()
    var sentence5: AnnotatedSentence = AnnotatedSentence()
    var sentence6: AnnotatedSentence = AnnotatedSentence()
    var sentence7: AnnotatedSentence = AnnotatedSentence()
    var sentence8: AnnotatedSentence = AnnotatedSentence()
    var sentence9: AnnotatedSentence = AnnotatedSentence()

    override func setUp() {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        sentence0 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0000.dev"))
        sentence1 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0001.dev"))
        sentence2 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0002.dev"))
        sentence3 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0003.dev"))
        sentence4 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0004.dev"))
        sentence5 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0005.dev"))
        sentence6 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0006.dev"))
        sentence7 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0007.dev"))
        sentence8 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0008.dev"))
        sentence9 = AnnotatedSentence(url: thisDirectory.appendingPathComponent("sentences/0009.dev"))
    }

    func testGetShallowParseGroups() {
        XCTAssertEqual(4, sentence0.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence1.getShallowParseGroups().count)
        XCTAssertEqual(3, sentence2.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence3.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence4.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence5.getShallowParseGroups().count)
        XCTAssertEqual(6, sentence6.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence7.getShallowParseGroups().count)
        XCTAssertEqual(5, sentence8.getShallowParseGroups().count)
        XCTAssertEqual(3, sentence9.getShallowParseGroups().count)
    }

    func testContainsPredicate() {
        XCTAssertTrue(sentence0.containsPredicate())
        XCTAssertTrue(sentence1.containsPredicate())
        XCTAssertFalse(sentence2.containsPredicate())
        XCTAssertTrue(sentence3.containsPredicate())
        XCTAssertTrue(sentence4.containsPredicate())
        XCTAssertFalse(sentence5.containsPredicate())
        XCTAssertFalse(sentence6.containsPredicate())
        XCTAssertTrue(sentence7.containsPredicate())
        XCTAssertTrue(sentence8.containsPredicate())
        XCTAssertTrue(sentence9.containsPredicate())
    }

    func testGetPredicate() {
        XCTAssertEqual("buland??rd??", sentence0.getPredicate(index: 0))
        XCTAssertEqual("yapacak", sentence1.getPredicate(index: 0))
        XCTAssertEqual("ediyorlar", sentence3.getPredicate(index: 0))
        XCTAssertEqual("yazm????t??", sentence4.getPredicate(index: 0))
        XCTAssertEqual("olunacakt??", sentence7.getPredicate(index: 0))
        XCTAssertEqual("gerekiyordu", sentence8.getPredicate(index: 0))
        XCTAssertEqual("ediyor", sentence9.getPredicate(index: 0))
    }

    func testToStems() {
        XCTAssertEqual("devasa ??l??ek yeni kanun kullan karma????k ve ??etrefil dil kavga bulan .", sentence0.toStems())
        XCTAssertEqual("gelir art usul komite gel sal?? g??n kanun tasar?? hakk??nda bir duru??ma yap .", sentence1.toStems())
        XCTAssertEqual("reklam ve tan??t??m i?? yara yara g??r ??zere .", sentence2.toStems())
        XCTAssertEqual("bu defa , daha da h??z hareket et .", sentence3.toStems())
        XCTAssertEqual("shearson lehman hutton ??nc. d??n ????le sonra kadar yeni tv reklam yaz .", sentence4.toStems())
        XCTAssertEqual("bu kez , firma haz??r .", sentence5.toStems())
        XCTAssertEqual("`` diyalog s??r kesinlikle temel ??nem haiz .", sentence6.toStems())
        XCTAssertEqual("cuma g??n bu ??zerine d??????n ??ok ge?? kal ol .", sentence7.toStems())
        XCTAssertEqual("bu hakk??nda ??nceden d??????n gerek . ''", sentence8.toStems())
        XCTAssertEqual("isim g??re ??e??it g??ster birka?? kefaret fon reklam yap i??in devam et .", sentence9.toStems())
    }
    
    func testPredicateCandidates(){
        let framesetList = FramesetList()
        XCTAssertEqual(1, sentence0.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(1, sentence1.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(0, sentence2.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(2, sentence3.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(1, sentence4.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(0, sentence5.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(0, sentence6.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(1, sentence7.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(1, sentence8.predicateCandidates(framesetList: framesetList).count)
        XCTAssertEqual(2, sentence9.predicateCandidates(framesetList: framesetList).count)
    }

    static var allTests = [
        ("testExample1", testGetShallowParseGroups),
        ("testExample2", testContainsPredicate),
        ("testExample3", testGetPredicate),
        ("testExample4", testToStems),
    ]
}
