import Foundation

public protocol URLSessionDataTasker {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

public extension URLSessionDataTasker {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}
