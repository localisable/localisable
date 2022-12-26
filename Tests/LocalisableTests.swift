import XCTest
@testable import Localisable

final class LocalisableTests: XCTestCase {
    private var url: URL!
    private var english: URL!
    
    override func setUp() {
        let temporal = URL(filePath: NSTemporaryDirectory(), directoryHint: .isDirectory)
        url = temporal.appending(path: "tests", directoryHint: .isDirectory)
        
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "Base", withExtension: "strings")!)
        
        let base = url.appending(path: "en.lproj", directoryHint: .isDirectory);
        try! FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        
        english = base.appending(path: "Localizable.strings", directoryHint: .notDirectory)
        
        try! data.write(to: english)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
    }
    
    func testEnglish() {
        let expected = load(url: Bundle.module.url(forResource: "English",
                                                   withExtension: "strings")!)
        let result = load(url: english)
        XCTAssertEqual(result, expected)
    }
    
    private func load(url: URL) -> String {
        try! .init(decoding: Data(contentsOf: url), as: UTF8.self)
    }
}
