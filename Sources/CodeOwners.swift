//
//  CodeOwners.swift
//  swift-codeowners
//
//  Created by Simon Whitty on 07/11/2024.
//  Copyright 2024 Simon Whitty
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/swhitty/swift-codeowners
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Glob

public struct CodeOwners {
    public var base: URL
    public var entries: [Entry]

    public struct Entry {
        public var pattern: String
        public var owners: [Owner]
        var glob: Glob.Pattern

        public init(pattern: String, owners: [Owner]) throws {
            self.pattern = pattern
            self.owners = owners
            self.glob = try .init(pattern)
        }
    }

    public struct Owner: RawRepresentable, Hashable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public init(base: URL, entries: [Entry]) {
        self.base = base
        self.entries = entries
    }

    public init(data: Data, base: URL = URL(filePath: "/")) throws {
        guard base.hasDirectoryPath else {
            throw ParseError("base url must be a directory")
        }
        guard let text = String(data: data, encoding: .utf8) else {
            throw ParseError("invalid data")
        }
        try self.init(
            base: base.standardizedFileURL,
            entries: text.components(separatedBy: "\n").compactMap(Entry.make)
        )
    }

    public init(file: URL, base: URL? = nil) throws {
        try self.init(
            data: Data(contentsOf: file),
            base: base ?? file.deletingLastPathComponent()
        )
    }

    public func entry(for file: URL) -> Entry? {
        guard let relativePath = relativePath(for: file) else {
            return nil
        }
        return entries.last {
            $0 ~= relativePath
        }
    }

    public func owners(for file: URL) -> Set<Owner> {
        guard let entry = entry(for: file) else {
            return []
        }
        return Set(entry.owners)
    }

    func relativePath(for file: URL) -> String? {
        let path = file.path(percentEncoded: false)
        let basePath = base.path(percentEncoded: false)
        guard path.hasPrefix(basePath) else {
            return nil
        }
        return String(path.dropFirst(basePath.count))
    }
}

extension CodeOwners.Entry: CustomStringConvertible {
    public var description: String {
        ([pattern] + owners.map(\.rawValue)).joined(separator: " ")
    }
}

extension CodeOwners.Entry {

    static func ~= (entry: CodeOwners.Entry, file: String) -> Bool {
        entry.glob.match(file)
    }
}

extension CodeOwners.Entry {

    static func make(from line: some StringProtocol) throws -> Self? {
        let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if line.isEmpty || line.starts(with: "#") || line.starts(with: "[") {
            return nil
        }

        let scanner = Scanner(string: line)
        let pattern = try scanner.scanPattern()
        return try CodeOwners.Entry(
            pattern: pattern,
            owners: scanner.scanOwners()
        )
    }
}

extension Scanner {

    func scanPattern() throws -> String {
        let idx = currentIndex
        do {
            if scanString("\"") != nil {
                if let pattern = scanUpToString("\""), scanString("\"") != nil {
                    return pattern
                } else {
                    throw ParseError("expected string")
                }
            } else if let pattern = scanUpToString(" ") {
                return pattern
            } else {
                throw ParseError("expected string")
            }
        } catch {
            currentIndex = idx
            throw error
        }
    }

    func scanWord() -> String? {
        scanCharacters(from: CharacterSet.whitespacesAndNewlines.inverted)
    }

    func scanOwners() -> [CodeOwners.Owner] {
        var owners = [CodeOwners.Owner]()
        while let word = scanWord() {
            owners.append(.init(rawValue: word))
        }
        return owners
    }
}

struct ParseError: LocalizedError {
    var errorDescription: String

    init(_ message: String) {
        self.errorDescription = message
    }
}
