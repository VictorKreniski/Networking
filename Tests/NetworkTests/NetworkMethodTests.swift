import XCTest
@testable import Network

final class NetworkMethodTests: XCTestCase {
    
    func testDelete() {
        XCTAssertEqual(Network.Method.delete.rawValue, "DELETE")
    }
    
    func testGet() {
        XCTAssertEqual(Network.Method.get.rawValue, "GET")
    }
    
    func testPatch() {
        XCTAssertEqual(Network.Method.patch.rawValue, "PATCH")
    }
    
    func testPost() {
        XCTAssertEqual(Network.Method.post.rawValue, "POST")
    }
    
    func testPut() {
        XCTAssertEqual(Network.Method.put.rawValue, "PUT")
    }
}
