//
//  APIClient.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// Generic request surface every networked feature goes through. Features never build a
/// `URLRequest` directly — they call an endpoint method that delegates to one of these.
protocol APIClient {
    func get<Response: Decodable>(_ endpoint: String) async throws -> Response
    func post<Body: Encodable, Response: Decodable>(_ endpoint: String, body: Body) async throws -> Response
    func delete(_ endpoint: String) async throws
}

/// Typed error surfaced from the networking layer to the UI.
struct ErrorResponse: Error, Decodable {
    let message: String
    let code: Int?

    var userMessage: String { message }
}

enum NetworkError: Error {
    case invalidURL
    case unauthorized
    case decodingFailed
    case server(ErrorResponse)
    case unknown
}
