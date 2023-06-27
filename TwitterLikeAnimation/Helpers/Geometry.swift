//
//  Geometry.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import UIKit

extension CGRect{
    var center: CGPoint{
        return CGPoint(x: self.size.width/2.0, y: self.size.height/2.0)
    }
}

extension CGSize{
    func rectCentered(at: CGPoint) -> CGRect{
        let dx = self.width/2
        let dy = self.height/2
        let origin = CGPoint(x: at.x - dx, y: at.y - dy)
        return CGRect(origin: origin, size: self)
    }
    
    func scaleBy(_ factor: CGFloat) -> CGSize{
        return CGSize(width: self.width*factor, height: self.height*factor)
    }
}

extension Double{
    var degree: Double{
        return self * (.pi) / 180.0
    }
    
    var radians: Double{
        return self * 180.0 / (.pi)
    }
}
