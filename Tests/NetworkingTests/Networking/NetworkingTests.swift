import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var jsonEncoderMock: JSONEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    override func setUp() {
        urlSessionMock = .init()
        jsonEncoderMock = .init()
        jsonDecoderMock = .init()
        super.setUp()
    }
    
    override func tearDown() {
        urlSessionMock = .none
        jsonEncoderMock = .none
        jsonDecoderMock = .none
        super.tearDown()
    }

    func testInitWithAllValues() throws {
        let body = "Encode"
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: body
        )
        
        XCTAssertEqual(sut.url, validURL)
        XCTAssertEqual(sut.method, .post)
        XCTAssertEqual(sut.headers, .headersString)
        XCTAssertEqual(sut.body as? String, body)
    }
    
    func testInitWithOnlyRequired() throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post
        )
        
        XCTAssertEqual(sut.url, validURL)
        XCTAssertEqual(sut.method, .post)
        XCTAssertNil(sut.headers)
        XCTAssertNil(sut.body)
    }
    
    func testRunWithAllValues() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 200, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        let object: TestData = try await sut.run(
            urlSession: urlSessionMock,
            encoder: jsonEncoderMock,
            decoder: jsonDecoderMock
        )
        
        XCTAssertNil(urlSessionMock.delegateSent)
        XCTAssertEqual(urlSessionMock.requestSent?.httpMethod, "POST")
        let httpBody = try XCTUnwrap(urlSessionMock.requestSent?.httpBody)
        let httpBodyDecoded = try XCTUnwrap(JSONDecoder().decode(String.self, from: httpBody))
        XCTAssertEqual(httpBodyDecoded, String.validJSONBodyString)
        XCTAssertEqual(urlSessionMock.requestSent?.timeoutInterval, 60)
        XCTAssertEqual(urlSessionMock.requestSent?.allHTTPHeaderFields, ["Key": "Value"])
        XCTAssertEqual(object, .init())
    }
    
    func testRunWithDecodeError() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let data = try JSONEncoder().encode([1])
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 200, httpVersion: .none, headerFields: .none))
        
        jsonDecoderMock.shouldThrow = Errors.fake
        
        urlSessionMock.result = (
            data,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("Should throw decoding error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .decode)
        }
    }
    
    func testRunUnauthorized() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 401, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown unauthorized error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .unauthorized)
        }
    }
    
    func testRunForbidden() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 403, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown forbidden error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .forbidden)
        }
    }
    
    func testRunBadRequest() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 400, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown badRequest error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .badRequest)
        }
    }
    
    func testRunNoConnection() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 500, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown noConnection error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .noConnection)
        }
    }
    
    func testRunWhenResponseIsNotHTTPURLResponse() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        
        urlSessionMock.result = (
            validBodyString,
            URLResponse()
        )
        
        do {
            let _: TestData = try await sut.run<String>(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown noResponse error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .noResponse)
        }
    }
    
    func testRunUnexpectedStatusCode() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 900, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            let _: TestData = try await sut.run<String>(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown unexpectedStatusCode(900) error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .unexpectedStatusCode(statusCode: 900))
        }
    }
    
    func testRunWithAllValuesWithoutReturn() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 200, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        try await sut.run(
            urlSession: urlSessionMock,
            encoder: jsonEncoderMock,
            decoder: jsonDecoderMock
        )
        
        XCTAssertNil(urlSessionMock.delegateSent)
        XCTAssertEqual(urlSessionMock.requestSent?.httpMethod, Networking.Method.post.rawValue)
        let httpBody = try XCTUnwrap(urlSessionMock.requestSent?.httpBody)
        let httpBodyDecoded = try XCTUnwrap(JSONDecoder().decode(String.self, from: httpBody))
        XCTAssertEqual(httpBodyDecoded, String.validJSONBodyString)
        XCTAssertEqual(urlSessionMock.requestSent?.timeoutInterval, 60)
        XCTAssertEqual(urlSessionMock.requestSent?.allHTTPHeaderFields, ["Key": "Value"])
    }
    
    func testRunWithNoResponseWithoutReturn() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let data = try JSONEncoder().encode([1])
        
        jsonDecoderMock.shouldThrow = Errors.fake
        
        urlSessionMock.result = (data, URLResponse())
        
        do {
            try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown noResponse error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .noResponse)
        }
    }
    
    func testRunUnauthorizedWithoutReturn() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 401, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            try await sut.run(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown unauthorized error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .unauthorized)
        }
    }
    
    func testRunUnexpectedStatusCodeWithoutReturn() async throws {
        let validURL = try XCTUnwrap(URL.validURL)
        
        let sut: Networking.Request = try .init(
            url: validURL,
            method: .post,
            headers: .headersString,
            body: String.validJSONBodyString
        )
        
        let validBodyString = try XCTUnwrap(String.validJSONBodyString.data(using: .utf8))
        let httpResponse = try XCTUnwrap(HTTPURLResponse(url: validURL, statusCode: 900, httpVersion: .none, headerFields: .none))
        
        urlSessionMock.result = (
            validBodyString,
            httpResponse
        )
        
        do {
            try await sut.run<String>(
                urlSession: urlSessionMock,
                encoder: jsonEncoderMock,
                decoder: jsonDecoderMock
            )
            XCTFail("It should have thrown error")
        } catch {
            XCTAssertEqual(error as? Networking.Errors, .unexpectedStatusCode(statusCode: 900))
        }
    }
}

private extension String {
    static var validJSONBodyString: String {
        NetworkingTests.TestData.jsonString
    }
    
    static var messageName: String {
        "Hello World!"
    }
    
    static var authorName: String {
        "John Doe"
    }
}

private extension URL {
    static var validURL: URL? {
        .init(string: "www.google.com")
    }
}

private extension Dictionary where Key == String, Value == String {
    static var headersString: [String: String] {
        ["Key": "Value"]
    }
}

private extension NetworkingTests {
    
    struct TestData: Codable, Equatable {

        let message: String
        let author: String
        
        init(
            message: String = .messageName,
            author: String = .authorName
        ) {
            self.message = message
            self.author = author
        }
        
        static var jsonString =
"""
{
  "message": "\(String.messageName)",
  "author": "\(String.authorName)"
}
"""
    }
    
    enum Errors: Error {
        case fake
    }
    
    final class URLSessionMock: URLSessionDataTasker {
        
        private(set) var requestSent: URLRequest?
        private(set) var delegateSent: URLSessionDelegate?
        
        var result: (Data, URLResponse)!
        var shouldThrow: Error?
        
        func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
            requestSent = request
            delegateSent = delegate
            if let shouldThrow {
                throw shouldThrow
            }
            return result
        }
    }
    
    final class JSONEncoderMock: JSONEncoder {
        
        private(set) var wasEncodedCalled = false
        var shouldThrow: Error?
    
        override func encode<T>(_ value: T) throws -> Data where T: Encodable {
            wasEncodedCalled = true
            
            if let shouldThrow {
                throw shouldThrow
            }
            
            return try super.encode(value)
        }
    }
    
    final class JSONDecoderMock: JSONDecoder {
        
        private(set) var wasDecodedCalled = false
        var shouldThrow: Error?
    
        override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
            wasDecodedCalled = true
            
            if let shouldThrow {
                throw shouldThrow
            }
            
            return try super.decode(type, from: data)
        }
    }
}
