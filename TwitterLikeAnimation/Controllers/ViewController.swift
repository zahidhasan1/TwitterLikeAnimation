//
//  ViewController.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import UIKit

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class ViewController: UIViewController {

    @IBOutlet weak var heartButton: FaveButton!
    
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heartButton.setSelected(selected: true, animated: false)
        // Do any additional setup after loading the view.
    }
    


}

extension ViewController: FaveButtonDelegate{
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        print("Didselect Action")
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? {
        if faveButton === heartButton{
            return colors
        }
        return nil
    }
    
    
}

