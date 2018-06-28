//
//  CustomFSCalendar.swift
//  Time
//
//  Created by yaoxinpan on 2018/6/27.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import FSCalendar

protocol FSCalendarTwoTapsDelegate: AnyObject {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition)
}

@IBDesignable
class CustomFSCalendar: FSCalendar {
    
    weak open var twoTapsDelegate: FSCalendarTwoTapsDelegate?
    
    lazy var twoTaps: UITapGestureRecognizer = {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTwoTaps(_:)))
        
        tap.numberOfTapsRequired = 2
        
        collectionView.addGestureRecognizer(tap)
        
        return tap
        
    }()
    
    @objc private func handleTwoTaps(_ sender: UITapGestureRecognizer) {
        
        guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else { return }
        
        if let date = calculator.date(for: indexPath) {
            
            let monthPosition = calculator.monthPosition(for: indexPath)
            
            twoTapsDelegate?.calendar(self, date: date, at: monthPosition)
            
        }

    }
}

extension FSCalendarTwoTapsDelegate {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition) {
        return
    }
}

/*

protocol FSCalendarLongPressDelegate: AnyObject {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition)
}

@IBDesignable
class CustomFSCalendar: FSCalendar {

    weak open var longPressDelegate: FSCalendarLongPressDelegate?
    
    private var currentPressedIndexPath: IndexPath?
    
    private lazy var longPress: UILongPressGestureRecognizer = {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        pressGesture.isEnabled = true
        pressGesture.delaysTouchesBegan = false
        pressGesture.delaysTouchesEnded = false
        pressGesture.numberOfTapsRequired = 0
        pressGesture.numberOfTouchesRequired = 1
        pressGesture.minimumPressDuration = 0.7
        daysContainer.addGestureRecognizer(pressGesture)
        collectionView.panGestureRecognizer.require(toFail: pressGesture)
        return pressGesture
    }()
    
    override var swipeToChooseGesture: UILongPressGestureRecognizer {
        get {
            return longPress
        }
    }
    
    @objc private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            guard currentPressedIndexPath == nil else { return }
            
            guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else { return }
            
            currentPressedIndexPath = indexPath

            if let date = calculator.date(for: indexPath) {
                
                let monthPosition = calculator.monthPosition(for: indexPath)
                
                longPressDelegate?.calendar(self, date: date, at: monthPosition)
                
            }
            
        default:
            currentPressedIndexPath = nil
            
        }
    }
    

}

extension FSCalendarLongPressDelegate {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition){
        return
    }
}

 */
