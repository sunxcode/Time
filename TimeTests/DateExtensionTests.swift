//
//  DateExtensionTests.swift
//  TimeTests
//
//  Created by yaoxinpan on 2018/4/3.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import XCTest
@testable import Time

class DateExtensionTests: XCTestCase {
    
    var date: Date?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dateStr = "2018-05-03 11:33:13"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = dateFormatter.date(from: dateStr)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testToString1() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        let year = date!.toString(formatter: "yyyy-MM-dd")
        
        XCTAssertEqual(year, "2018-05-03", "时间转换成日期错误")
    }
    
    func testToString2() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        let time = date!.toString(formatter: "HH:mm:ss")
        
        XCTAssertEqual(time, "11:33:13", "时间转换成时间错误")
    }
    
    func testToYear() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        let year = date!.year()
        
        XCTAssertEqual(year, "2018", "date 转换成年份失败")
    }
    
    func testToMonth() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        let month = date!.month()
        
        XCTAssertEqual(month, "05", "date 转换成月份失败")
    }
    
    func testToDay() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        let day = date!.day()
        
        XCTAssertEqual(day, "03", "date 转换成日失败")
    }
    
    func testFirstAndLastDayOfThisWeek() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        guard let tmpDate = date!.firstAndLastDayOfThisWeek() else {
            XCTAssert(false, "获取本周第一天和最后一天的日期失败")
            return
        }
        
        let firstDateStr = tmpDate.first.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(firstDateStr, "2018-04-29", "获取本周第一天的日期失败")
        
        let lastDateStr = tmpDate.last.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(lastDateStr, "2018-05-05", "获取本周最后一天的日期失败")
        
    }
    
    func testFirstAndLastDayOfThisMonth() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        guard let tmpDate = date!.firstAndLastDayOfThisMonth() else {
            XCTAssert(false, "获取本周第一天和最后一天的日期失败")
            return
        }
        
        let firstDateStr = tmpDate.first.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(firstDateStr, "2018-05-01", "获取本周第一天的日期失败")
        
        let lastDateStr = tmpDate.last.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(lastDateStr, "2018-05-31", "获取本周最后一天的日期失败")
        
    }
    
    func testFirstAndLastDayOfThisQuarter() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        guard let tmpDate = date!.firstAndLastDayOfThisQuarter() else {
            XCTAssert(false, "获取本季度第一天和最后一天的日期失败")
            return
        }
        
        let firstDateStr = tmpDate.first.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(firstDateStr, "2018-04-01", "获取本季度第一天的日期失败")
        
        let lastDateStr = tmpDate.last.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(lastDateStr, "2018-06-30", "获取本季度最后一天的日期失败")
    }
    
    func testFirstAndLastDayOfThisYear() {
        XCTAssertNotNil(date, "DateExtensionTests date初始化失败")
        
        guard let tmpDate = date!.firstAndLastDayOfThisYear() else {
            XCTAssert(false, "获取本年第一天和最后一天的日期失败")
            return
        }
        
        let firstDateStr = tmpDate.first.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(firstDateStr, "2018-01-01", "获取本年第一天的日期失败")
        
        let lastDateStr = tmpDate.last.toString(formatter: "yyyy-MM-dd")
        XCTAssertEqual(lastDateStr, "2018-12-31", "获取本年最后一天的日期失败")
    }
    
}
