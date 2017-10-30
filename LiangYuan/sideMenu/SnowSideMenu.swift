//
//  SnowSideMenu.swift
//  LiangYuan
//
//  Created by SN on 2017/10/13.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

// 抽屉效果委托
@objc protocol SnowSideMenuDelegate: class {
    func sideMenuWillOpen()
    func sideMenuWillClose()
    func sideMenuShouldOpenSideMenu () -> Bool
}

// 抽屉位置
enum SnowSideMenuPosition : Int {
    case Left
    case Right
}

enum SnowSideMenuAnimation : Int {
    case None
    case Default
}

class SnowSideMenu: NSObject, UIGestureRecognizerDelegate {
    
    var menuWidth: CGFloat = 180
    var menuPosition: SnowSideMenuPosition = .Left
    var bounces: Bool = false
    var animationDuration = 0.4
    weak var delegate: SnowSideMenuDelegate?
    var allowLeftSwipe = true
    var allowRightSwipe = true
    
    private var menuViewController: UIViewController!
    private var animator: UIDynamicAnimator!
    private var sideMenuView = UIView()
    private var sourceView: UIView!
    private var needUpdateApperence:Bool = false
    var isMenuOpen: Bool = false
    
    
    init(sourceView: UIView, menuPosition: SnowSideMenuPosition) {
        super.init()
        self.sourceView = sourceView
        self.menuPosition = menuPosition
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView: sourceView)
        
        // 右滑手势
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        
        
        rightSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        sourceView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        // 左滑手势
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        sourceView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
    }
    
    convenience init(sourceView: UIView, menuViewController: UIViewController, menuPosition: SnowSideMenuPosition) {
        self.init(sourceView: sourceView, menuPosition: menuPosition)
        self.menuViewController = menuViewController
        self.menuViewController.view.frame = sideMenuView.bounds
        self.menuViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sideMenuView.addSubview(self.menuViewController.view)
    }
    
    convenience init(sourceView: UIView, view: UIView, menuPosition: SnowSideMenuPosition) {
        self.init(sourceView: sourceView, menuPosition: menuPosition)
        view.frame = sideMenuView.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sideMenuView.addSubview(view)
    }
    
    func updateFrame() {
        let width: CGFloat = sourceView.frame.size.width
        let hight: CGFloat = sourceView.frame.size.height
        let menuFrame = CGRect(
            x: (menuPosition == .Left) ?
                isMenuOpen ? 0 : -menuWidth-1.0 :
                isMenuOpen ? width - menuWidth : width + 1.0,
            y: sourceView.frame.origin.y,
            width: menuWidth,
            height: hight)
        sideMenuView.frame = menuFrame
    }
    
    func setupMenuView() {
        
        updateFrame()
        
        sideMenuView.backgroundColor = UIColor.clear
        sideMenuView.clipsToBounds = false
        //        sideMenuView.layer.masksToBounds = false
        //        sideMenuView.layer.shadowOffset = (menuPosition == .Left) ? CGSizeMake(1.0, 1.0) : CGSizeMake(-1.0, -1.0)
        //        sideMenuView.layer.shadowRadius = 1.0
        //        sideMenuView.layer.shadowOpacity = 0.125
        //        sideMenuView.layer.shadowPath = UIBezierPath(rect: sideMenuView.bounds).CGPath
        sourceView.addSubview(sideMenuView)
        
    }
    
    // 手势处理
    @objc private dynamic func handleGesture(_ recognizer: UIGestureRecognizer!) {
        if let swipeGestureRecognizer = recognizer as? UISwipeGestureRecognizer {
//            toggleMenu(self.menuPosition == .Right && swipeGestureRecognizer.direction == .Left
//                || self.menuPosition == .Left && swipeGestureRecognizer.direction == .Right)
        }
    }
    
    
    
    // Menu开关
    func toggleMenu() {
        if isMenuOpen {
            toggleMenu(false)
        }else {
            updateSideMenuApperanceIfNeeded()
            toggleMenu(true)
        }
    }
    
    func toggleMenu(_ shouldOpen: Bool){
        
        if (shouldOpen && delegate?.sideMenuShouldOpenSideMenu() == false) {
            return
        }
        
        updateSideMenuApperanceIfNeeded()
        isMenuOpen = shouldOpen
        let width: CGFloat = sourceView.frame.size.width
        let hight: CGFloat = sourceView.frame.size.height
        if bounces {
            animator.removeAllBehaviors()
            
            var gravityDirectionX: CGFloat
            var pushMagnitude: CGFloat
            var boundaryPointX: CGFloat
            var boundaryPointY: CGFloat
            
            if (menuPosition == .Left) {
                // Left side menu
                gravityDirectionX = (shouldOpen) ? 1 : -1
                pushMagnitude = (shouldOpen) ? 20 : -20
                boundaryPointX = (shouldOpen) ? menuWidth : -menuWidth-2
                boundaryPointY = 20
            }
            else {
                // Right side menu
                gravityDirectionX = (shouldOpen) ? -1 : 1
                pushMagnitude = (shouldOpen) ? -20 : 20
                boundaryPointX = (shouldOpen) ? width-menuWidth : width+menuWidth+2
                boundaryPointY =  -20
            }
            
            let gravityBehavior = UIGravityBehavior(items: [sideMenuView])
            gravityBehavior.gravityDirection = CGVector(dx: gravityDirectionX, dy: 0)
            animator.addBehavior(gravityBehavior)
            
            let collisionBehavior = UICollisionBehavior(items: [sideMenuView])
            
            collisionBehavior.addBoundary(withIdentifier: NSString(string: "menuBoundary"), from: CGPoint(x: boundaryPointX, y: boundaryPointY), to: CGPoint(x: boundaryPointX, y: hight))
            animator.addBehavior(collisionBehavior)
            
            let pushBehavior = UIPushBehavior(items: [sideMenuView], mode: UIPushBehaviorMode.instantaneous)
            pushBehavior.magnitude = pushMagnitude
            animator.addBehavior(pushBehavior)
            
            let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuView])
            menuViewBehavior.elasticity = 0.25
            animator.addBehavior(menuViewBehavior)
            
        }
            
        else {
            var destFrame :CGRect
            if (menuPosition == .Left) {
                destFrame = CGRect(x: (shouldOpen) ? -2.0 : -menuWidth, y: 0, width: menuWidth, height: hight)
            }
            else {
                destFrame = CGRect(x: (shouldOpen) ? width-menuWidth : width+2.0, y: 0, width: menuWidth, height: hight)
            }
            UIView.animate(withDuration: animationDuration, animations: {
                self.sideMenuView.frame = destFrame
            })
            
        }
        
        if (shouldOpen) {
            delegate?.sideMenuWillOpen()
        } else {
            delegate?.sideMenuWillClose()
        }
        
    }
    
    func updateSideMenuApperanceIfNeeded() {
        if needUpdateApperence {
            var frame = sideMenuView.frame
            frame.size.width = menuWidth
            sideMenuView.frame = frame
            sideMenuView.layer.shadowPath = UIBezierPath(rect: sideMenuView.bounds).cgPath
            needUpdateApperence = false
        }
    }
    
    // 显示抽屉栏
    func showSideMenu() {
        if !isMenuOpen {
            toggleMenu(true)
        }
    }
    
    // 隐藏抽屉栏
    func hideSideMenu() {
        if isMenuOpen {
            toggleMenu(false)
        }
    }
    
    
    // MARK : - 手势委托
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer {
            if !allowLeftSwipe {
                if swipeGestureRecognizer.direction == .left {
                    return false
                }
            }
            if !allowRightSwipe {
                if swipeGestureRecognizer.direction == .right {
                    return false
                }
            }
        }
        
        return true
    }
    
}
