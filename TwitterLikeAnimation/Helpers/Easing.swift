//
//  Easing.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import UIKit


typealias Easing        = (_ t:CGFloat,_ b:CGFloat,_ c:CGFloat,_ d:CGFloat)-> CGFloat
typealias ElasticEasing = (_ t:CGFloat,_ b:CGFloat,_ c:CGFloat,_ d:CGFloat,_ a:CGFloat,_ p:CGFloat)-> CGFloat

// ELASTIC EASING

struct Elastic{
    static var EaseIn :Easing    = { (_t,b,c,d) -> CGFloat in
        var t = _t
        
        if t==0{ return b }
        t/=d
        if t==1{ return b+c }
        
        let p = d * 0.3
        let a = c
        let s = p/4
        
        t -= 1
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
    }
    
    static var EaseOut :Easing   = { (_t,b,c,d) -> CGFloat in
        var t = _t
        
        if t==0{ return b }
        t/=d
        if t==1{ return b+c}
        
        let p = d * 0.3
        let a = c
        let s = p/4
        
        return (a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p ) + c + b);
    }
    
    static var EaseInOut :Easing = { (_t,b,c,d) -> CGFloat in
        var t = _t
        if t==0{ return b}
        
        t = t/(d/2)
        if t==2{ return b+c }
        
        let p = d * (0.3*1.5)
        let a = c
        let s = p/4
        
        if t < 1 {
            t -= 1
            return -0.5*(a*pow(2,10*t) * sin((t*d-s)*(2*(.pi))/p )) + b;
        }
        t -= 1
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p )*0.5 + c + b;
    }
}


extension Elastic{
    static var ExtendedEaseIn :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var t = _t
        var a = _a
        var p = _p
        var s:CGFloat = 0.0
        
        if t==0{ return b }
        
        t /= d
        if t==1{ return b+c }
        
        if a < abs(c) {
            a=c;  s = p/4
        }else {
            s = p/(2*(.pi)) * asin (c/a);
        }
        
        t -= 1
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
    }
    
    
    static var ExtendedEaseOut :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var s:CGFloat = 0.0
        var t = _t
        var a = _a
        var p = _p
        
        if t==0 { return b }
        
        t /= d
        if t==1 {return b+c}
        
        if a < abs(c) {
            a=c;  s = p/4;
        }else {
            s = p/(2*(.pi)) * asin (c/a)
        }
        return (a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p ) + c + b)
    }
    
    
    static var ExtendedEaseInOut :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var s:CGFloat = 0.0
        var t = _t
        var a = _a
        var p = _p
        
        if t==0{ return b }
        
        t /= d/2
        
        if t==2{ return b+c }
        
        if a < abs(c) {
            a=c; s=p/4;
        }else {
            s = p/(2*(.pi)) * asin (c/a)
        }
        
        if t < 1 {
            t -= 1
            return -0.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
        }
        t -= 1
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p )*0.5 + c + b;
    }
}


