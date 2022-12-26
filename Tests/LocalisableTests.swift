import XCTest
@testable import Localisable

final class LocalisableTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        let temporal = URL(filePath: NSTemporaryDirectory(), directoryHint: .isDirectory)
        url = temporal.appending(path: "tests", directoryHint: .isDirectory)
        
        let data = try! Data(contentsOf: Bundle.module.url(forResource: "Localizable", withExtension: "strings")!)
        
        let base = url.appending(path: "en.lproj", directoryHint: .isDirectory);
        try! FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        
        try! data.write(to: base.appending(path: "Localizable.strings", directoryHint: .notDirectory))
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
    }
    
    func testParse() {
        XCTAssertEqual([], Localisable.localise(path: url.path()))
    }
}

