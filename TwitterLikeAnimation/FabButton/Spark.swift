//
//  Spark.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import UIKit
internal typealias DotRadius = (first: Double, second: Double)

class Spark: UIView {
    fileprivate struct Const{
        static let distance = (vertical: 4.0, horizontal: 0.0)
        static let expandKey = "expandKey"
        static let dotSizeKey = "dotSizeKey"
    }
    
    
    var radius: CGFloat
    var firsColor: UIColor
    var secondColor: UIColor
    var angle: Double
    
    var dotRadius: DotRadius
    
    fileprivate var dotFirst: UIView!
    fileprivate var dotSecond: UIView!
    
    fileprivate var distanceConstraint: NSLayoutConstraint?
    
    init(radius: CGFloat, firsColor: UIColor, secondColor: UIColor, angle: Double, dotRadius: DotRadius) {
        self.radius = radius
        self.firsColor = firsColor
        self.secondColor = secondColor
        self.angle = angle
        self.dotRadius = dotRadius
        super.init(frame: CGRect.zero)
        applyInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

}


//MARK: create
extension Spark{
    class func createSpark(_ faveButton: FaveButton, radius: CGFloat, firstColor: UIColor, secondColor: UIColor, angle: Double, dotRadius: DotRadius) -> Spark{
        
        let spark = Init(Spark(radius: radius, firsColor: firstColor, secondColor: secondColor, angle: angle, dotRadius: dotRadius)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            $0.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            $0.alpha = 0.0
        }
        
        faveButton.superview?.insertSubview(spark, belowSubview: faveButton)
        
        (spark, faveButton) >>- [.centerX, .centerY]
        
        let width = CGFloat((dotRadius.first * 2.0 + dotRadius.second * 2.0) + Const.distance.horizontal)
        spark >>- {
            $0.attribute = .width
            $0.constant = width
        }
        
        let height = CGFloat(Double(radius) + (dotRadius.first * 2.0 + dotRadius.second * 2.0))
        spark >>- {
            $0.attribute = .height
            $0.constant = height
            $0.identifier = Const.expandKey
        }
        
        return spark
    }
    
    fileprivate func applyInit(){
        dotFirst = createDotView(dotRadius.first, fillColor: firsColor)
        dotSecond = createDotView(dotRadius.second, fillColor: secondColor)
        
        (dotFirst, self) >>- [.trailing]
        attributes(.width, .height).forEach { attr in
            dotFirst >>- {
                $0.attribute = attr
                $0.constant = CGFloat(dotRadius.first * 2.0)
                $0.identifier = Const.dotSizeKey
            }
        }
        
        (dotSecond, self) >>- [.trailing]
        attributes(.width, .height).forEach { attr in
            dotSecond >>- {
                $0.attribute = attr
                $0.constant = CGFloat(dotRadius.second * 2.0)
                $0.identifier = Const.dotSizeKey
            }
        }
        
        (dotSecond, self) >>- {
            $0.attribute = .top
            $0.constant = CGFloat(dotRadius.first * 20 + Const.distance.vertical)
        }
        
        distanceConstraint = (dotFirst, dotSecond) >>- {
            $0.attribute = .bottom
            $0.secondAttribute = .top
            $0.constant = 0
        }
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat(angle.degree))
        
    }
    
    fileprivate func createDotView(_ radius: Double, fillColor: UIColor) -> UIView{
        let dot = Init(UIView(frame: CGRect.zero)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = fillColor
            $0.layer.cornerRadius = CGFloat(radius)
        }
        
        self.addSubview(dot)
        return dot
    }
}


//MARK: Animation
extension Spark{
    func animateIgniteShow(_ radius: CGFloat, duration: Double, delay: Double = 0){
        self.layoutIfNeeded()
        
        let diameter = (dotRadius.first * 2.0) + (dotRadius.second * 2.0)
        let height = CGFloat(Double(radius) + diameter + Const.distance.vertical)
        
        if let constraint = self.constraints.filter({$0.identifier == Const.expandKey}).first{
            constraint.constant = height
        }
        
        UIView.animate(withDuration: 0, delay: delay, options: .curveLinear) {
            self.alpha = 1
        }
        
        UIView.animate(withDuration: duration * 0.7, delay: delay) {
            self.layoutIfNeeded()
            
        }
        
    }
    
    func animateIgniteHide(_ duration: Double, delay: Double = 0) {
        self.layoutIfNeeded()
        distanceConstraint?.constant = CGFloat(-Const.distance.vertical)
        
        UIView.animate(withDuration: duration * 0.5, delay: delay,options: .curveEaseOut){
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration, delay: delay,options: .curveEaseOut) {
            self.dotSecond.backgroundColor = self.firsColor
            self.dotFirst.backgroundColor = self.secondColor
        }
        
        for dot in [dotFirst, dotSecond]{
            dot?.setNeedsLayout()
            dot?.constraints.filter{ $0.identifier == Const.dotSizeKey}.forEach{
                $0.constant = 0
            }
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut) {
            self.dotSecond.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration * 1.7, delay: delay, options: .curveEaseOut) {
            self.dotFirst.layoutIfNeeded()
        } completion: { succeed in
            self.removeFromSuperview()
        }
    }
}
