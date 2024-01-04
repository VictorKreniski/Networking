import XCTest
@testable import Network

final class NetworkErrorsTests: XCTestCase {
    
    func testDecodeErrorDescription() {
        XCTAssertEqual(Network.Errors.decode.description, "Decode error")
    }
    
    func testInvalidURLExceptionDescription() {
        XCTAssertEqual(Network.Errors.invalidURL(urlString: "www.google.com").description, "Invalid URL: www.google.com")
    }
    
    func testNoResponseErrorDescription() {
        XCTAssertEqual(Network.Errors.noResponse.description, "No Response")
    }
    
    func testUnauthorizedErrorDescription() {
        XCTAssertEqual(Network.Errors.unauthorized.description, "Unauthorized")
    }
    
    func testUnexpectedStatusCodeErrorDescription() {
        XCTAssertEqual(Network.Errors.unexpectedStatusCode(statusCode: 1).description, "Unexpected Status Code: 1")
    }
    
    func testUnknownErrorDescription() {
        XCTAssertEqual(Network.Errors.unknown(description: "Something different").description, "Unexpected Error: Something different")
    }
    
    func testForbiddenErrorDescription() {
        XCTAssertEqual(Network.Errors.forbidden.description, "Forbidden")
    }
    
    func testBadRequestErrorDescription() {
        XCTAssertEqual(Network.Errors.badRequest.description, "Bad Request")
    }
    
    func testNoConnectionErrorDescription() {
        XCTAssertEqual(Network.Errors.noConnection.description, "No Connection")
    }
}
