public extension Network {
    enum Errors: Error, Equatable {
        case decode
        case invalidURL(urlString: String)
        case noResponse
        case unauthorized
        case unexpectedStatusCode(statusCode: Int)
        case unknown(description: String)
        case forbidden
        case badRequest
        case noConnection
        
        public var description: String {
            switch self {
            case .decode:
                return "Decode error"
            case let .invalidURL(urlString):
                return "Invalid URL: \(urlString)"
            case .noResponse:
                return "No Response"
            case .unauthorized:
                return "Unauthorized"
            case let .unexpectedStatusCode(statusCode):
                return "Unexpected Status Code: \(statusCode)"
            case let .unknown(description):
                return "Unexpected Error: \(description)"
            case .forbidden:
                return "Forbidden"
            case .badRequest:
                return "Bad Request"
            case .noConnection:
                return "No Connection"
            }
        }
        
    }
}
