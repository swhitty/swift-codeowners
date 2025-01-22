[![Build](https://github.com/swhitty/swift-codeowners/actions/workflows/build.yml/badge.svg)](https://github.com/swhitty/swift-codeowners/actions/workflows/build.yml)
[![Codecov](https://codecov.io/gh/swhitty/swift-codeowners/graphs/badge.svg)](https://codecov.io/gh/swhitty/swift-codeowners)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20Mac%20|%20tvOS%20|%20Linux%20)](https://github.com/swhitty/swift-codeowners/blob/main/Package.swift)
[![Swift 6.0](https://img.shields.io/badge/swift-6.0-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# Introduction

**CodeOwners** is a lightweight parser of CODEOWNERS files writted in Swift.

# Installation

CodeOwners can be installed by using Swift Package Manager.

 **Note:** CodeOwners requires Swift 6.0 on Xcode 16+. It runs on iOS 16+, tvOS 16+, macOS 13+ and Linux.
To install using Swift Package Manager, add this to the `dependencies:` section in your Package.swift file:

```swift
.package(url: "https://github.com/swhitty/swift-codeowners.git", .upToNextMajor(from: "0.1.0"))
```

# Usage

Parse the CODEOWNERS file within a repo:

```swift
let co = try CodeOwners(file: URL(filePath: "/code/repo/CODEOWNERS"))
```

Retrieve the owners for a specific file URL:

```swift
let owners = co.owners(for: URL(filePath: "/code/repo/Sources/main.swift"))
```

# Credits

CodeOwners is primarily the work of [Simon Whitty](https://github.com/swhitty).

Much of the heavy lifting is by the excellent [swift-glob](https://github.com/davbeck/swift-glob) package by [David Beck](https://github.com/davbeck).

([Full list of contributors](https://github.com/swhitty/IdentifiableContinuation/graphs/contributors))
