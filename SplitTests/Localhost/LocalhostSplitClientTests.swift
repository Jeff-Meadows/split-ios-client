//
//  LocalhostSplitClientTests.swift
//  SplitTests
//
//  Created by Javier L. Avrudsky on 15/02/2019.
//  Copyright © 2019 Split. All rights reserved.
//

import XCTest
@testable import Split


class LocalhostSplitClientTests: XCTestCase {

    var client: SplitClient!
    var eventsManager: SplitEventsManager!
    
    override func setUp() {
        eventsManager = SplitEventsManagerMock()
        let fileName = "localhost.splits"
        let storage = FileStorageStub()
        var config = YamlSplitStorageConfig()
        config.refreshInterval = 0
        let splitsStorage = LocalhostSplitsStorage(fileStorage: storage, config: config,
                                              eventsManager: eventsManager, dataFolderName: "localhost", splitsFileName: fileName,
                                                      bundle: Bundle(for: type(of: self)))
        splitsStorage.loadLocal()
        client = LocalhostSplitClient(key: Key(matchingKey: "thekey"), splitsStorage: splitsStorage, eventsManager: eventsManager)
    }
    
    override func tearDown() {
    }
    
    func testRightSplitsFileTreatment() {
        for i in 1...5 {
            XCTAssertEqual(client.getTreatment("s\(i)"), "t\(i)")
        }
    }
    
    func testRightSplitsFileTreatments() {
        let splitsCount = 5
        var splits = [String]()
        for i in 1...splitsCount {
            splits.append("s\(i)")
        }
        let treatments = client.getTreatments(splits: splits, attributes: nil)
        for i in 1...splitsCount {
            XCTAssertEqual(treatments["s\(i)"], "t\(i)")
        }
    }
    
    func testNonExistingSplitsTreatment() {
        for i in 1...5 {
            XCTAssertEqual(client.getTreatment("j\(i)"), SplitConstants.control)
        }
    }
    
    func testNonExistingSplitsTreatments() {
        let splitsCount = 5
        var splits = [String]()
        for i in 1...splitsCount {
            splits.append("s\(i + 1000)")
        }
        let treatments = client.getTreatments(splits: splits, attributes: nil)
        for i in 1...splitsCount {
            XCTAssertEqual(treatments["s\(i + 1000)"], SplitConstants.control)
        }
    }

}
