import XCTest
@testable import Networking

final class NetworkingMethodTests: XCTestCase {
    
    func testDelete() {
        XCTAssertEqual(Networking.Method.delete.rawValue, "DELETE")
    }
    
    func testGet() {
        XCTAssertEqual(Networking.Method.get.rawValue, "GET")
    }
    
    func testPatch() {
        XCTAssertEqual(Networking.Method.patch.rawValue, "PATCH")
    }
    
    func testPost() {
        XCTAssertEqual(Networking.Method.post.rawValue, "POST")
    }
    
    func testPut() {
        XCTAssertEqual(Networking.Method.put.rawValue, "PUT")
    }
}
