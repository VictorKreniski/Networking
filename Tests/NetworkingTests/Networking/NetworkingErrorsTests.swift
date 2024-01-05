import XCTest
@testable import Networking

final class NetworkingErrorsTests: XCTestCase {
    
    func testDecodeErrorDescription() {
        XCTAssertEqual(Networking.Errors.decode.description, "Decode error")
    }
    
    func testInvalidURLExceptionDescription() {
        XCTAssertEqual(Networking.Errors.invalidURL(urlString: "www.google.com").description, "Invalid URL: www.google.com")
    }
    
    func testNoResponseErrorDescription() {
        XCTAssertEqual(Networking.Errors.noResponse.description, "No Response")
    }
    
    func testUnauthorizedErrorDescription() {
        XCTAssertEqual(Networking.Errors.unauthorized.description, "Unauthorized")
    }
    
    func testUnexpectedStatusCodeErrorDescription() {
        XCTAssertEqual(Networking.Errors.unexpectedStatusCode(statusCode: 1).description, "Unexpected Status Code: 1")
    }
    
    func testUnknownErrorDescription() {
        XCTAssertEqual(Networking.Errors.unknown(description: "Something different").description, "Unexpected Error: Something different")
    }
    
    func testForbiddenErrorDescription() {
        XCTAssertEqual(Networking.Errors.forbidden.description, "Forbidden")
    }
    
    func testBadRequestErrorDescription() {
        XCTAssertEqual(Networking.Errors.badRequest.description, "Bad Request")
    }
    
    func testNoConnectionErrorDescription() {
        XCTAssertEqual(Networking.Errors.noConnection.description, "No Connection")
    }
}
