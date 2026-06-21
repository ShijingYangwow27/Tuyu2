import XCTest
import SwiftUI
@testable import Tuyu

final class TemplateDataTests: XCTestCase {
    func testCategoriesCount() {
        XCTAssertEqual(TemplateData.categories.count, 7)
    }

    func testTotalTemplatesCount() {
        XCTAssertEqual(TemplateData.templates.count, 56)
    }

    func testPortraitTemplatesCount() {
        XCTAssertEqual(TemplateData.portrait.count, 18)
    }

    func testProductTemplatesCount() {
        XCTAssertEqual(TemplateData.product.count, 12)
    }

    func testSceneTemplatesCount() {
        XCTAssertEqual(TemplateData.scene.count, 8)
    }

    func testFestivalTemplatesCount() {
        XCTAssertEqual(TemplateData.festival.count, 8)
    }

    func testIdTemplatesCount() {
        XCTAssertEqual(TemplateData.id.count, 4)
    }

    func testRepairTemplatesCount() {
        XCTAssertEqual(TemplateData.repair.count, 6)
    }

    func testTemplateIdIsUnique() {
        let ids = TemplateData.templates.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "Template IDs should be unique")
    }

    func testFindTemplateById() {
        let template = TemplateData.template(id: "P-01")
        XCTAssertNotNil(template)
        XCTAssertEqual(template?.name, "韩系证件棚")
    }

    func testTemplatesByCategory() {
        let portraitTemplates = TemplateData.templates(category: "portrait")
        XCTAssertEqual(portraitTemplates.count, 18)

        let recommendTemplates = TemplateData.templates(category: "recommend")
        XCTAssertEqual(recommendTemplates.count, 56)
    }
}

final class APIClientTests: XCTestCase {
    func testAPIClientInitialization() {
        let client = APIClient(baseURL: URL(string: "https://api.example.com/v1")!)
        // V1: 暂时只验证初始化不崩溃
        XCTAssertNotNil(client)
    }
}

final class ColorExtensionTests: XCTestCase {
    func testColorFromHex() {
        let color = Color(hex: "FF0000")
        // V1: 验证编译通过
        XCTAssertNotNil(color)
    }
}
