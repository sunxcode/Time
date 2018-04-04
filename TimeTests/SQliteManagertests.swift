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
    
    let timeTable = TimeTable()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        timeTable.deletaAll()
        
        let dateStrs = ["2018-04-01 18:00:00", "2018-04-02 20:00:00", "2018-04-04 21:30:30",
                        "2018-04-28 22:00:00", "2018-05-10 21:20:20", "2018-06-30 23:20:20",
                        "2018-08-08 20:08:08", "2018-12-12 22:30:00"]
        
        for dateStr in dateStrs {
            if let date = dateFormatter.date(from: dateStr) {
                timeTable.insert(date)
            }
        }

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - 基础方法测试
    
    func testInsert() {
        
        guard let date1 = dateFormatter.date(from: "2017-12-12 00:00:00") else { XCTAssert(false); return }
        
        if timeTable.insert(date1) == false {
            XCTAssert(false, "插入数据失败")
        }
        
        guard let date2 = dateFormatter.date(from: "2017-12-12 12:12:12") else { XCTAssert(false); return }
        
        if timeTable.insert(date2) == true {
            XCTAssert(false, "不应该成功插入数据，测试失败")
        }
        
        XCTAssert(true)
    }
    
    func testForcedInsert() {
        guard let date = dateFormatter.date(from: "2017-12-12 00:00:00") else { XCTAssert(false); return }
        
        if timeTable.insert(date) == false {
            XCTAssert(false, "插入数据失败")
        }
        
        if timeTable.forcedInsert(date) == false {
            XCTAssert(false, "强制插入数据失败，测试失败")
        }
        
        XCTAssert(true)
    }
    
    func testSearch() {
        
        guard let date1 = dateFormatter.date(from: "2018-04-01 18:00:00") else { XCTAssert(false); return }
        
        guard let _ = timeTable.search(date1) else {
            XCTAssert(false, "搜索测试失败")
            return
        }
        
        guard let date2 = dateFormatter.date(from: "2000-01-01 00:00:00") else { XCTAssert(false); return }
        
        guard let _ = timeTable.search(date2) else {
            XCTAssert(true)
            return
        }
        
        XCTAssert(false, "搜索测试失败")
    }
    
    func testExist() {
        
        guard let date1 = dateFormatter.date(from: "2018-04-01 18:00:00") else { XCTAssert(false); return }
        
        if timeTable.exist(date1) == false {
            XCTAssert(false, "exist 测试失败")
            return
        }
        
        guard let date2 = dateFormatter.date(from: "2000-01-02 00:01:01") else { XCTAssert(false); return }
        
        if timeTable.exist(date2) == true {
            XCTAssert(false, "exit 测试失败")
            return
        }
        
        XCTAssert(true)
        
    }
    
    func testDelete() {
        
        guard let date1 = dateFormatter.date(from: "2018-04-01 18:00:00") else { XCTAssert(false); return }
        
        if timeTable.delete(date1) == false {
            XCTAssert(false, "delete 测试失败")
            return
        }
        
        guard let date2 = dateFormatter.date(from: "1999-01-01 18:00:00") else {  XCTAssert(false); return }
        
        if timeTable.delete(date2) == true {
            XCTAssert(false, "delete 测试失败")
            return
        }
        
        XCTAssert(true)
    }
    
    func testDeletaAll() {
        
        if timeTable.deletaAll() == false {
            XCTAssert(false, "deleteAll test failed")
            return
        }
        
        guard let date1 = dateFormatter.date(from: "2018-06-30 23:20:20") else { XCTAssert(false); return }
        
        guard let _ = timeTable.search(date1) else { XCTAssert(true); return }
        
        XCTAssert(false, "deletaAll test failed")
    }
    
    // MARK: - 高级方法测试
    
    func testAverageTime() {
        // 测试func averageTimeFrom(times: Array<String>) -> String?
        let times = ["18:00:00", "20:00:00", "21:30:30"]
        
        guard let avgTime = timeTable.averageTimeFrom(times: times) else {
            XCTAssert(false, "averageTime test failed")
            return
        }
        
        XCTAssertEqual(avgTime, "19:50:10", "averageTime test failed")
    }
    
    func testAverageTimeAbnormal() {
        // 测试func averageTimeFrom(times: Array<String>) -> String?
        let times = ["18:00:00", "200000", "21:30:30"]
        
        guard let avgTime = timeTable.averageTimeFrom(times: times) else {
            XCTAssert(false, "averageTime test failed")
            return
        }
        
        XCTAssertEqual(avgTime, "19:45:15", "averageTime test failed")
        
    }
    
    func testAverageKnockOffTime() {
        
        guard let fromDate = dateFormatter.date(from: "2018-04-01 00:00:00") else { XCTAssert(false); return }
        guard let toDate = dateFormatter.date(from: "2018-04-05 00:00:00") else { XCTAssert(false); return }

        guard let avgTime = timeTable.averageKnockOffTime(from: fromDate, to: toDate) else {
            XCTAssert(false, "averageKnockOffTime test failed")
            return
        }
        
        XCTAssertEqual(avgTime, "19:50:10", "averageKnockOffTime test failed")
        
    }
    
    func testAverageKnockOffTimeOfTheWeek() {
        
        guard let date = dateFormatter.date(from: "2018-04-01 00:00:00") else { XCTAssert(false); return }
        
        guard let avgTime = timeTable.averageKnockOffTimeOfTheWeek(date: date) else {
            
            XCTAssert(false, "averageKnockOffTimeOfTheWeek: get average time failed")
            
            return
            
        }
        
        XCTAssertEqual(avgTime, "19:50:10", "averageKnockOffTimeOfTheWeek test failed")
    }
    
    func testAverageKnockOffTimeOfTheMonth() {
        
        guard let date = dateFormatter.date(from: "2018-04-01 00:00:00") else { XCTAssert(false); return }
        
        guard let avgTime = timeTable.averageKnockOffTimeOfTheMonth(date: date) else {
            
            XCTAssert(false, "averageKnockOffTimeOfTheMonth: get average time failed")
            
            return
            
        }
        
        XCTAssertEqual(avgTime, "20:22:37", "averageKnockOffTimeOfTheMonth test failed")
        
    }
    
    func testAverageKnockOffTimeOfTheQuarter() {
        
        guard let date = dateFormatter.date(from: "2018-04-01 00:00:00") else { XCTAssert(false); return }
        
        guard let avgTime = timeTable.averageKnockOffTimeOfTheQuarter(date: date) else {
            
            XCTAssert(false, "averageKnockOffTimeOfTheQuarter: get average time failed")
            
            return
            
        }
        
        XCTAssertEqual(avgTime, "21:01:51", "averageKnockOffTimeOfTheQuarter test failed")
        
    }
    
    func testAverageKnockOffTimeOfTheYear() {
        
        guard let date = dateFormatter.date(from: "2018-04-01 00:00:00") else { XCTAssert(false); return }
        
        guard let avgTime = timeTable.averageKnockOffTimeOfTheYear(date: date) else {
            
            XCTAssert(false, "averageKnockOffTimeOfTheYear: get average time failed")
            
            return
            
        }
        
        XCTAssertEqual(avgTime, "21:06:09", "averageKnockOffTimeOfTheYear test failed")
        
    }
}
