//
//  SseAuthenticator.swift
//  Split
//
//  Created by Javier L. Avrudsky on 07/08/2020.
//  Copyright © 2020 Split. All rights reserved.
//

import Foundation

struct SseAuthToken: Decodable {
    let issuedAt: Int
    let expirationTime: Int
    let channels: String

    enum CodingKeys: String, CodingKey {
        case issuedAt = "iat"
        case expirationTime = "exp"
        case channels = "x-ably-capability"
    }
}

struct JwtToken {
    let issuedAt: Int
    let expirationTime: Int
    let channels: [String]
    let rawToken: String
}

struct SseAuthenticationResult {
    let success: Bool
    let errorIsRecoverable: Bool
    let pushEnabled: Bool
    let jwtToken: JwtToken?
}

protocol SseAuthenticator {
    func authenticate(userKey: String) -> SseAuthenticationResult
}

class DefaultSseAuthenticator: SseAuthenticator {

    private let restClient: RestClientSseAuthenticator
    private let jwtParser: JwtTokenParser

    init(restClient: RestClientSseAuthenticator,
         jwtParser: JwtTokenParser) {
        self.restClient = restClient
        self.jwtParser = jwtParser
    }

    func authenticate(userKey: String) -> SseAuthenticationResult {
        let semaphore = DispatchSemaphore(value: 0)
        var requestResult: DataResult<SseAuthenticationResponse>?
        let jwtToken: JwtToken

        restClient.authenticate(userKey: userKey) { result in
            requestResult = result
            semaphore.signal()
        }
        semaphore.wait()

        let response: SseAuthenticationResponse
        do {
            if let resp = try requestResult?.unwrap() {
                response = resp
            } else {
                return errorResult(recoverable: true)
            }
            jwtToken = try jwtParser.parse(raw: response.token)
        } catch HttpError.authenticationFailed {
            return errorResult(recoverable: false)
        } catch {
            return errorResult(recoverable: true)
        }
        return SseAuthenticationResult(success: true, errorIsRecoverable: false,
                                       pushEnabled: response.pushEnabled, jwtToken: jwtToken)
    }
}

// MARK: Private
extension DefaultSseAuthenticator {
    private func errorResult(recoverable: Bool) -> SseAuthenticationResult {
        return SseAuthenticationResult(success: false, errorIsRecoverable: recoverable,
                                       pushEnabled: false, jwtToken: nil)
    }
}
