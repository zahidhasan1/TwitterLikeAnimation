//
//  FaveButton.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import UIKit

public typealias DotColors = (first: UIColor, second: UIColor)

public protocol FaveButtonDelegate{
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool)
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?
}


//MARK: - Default Implementation
open class FaveButton: UIButton{
    fileprivate struct Const{
        static let duration = 1.0
        static let expandDuration = 0.1298
        static let collapseDuration = 0.1089
        static let faveIconShowDelay = Const.expandDuration + Const.collapseDuration / 2.0
        static let dotRadiusFactor = (first: 0.0633, secod: 0.04)
    }
    
    @IBInspectable open var normalColor: UIColor = UIColor(red: 137/255, green: 156/255, blue: 167/255, alpha: 1)
    @IBInspectable open var selectedColor: UIColor   = UIColor(red: 226/255, green: 38/255,  blue: 77/255,  alpha: 1)
    @IBInspectable open var dotFirstColor: UIColor   = UIColor(red: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    @IBInspectable open var dotSecondColor: UIColor  = UIColor(red: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    @IBInspectable open var circleFromColor: UIColor = UIColor(red: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    @IBInspectable open var circleToColor: UIColor   = UIColor(red: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    
    @IBOutlet open weak var delegate: AnyObject?
    
    fileprivate(set) var sparkGroupCount: Int = 7
    
    
    fileprivate var faveIconImage: UIImage?
    fileprivate var faveIcon: FaveIcon!
    fileprivate var animationEnabled = true
    
    open override var isSelected: Bool{
        didSet{
            guard self.animationEnabled else{return}
            animateSelect(self.isSelected, duration: Const.duration)
        }
    }
    
    convenience init(frame: CGRect, faveIconNormal: UIImage?) {
        self.init(frame: frame)
        guard let icon = faveIconNormal else{
            fatalError("missing Image for normal state.")
        }
        faveIconImage = icon
        applyInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        applyInit()
    }
    
    public func setSelected(selected: Bool, animated: Bool){
        guard selected != self.isSelected else{
            return
        }
        guard animated == false else{
            self.isSelected = selected
            return
        }
        
        self.animationEnabled = false
        self.isSelected = selected
        self.animationEnabled = true
        
        animateSelect(self.isSelected, duration: 0.0) // Trigger state change without animation
    }
    
}

//MARK: Create
extension FaveButton{
    fileprivate func applyInit(){
        if nil == faveIconImage{
            faveIconImage = image(for: UIControl.State())
        }
        
        guard let faveIconImage = faveIconImage else{
            fatalError("please provide an image for normal state")
        }
        setImage(UIImage(), for: UIControl.State())
        setTitle(nil, for: UIControl.State())
        
        faveIcon  = createFaveIcon(faveIconImage)
        addAction()
        
    }
    
    fileprivate func createFaveIcon(_ faveIconImage: UIImage) -> FaveIcon{
        return FaveIcon.createFaveIcon(self, icon: faveIconImage, color: normalColor)
    }
    
    
    fileprivate func createSparks(_ radius: CGFloat) -> [Spark]{

        var sparks = [Spark]()
        let step = 360.0/Double(sparkGroupCount)
        let base = Double(bounds.size.width)
        let dotRadius = (base * Const.dotRadiusFactor.first, base * Const.dotRadiusFactor.secod)
        let offset = 10.0
        
        for index in 0..<sparkGroupCount{
            let theta = step * Double(index) + offset
            let colors = dotColors(at: index)
            
            let spark = Spark.createSpark(self, radius: radius, firstColor: colors.first, secondColor: colors.second, angle: theta, dotRadius: dotRadius)
            sparks.append(spark)
        }
        return sparks
    }
}

//MARK: - Utils
extension FaveButton{
    fileprivate func dotColors(at index: Int) -> DotColors{
        if case let delegate as FaveButtonDelegate = delegate, nil != delegate.faveButtonDotColors(self){
            
            let colors = delegate.faveButtonDotColors(self)!
            let colorIndex = 0..<colors.count ~= index ? index: index % colors.count
            return colors[colorIndex]
        }
        return DotColors(self.dotFirstColor, self.dotSecondColor)
    }
}

//MARK: - Actions
extension FaveButton{
    func addAction(){
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    @objc func toggle(_ sender: FaveButton){
        sender.isSelected = !sender.isSelected
        
        guard case let delegate as FaveButtonDelegate = self.delegate else {return}
        let delay = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * Const.duration)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay){
            delegate.faveButton(sender, didSelected: sender.isSelected)
        }
        
        
    }
}

//MARK: - animation
extension FaveButton{
    fileprivate func animateSelect(_ isSelected: Bool, duration: Double){
        let color  = isSelected ? selectedColor : normalColor
        
        faveIcon.animateSelect(isSelected, fillColor: color, duration: duration, delay: duration > 0.0 ? Const.faveIconShowDelay : 0.0)
        
        guard duration > 0.0 else {
            return
        }
        
        if isSelected{
            let radius           = bounds.size.scaleBy(1.3).width/2 // ring radius
            let igniteFromRadius = radius*0.8
            let igniteToRadius   = radius*1.1
            
            let ring   = Ring.createRing(self, radius: 0.01, lineWidth: 3, fillColor: self.circleFromColor)
            let sparks = createSparks(igniteFromRadius)
            
            ring.animateToRadius(radius, toColor: circleToColor, duration: Const.expandDuration, delay: 0)
            ring.animateColapse(radius, duration: Const.collapseDuration, delay: Const.expandDuration)

            sparks.forEach{
                $0.animateIgniteShow(igniteToRadius, duration:0.4, delay: Const.collapseDuration/3.0)
                $0.animateIgniteHide(0.7, delay: 0.2)
            }
        }
    }
}
