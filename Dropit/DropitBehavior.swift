//
//  DropitBehavior.swift
//  Dropit
//
//  Created by Mac on 2017/11/9.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
    //创建重力场
    let gravity = UIGravityBehavior()
    //创建碰撞行为
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //设置gameView的边界为动画边界
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    lazy var dropBehavior: UIDynamicItemBehavior = {
       let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        //设置是否旋转
        lazilyCreatedDropBehavior.allowsRotation = false
        //设置碰撞时能量损耗
        lazilyCreatedDropBehavior.elasticity = 0.75
        return lazilyCreatedDropBehavior
    }()
    
    override init() {
        super.init()
        //添加动画行为效果
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func addDrop(drop: UIView){
        //添加到动画场中
        dynamicAnimator?.referenceView?.addSubview(drop)
        //将View添加动画行为
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView){
        gravity.removeItem(drop)
        collider.removeItem(drop)
        //移除动画
        drop.removeFromSuperview()
    }
}
