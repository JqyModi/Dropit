//
//  BezierPathView.swift
//  Dropit
//
//  Created by mac on 2017/11/10.
//  Copyright © 2017年 modi. All rights reserved.
//

import UIKit

class BezierPathView: UIView {

    private var bezierPaths = [String : UIBezierPath]()
    
    func setPath(name: String, path: UIBezierPath) {
        bezierPaths[name] = path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        for (index, path) in bezierPaths {
            //绘制边界曲线
            path.stroke()
        }
    }

}
