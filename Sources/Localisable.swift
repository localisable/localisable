import Foundation

struct Localisable {
    static func localise(path: String) {
        let url = URL(filePath: path, directoryHint: .isDirectory)
        let english = Self(url: url.appending(path: "en.lproj/Localizable.strings", directoryHint: .notDirectory))
    }
    
    private let url: URL
    
    private init(url: URL) {
        self.url = url
        let file = try! String(decoding: Data(contentsOf: url), as: UTF8.self)
    }
}

private extension String {
    var lines: [[Self]] {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter {
                !$0.isEmpty
            }
            .filter {
                $0.first != "/"
            }
            .map {
                $0.components(separatedBy: ".")
            }
    }
}

//print("Updated enum and suffix!")
/*public struct Localisable {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}


private final class Translations {
    private var keys = Set<String>()
    private let strings: [String : String]
    private static let directory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    private static let strings = directory.appendingPathComponent("Client/Ecosia/L10N/en.lproj/Ecosia.strings")
    private static let keys = directory.appendingPathComponent("Client/Ecosia/L10N/String.swift")

    init() {
        strings = Translations.strings.asLines.filter {
            $0.hasPrefix("\"")
        }.reduce(into: [:]) {
            let equals = $1.components(separatedBy: "\" = \"")
            let key = String(equals.first!.dropFirst())
            let value = String(equals.last!.dropLast(2))
            if $0[key] == nil {
                $0[key] = value
            } else {
                print("repeated \(key)")
            }
        }
        
        keys = Translations.keys.asLines.filter {
            $0.hasPrefix("case")
        }.reduce(into: []) {
            let equals = $1.components(separatedBy: " = \"")
            $0.insert(.init(equals.last!.dropLast()))
        }
    }
    
    func save() {
        let filtered = strings.filter { keys.contains($0.0) }.keys.sorted()
        let result = filtered.reduce(into: "") {
            $0 += "\"" + $1 + "\" = \"" + strings[$1]! + "\";\n"
        }
        
        try! Data(result.utf8).write(to: Translations.strings, options: .atomic)
        
        print("Read: \(strings.count); wrote: \(filtered.count) translations!")
    }
}

private extension URL {
    var asLines: [String] {
        content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    var content: String {
        try! String(data: .init(contentsOf: self), encoding: .utf8)!
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

Translations().save()




private final class Translations {
    private var count = [String : Int]()
    private let dictionary: [String : String]
    private static let directory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    private static let url = directory.appendingPathComponent("Client/Ecosia/L10N/String.swift")
    
    init() {
        dictionary = Translations.url.asLines.filter {
            $0.hasPrefix("case")
        }.reduce(into: [:]) {
            let equals = $1.components(separatedBy: " = \"")
            $0[.init(equals.first!.dropFirst(5))] = .init(equals.last!.dropLast())
        }
    }
    
    func validate() {
        count = dictionary.mapValues { _ in 0 }
        FileManager.default.enumerator(at: Translations.directory, includingPropertiesForKeys: nil, options: [.producesRelativePathURLs, .skipsHiddenFiles, .skipsPackageDescendants])?.forEach {
            let url = $0 as! URL
            guard !url.hasDirectoryPath, url.relativePath.hasSuffix(".swift") else { return }
            Translations.directory.appendingPathComponent(url.relativePath).content
                .components(separatedBy: ".localized(")
                .dropFirst().forEach {
                    count[$0.components(separatedBy: ")").first!.replacingOccurrences(of: ".", with: "")]? += 1
            }
        }
        let unused = count.filter { $0.1 == 0 }.keys.sorted()
        print("Unused keys: (\(unused.count))")
        unused.forEach {
            print($0)
        }
    }
}

private extension URL {
    var asLines: [String] {
        content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    var content: String {
        try! String(data: .init(contentsOf: self), encoding: .utf8)!
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

Translations().validate()






import Foundation

private let directory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
private let def = directory.appending(path: "Sources/Tld.swift", directoryHint: .notDirectory)
private let suffix = directory.appending(path: "Sources/Tld.Suffix.swift", directoryHint: .notDirectory)
private let dat = directory.appending(path: "Resources/Tld.public_suffix_list.dat", directoryHint: .notDirectory)

let result = Parser
    .parse(content: String(decoding: try! Data(contentsOf: dat), as: UTF8.self))
try! Data(result
        .enum
        .utf8)
    .write(to: def, options: .atomic)
try! Data(result
        .suffix
        .utf8)
    .write(to: suffix, options: .atomic)

print("Updated enum and suffix!")



import Foundation

enum Parser {
    static func parse(content: String) -> (enum: String, suffix: String) {
        {
            ($0.set.serial, $0.dictionary.serial)
        } (content
            .lines
            .reduce(into: (set: Set<String>(), dictionary: [String : Any]())) { result, components in
                components
                    .filter {
                        $0 != "*"
                    }
                    .map {
                        $0.first == "!"
                            ? .init($0.dropFirst())
                            : $0
                    }
                    .filter {
                        !result
                            .set
                            .contains($0)
                    }
                    .forEach {
                        result
                            .set
                            .insert($0)
                    }
                result
                    .dictionary
                    .chain(components: components)
            })
    }
}

private extension String {
    var lines: [[Self]] {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter {
                !$0.isEmpty
            }
            .filter {
                $0.first != "/"
            }
            .map {
                $0.components(separatedBy: ".")
            }
    }
    
    var safe: Self {
        switch self {
        case "as", "case", "do", "static", "for", "if", "in", "is", "public":
            return "_" + self
        default:
            return {
                $0
                    .first?
                    .isNumber == true
                        ? "_" + $0
                        : $0
            } (self.replacingOccurrences(of: "-", with: "_"))
        }
    }
    
    var print: Self {
        safe == self
        ? self
        : safe + " = \"\(self)\""
    }
}

private extension Set where Element == String {
    var serial: String {
        """
import Foundation
public enum Tld: String {
    case
    \(sorted()
        .map(\.print)
        .joined(separator: """
,
    \
"""))
}
"""
    }
    
    func wildcard(level: Int) -> String {
        """
.wildcard(.init([
\(sorted()
    .map {
        level.indent + $0.safe
    }
    .joined(separator: """
,
"""))]))
"""
    }
}

private extension Dictionary where Key == String, Value == Any {
    var serial: String {
        """
import Foundation
extension Tld {
    public static let suffix: [Tld : Mode] = [
\(listed(level: 1))]
}
"""
    }
    
    mutating func chain(components: [String]) {
        components
            .last
            .map { key in
                { remain in
                    self[key] = remain.isEmpty
                        ? self[key] == nil
                            ? ".end"
                            : self[key]
                        : { next in
                            switch next {
                            case "*":
                                return self[key]
                                    .flatMap {
                                        $0 as? Set<String>
                                    } ?? .init()
                            default:
                                return next.first == "!"
                                ? (self[key]
                                    .flatMap {
                                        $0 as? Set<String>
                                    } ?? .init())
                                    .map {
                                        var exceptions = $0
                                        exceptions.insert(.init(next.dropFirst()))
                                        return exceptions
                                    }
                                : (self[key]
                                    .flatMap {
                                        $0 as? Self
                                    } ?? .init())
                                    .map {
                                        var previous = $0
                                        previous.chain(components: .init(remain))
                                        return previous as Any
                                    }
                                    ?? self[key]
                            }
                        } (remain.last!)
                } (components.dropLast())
            }
    }
    
    func previous(level: Int) -> String {
        """
.previous([
\(listed(level: level + 1))])
"""
    }
    
    private func listed(level: Int) -> String {
        """
\(sorted {
    $0.0 < $1.0
}
.destructure(level: level)
.joined(separator: """
,
"""))
"""
    }
}

private extension Array where Element == (key: String, value: Any) {
    func destructure(level: Int) -> [String] {
        map { (key: String, value: Any) in
            level.indent + key.safe + " : " + destructure(level: level, value: value)
        }
    }
    
    private func destructure(level: Int, value: Any) -> String {
        switch value {
        case let dictionary as [String : Any]:
            return dictionary
                .previous(level: level)
        case let set as Set<String>:
            return set
                .wildcard(level: level + 1)
        default:
            return value as! String
        }
    }
}

private extension Int {
    var indent: String {
        (0 ... self)
            .flatMap { _ in
                "    "
            } + "."
    }
}
*/
