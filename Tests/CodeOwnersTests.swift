//
//  CodeOwnersTests.swift
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

@testable import CodeOwners
import Foundation
import Testing

struct CodeOwnersTests {

    @Test
    func owners() throws {
        let owners = try CodeOwners(fileNamed: "Samples/CODEOWNERS")

        #expect(
            owners.owners(for: URL(fileURLWithPath: "/Packages/test")) == [
                "@fish"
            ]
        )
        #expect(
            owners.owners(for: URL(fileURLWithPath: "/Packages/reef")) == [
                "@nemo"
            ]
        )
        #expect(
            owners.owners(for: URL(fileURLWithPath: "/Coral Reef/chips")) == [
                "@anemone"
            ]
        )
        #expect(
            owners.owners(for: URL(fileURLWithPath: "/Fish/food/Chips/sea.swift")) == [
                "@shrimp", "@sea-horse"
            ]
        )
        #expect(
            owners.owners(for: URL(fileURLWithPath: "/Fish/food/Chips/sea.cs")) == []
        )
    }
}



extension CodeOwners {

    init(fileNamed name: String, bundle: Bundle = .module, base: URL = URL(fileURLWithPath: "/")) throws {
        guard let path = bundle.url(forResource: name, withExtension: nil) else {
            throw ParseError("file not found")
        }
        try self.init(file: path, base: base)
    }
}

extension CodeOwners.Owner: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
