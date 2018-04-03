//
//  SQliteManagertests.swift
//  TimeTests
//
//  Created by yaoxinpan on 2018/4/3.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import XCTest
@testable import Time

class SQliteManagertests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAverageKnockOffTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        var dateStr = "2018-04-01 18:00:00"
        var date = dateFormatter.date(from: dateStr)
        TimeTable().forcedInsert(date!)
        
        dateStr = "2018-04-02 20:00:00"
        date = dateFormatter.date(from: dateStr)
        TimeTable().forcedInsert(date!)
        
        dateStr = "2018-04-04 21:30:30"
        date = dateFormatter.date(from: dateStr)
        TimeTable().forcedInsert(date!)
        
        let fromDate = dateFormatter.date(from: "2018-04-01 00:00:00")
        let toDate = dateFormatter.date(from: "2018-04-05 00:00:00")
        
        let avgTime = TimeTable().averageKnockOffTime(from: fromDate!, to: toDate!)
        
        XCTAssertNotNil(avgTime, "date平均下班时间为nil，失败")
        XCTAssertEqual(avgTime!, "19:50:10")
    }
    
    func testAverageTime() {
        // 测试func averageTimeFrom(times: Array<String>) -> String?
        let times = ["18:00:00", "20:00:00", "21:30:30"]
        let avgTime = TimeTable().averageTimeFrom(times: times)
        
        XCTAssertNotNil(avgTime, "平均下班时间为nil，失败")
        XCTAssertEqual(avgTime!, "19:50:10")
    }
    
    func testAverageTimeAbnormal() {
        // 测试func averageTimeFrom(times: Array<String>) -> String?
        let times = ["18:00:00", "200000", "21:30:30"]
        let avgTime = TimeTable().averageTimeFrom(times: times)
        
        XCTAssertNotNil(avgTime, "平均下班时间为nil，失败")
        XCTAssertEqual(avgTime!, "19:45:15")
    }
    
}
