//
//  KeyValueStorage.swift
//  Split
//
//  Created by Javier L. Avrudsky on 03/29/2021.
//  Copyright © 2021 Split. All rights reserved.
//
import Foundation

enum SecureItem {
    case backgroundSyncSchedule
    case dbEncryptionLevel(String)

    func toString() -> String {
        switch self {
        case .backgroundSyncSchedule:
            return "bgSyncSchedule"
        case .dbEncryptionLevel(let apiKey):
            return "dbEncryptionLevel_\(apiKey)"
        }
    }
}

protocol KeyValueStorage {
    func set<T: Encodable>(item: T, for key: SecureItem)
    func getInt(item: SecureItem) -> Int?
    func get<T: Decodable>(item: SecureItem, type: T.Type) -> T?
    func remove(item: SecureItem)
    func set(item: String, for key: SecureItem)
    func set(item: Int, for key: SecureItem)
}
