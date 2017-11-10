//
//  ViewController.swift
//  Dropit
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController {

    //将父类替换成自定义的BezierPathView
    @IBOutlet weak var gameView: BezierPathView!
    //创建重力场
    let gravity = UIGravityBehavior()
    //创建碰撞行为
    lazy var collider: UICollisionBehavior = {
       let lazilyCreatedCollider = UICollisionBehavior()
        //设置gameView的边界为动画边界
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    //可选类型
    var attachment: UIAttachmentBehavior? {
        willSet {
            //移除旧的
            if attachment != nil {
                animator.removeBehavior(attachment!)
                //移除掉旧的连接线
                gameView.setPath(name: PathNames.Attachment, path: UIBezierPath())
            }
        }
        didSet {
            //添加新的
            if animator != nil , attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in //attachment循环指向本身可能造成内存泄漏：[unknown self]解决
                    //当锚点变化时需要重绘连接线故放到action闭包中：实时回调：
                    if let attachView = self.attachment?.items.first as? UIView {
                        //添加连接曲线
                        let path = UIBezierPath()
                        //锚点
                        path.move(to: (self.attachment?.anchorPoint)!)
                        //到View的中心点的连线
                        path.addLine(to: attachView.center)
                        UIColor.random.setStroke()
                        self.gameView.setPath(name: PathNames.Attachment, path: path)
                    }
                }
            }
        }
    }
    
    let dropBehavior = DropitBehavior()
    
    //创建力学动画
//    var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView) //不能直接引用gameView因为还没有初始化
    //解决上面问题：lazy
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
//        print("x = \(x)")
        return lazilyCreatedDynamicAnimator
    }()
    
    private struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //添加新的碰撞边界
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: (gameView.bounds.maxX - barrierSize.width)/2, y: (gameView.bounds.maxY - barrierSize.height)/2)
        let bezierPath = UIBezierPath(ovalIn: CGRect(origin: barrierOrigin, size: barrierSize))
        //添加边界到dropBehavior中
        dropBehavior.addBarrier(path: bezierPath, named: PathNames.MiddleBarrier as NSString)
        
        //绘制边界曲线
        gameView.setPath(name: PathNames.MiddleBarrier, path: bezierPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加重力场到力学动画
//        animator.addBehavior(gravity)
        //添加碰撞动画效果
//        animator.addBehavior(collider)
        animator.addBehavior(dropBehavior)
    }
    
    var dropsPerRow = 10
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    var lastDropView: UIView?
    
    @IBAction func attachmentPan(_ sender: UIPanGestureRecognizer) {
        //获取坐标点
        let gesturePoint = sender.translation(in: gameView)
        //
        switch sender.state {
        case .began:
            //1.创建Attachment行为动画
            if let viewToAnchorTo = lastDropView {
                attachment = UIAttachmentBehavior(item: viewToAnchorTo, attachedToAnchor: gesturePoint)
                //添加完Attachment后清除-不需要了
                lastDropView = nil
            }
        case .changed:
            //改变attachment锚点
            attachment?.anchorPoint = gesturePoint
        case .ended:
            attachment = nil
        case .cancelled:    //突然有电话打入等情况
            attachment = nil
        default:
            break
        }
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
        
        //设置lastDropView
        lastDropView = dropView
        
        //给View添加重力场动画: UIDynamicItem是一个协议：UIView已经实现了该协议
//        gravity.addItem(dropView)
        //给View添加碰撞动画
//        collider.addItem(dropView)
        
        dropBehavior.addDrop(drop: dropView)
        
    }
}

//扩展随机函数：私有表示只能在该类使用
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
