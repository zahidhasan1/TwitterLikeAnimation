//
//  Constraints+.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import Foundation

import UIKit

precedencegroup ConstrPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

//infix operator >>- { associativity left precedence 160 }
infix operator >>- : ConstrPrecedence


struct Constraint{
    var identifier: String?
    
    #if swift(>=4.2)
    var attribute: NSLayoutConstraint.Attribute = .centerX
    var secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
    #else
    var attribute: NSLayoutAttribute = .centerX
    var secondAttribute: NSLayoutAttribute = .notAnAttribute
    #endif
    
    var constant: CGFloat = 0
    var multiplier: CGFloat = 1
    
    #if swift(>=4.2)
    var relation: NSLayoutConstraint.Relation = .equal
    #else
    var relation: NSLayoutRelation = .equal
    #endif
}

#if swift(>=4.2)
func attributes(_ attrs:NSLayoutConstraint.Attribute...) -> [NSLayoutConstraint.Attribute]{
    return attrs
}
#else
func attributes(_ attrs:NSLayoutAttribute...) -> [NSLayoutAttribute]{
    return attrs
}
#endif

@discardableResult func >>- <T: UIView> (lhs: (T,T), apply: (inout Constraint) -> () ) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    const.secondAttribute = .notAnAttribute == const.secondAttribute ? const.attribute : const.secondAttribute
    
    let constraint = NSLayoutConstraint(item: lhs.0,
                                        attribute: const.attribute,
                                        relatedBy: const.relation,
                                        toItem: lhs.1,
                                        attribute: const.secondAttribute,
                                        multiplier: const.multiplier,
                                        constant: const.constant)
    
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activate([constraint])
    return constraint
}


@discardableResult  func >>- <T: UIView> (lhs: T, apply: (inout Constraint) -> () ) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    let constraint = NSLayoutConstraint(item: lhs,
                                        attribute: const.attribute,
                                        relatedBy: const.relation,
                                        toItem: nil,
                                        attribute: const.attribute,
                                        multiplier: const.multiplier,
                                        constant: const.constant)
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activate([constraint])
    return constraint
}


#if swift(>=4.2)
func >>- <T:UIView> (lhs: (T,T),attributes: [NSLayoutConstraint.Attribute]){
    for attribute in attributes{
        lhs >>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}
#else
func >>- <T:UIView> (lhs: (T,T),attributes: [NSLayoutAttribute]){
    for attribute in attributes{
        lhs >>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}
#endif

#if swift(>=4.2)
func >>- <T:UIView> (lhs: T, attributes: [NSLayoutConstraint.Attribute]){
    for attribute in attributes{
        lhs >>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}
#else
func >>- <T:UIView> (lhs: T, attributes: [NSLayoutAttribute]){
    for attribute in attributes{
        lhs >>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}
#endif

