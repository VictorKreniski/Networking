import Foundation

public extension Network {
    struct Request {
        public let url: URL
        public let method: Method
        public let headers: Headers?
        public let body: Encodable?
        
        public init(
            url: URL,
            method: Method,
            headers: [String: String]? = nil,
            body: Encodable? = nil
        ) throws {
            self.url = url
            self.method = method
            self.headers = headers
            self.body = body
        }
        
        public func run<T: Decodable>(
            urlSession: URLSessionDataTasker = URLSession.shared,
            encoder: JSONEncoder = .init(),
            decoder: JSONDecoder = .init()
        ) async throws -> T {
            
            let request = try createRequest(encoder: encoder)
            
            let (data, response) = try await urlSession.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw Errors.noResponse
            }
            
            try check(statusCode: response.statusCode)
            
            guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                throw Errors.decode
            }
            
            return decodedResponse
        }
        
        public func run(
            urlSession: URLSessionDataTasker = URLSession.shared,
            encoder: JSONEncoder = .init(),
            decoder: JSONDecoder = .init()
        ) async throws {

            let request = try createRequest(encoder: encoder)
            
            let (_, response) = try await urlSession.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw Errors.noResponse
            }
            
            try check(statusCode: response.statusCode)
        }
    }
}

private extension Network.Request {
    func createRequest(encoder: JSONEncoder) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            let data = try encoder.encode(body)
            request.httpBody = data
        }
        
        return request
    }
    
    func check(statusCode: Int) throws  {
        switch statusCode {
        case 200...299:
            break
        case 401:
            throw Network.Errors.unauthorized
        case 403:
            throw Network.Errors.forbidden
        case 400...499:
            throw Network.Errors.badRequest
        case 500...599:
            throw Network.Errors.noConnection
        default:
            throw Network.Errors.unexpectedStatusCode(statusCode: statusCode)
        }
    }
}
