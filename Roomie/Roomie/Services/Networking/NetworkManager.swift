//
//  NetworkManager.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// The single HTTP client for the app. Every request routes through `perform`, which injects
/// the `Bearer` token and, on a `401`, refreshes auth once and retries. Decoding happens off
/// the main actor via a shared decoder.
///
/// The app currently runs on `MockDataService`; this is the seam a `LiveDataService` will build
/// on once the Roomie REST API is live.
final class NetworkManager: APIClient {
    static let shared = NetworkManager()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        session = URLSession(configuration: .default)
        decoder = NetworkManager.makeDecoder()
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - APIClient

    func get<Response: Decodable>(_ endpoint: String) async throws -> Response {
        try await perform(request(for: endpoint, method: "GET"))
    }

    func post<Body: Encodable, Response: Decodable>(_ endpoint: String, body: Body) async throws -> Response {
        var req = try request(for: endpoint, method: "POST")
        req.httpBody = try encoder.encode(body)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await perform(req)
    }

    func delete(_ endpoint: String) async throws {
        let _: EmptyResponse = try await perform(request(for: endpoint, method: "DELETE"))
    }

    // MARK: - Private

    private func constructURL(endpoint: String) throws -> URL {
        guard let url = URL(string: Keys.apiBaseURL + endpoint) else { throw NetworkError.invalidURL }
        return url
    }

    private func request(for endpoint: String, method: String) throws -> URLRequest {
        var req = try URLRequest(url: constructURL(endpoint: endpoint))
        req.httpMethod = method
        return req
    }

    /// Executes a request, injecting auth and retrying once after a token refresh on `401`.
    private func perform<Response: Decodable>(_ request: URLRequest, isRetry: Bool = false) async throws -> Response {
        var request = request
        if let token = AuthManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.unknown }

        if http.statusCode == 401, !isRetry {
            try await AuthManager.shared.refresh()
            return try await perform(request, isRetry: true)
        }

        guard (200..<300).contains(http.statusCode) else {
            if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                throw NetworkError.server(error)
            }
            throw NetworkError.unknown
        }

        return try decode(data)
    }

    /// JSON decoding kept `nonisolated` so it runs off the main actor; builds its own decoder
    /// to avoid touching main-actor state.
    private nonisolated func decode<Response: Decodable>(_ data: Data) throws -> Response {
        if Response.self == EmptyResponse.self { return EmptyResponse() as! Response }
        do { return try Self.makeDecoder().decode(Response.self, from: data) }
        catch { throw NetworkError.decodingFailed }
    }

    nonisolated static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

/// Placeholder for endpoints that return no body.
struct EmptyResponse: Decodable {}
