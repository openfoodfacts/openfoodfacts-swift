import XCTest
import OpenFoodFactsSDK

final class ProductQueryConfigurationPublicInitTests: XCTestCase {
    func testPublicInitializerIsAccessible() {
        _ = ProductQueryConfiguration(barcode: "3017620422003")
    }
}
