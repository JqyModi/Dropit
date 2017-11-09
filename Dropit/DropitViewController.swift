//
//  ViewController.swift
//  Dropit
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    //创建重力场
    let gravity = UIGravityBehavior()
    //创建力学动画
//    var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView) //不能直接引用gameView因为还没有初始化
    //解决上面问题：lazy
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
//        print("x = \(x)")
        return lazilyCreatedDynamicAnimator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加重力场到力学动画
        animator.addBehavior(gravity)
    }
    
    var dropsPerRow = 10
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }

    @IBAction func drop(_ sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        var frame = CGRect(origin: .zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        gameView.addSubview(dropView)
        
        //给View添加重力场动画: UIDynamicItem是一个协议：UIView已经实现了该协议
        gravity.addItem(dropView)
        
    }
}

//扩展随机函数
private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 5 {
        case 0: return UIColor.green
        case 1: return UIColor.blue
        case 2: return UIColor.orange
        case 3: return UIColor.red
        case 4: return UIColor.purple
        default: return UIColor.black
        }
    }
}
