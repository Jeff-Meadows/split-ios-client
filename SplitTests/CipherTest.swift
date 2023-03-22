//
//  CipherTest.swift
//  SplitTests
//
//  Created by Javier Avrudsky on 07-Mar-2023.
//  Copyright © 2023 Split. All rights reserved.
//

import Foundation
@testable import Split

import XCTest
@testable import Split

class CipherTest: XCTestCase {

    func testBasicEncryptDecrypt() {
        encryptDecryptTest(originalText: "javier", key: String(repeating: "k", count: 32))
    }

    func testJsonSplitEncryptDecrypt() {
        let text = TestDataHelper.jsonSplitSample
        encryptDecryptTest(originalText: text)
    }

    func testMySegmentsEncryptDecrypt() {
        let text = "segment1, segment2, segment_4, segment%5, segment-6, segment!7, segment#8, segment@9, segment_what"
        encryptDecryptTest(originalText: text)
    }
    func testImpressionEncryptDecrypt() {
        let text = TestDataHelper.jsonImpressionSample
        encryptDecryptTest(originalText: text)
    }

    func testEventEncryptDecrypt() {
        let text = TestDataHelper.jsonEventSample
        encryptDecryptTest(originalText: text)
    }

    func testVeryLongTextEncryptDecrypt() {

        let text = TestDataHelper.veryLongText
        encryptDecryptTest(originalText: text)
    }

    private func encryptDecryptTest(originalText: String, key: String = String(UUID().uuidString.prefix(16))) {
        let cipher = DefaultCipher(key: key)
        let encrypted = cipher.encrypt(originalText)
        let decrypted = cipher.decrypt(encrypted)

        XCTAssertNotEqual(originalText, encrypted)
        XCTAssertEqual(originalText, decrypted)
    }

    override func tearDown() {
    }
}

