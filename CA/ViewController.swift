//
//  ViewController.swift
//  CA
//
//  Created by Alex Gibson on 5/6/16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var caAnimView: UIView!
    @IBOutlet weak var uiAnimView: UIView!
    @IBOutlet weak var cornerRadiusSlider: UISlider!
    @IBOutlet weak var cornerRadiusLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    var isLarge = false
    var bigAnim = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cornerRadiusSlider.value = 0
        testView.layer.masksToBounds = true
        
        uiAnimView.layer.cornerRadius = uiAnimView.frame.width/2
        caAnimView.layer.cornerRadius = uiAnimView.frame.width/2
        
        self.testView.alpha = 1
        self.uiAnimView.alpha = 0
        self.caAnimView.alpha = 0
        self.bigAnim = false
        
        self.presetOpacity(self.testView)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.scaleView(self.testView, fromX: 0, fromY: 0, toX: 1, toY: 1, strength: 11, keyPath: "scale", duration: 1.2, delay: 0.2,withReveal:true)
     
    }
    

    @IBAction func switchDidFlip(sender: UISwitch) {
        if sender.on{
            self.testView.alpha = 1
            self.uiAnimView.alpha = 0
            self.caAnimView.alpha = 0
            self.bigAnim = false
        }else{
            self.testView.alpha = 0
            self.uiAnimView.alpha = 1
            self.caAnimView.alpha = 1
            self.bigAnim = true
        }
    }
    
    @IBAction func performScaleDidPress(sender: AnyObject) {
        if bigAnim == false{
            animateBig()
        }else{
            animateWithSpringLittle()
        }
    }
    
    
    func animateBig(){
        if isLarge == false{
            
            //now scale
            let scale = CASpringAnimation(keyPath: "transform.scale")
            scale.toValue = NSValue(CGPoint: CGPointMake(2, 2))
            scale.duration = 0.8
            //.17,.67,.94,1.54
            scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.17, 0.67, 0.94, 1.54)
            scale.fillMode = kCAFillModeForwards
            scale.removedOnCompletion = false
            self.testView.layer.addAnimation(scale, forKey: "scale")
            isLarge = true
        }else {
            
            //now scale
            let scale = CASpringAnimation(keyPath: "transform.scale")
            scale.toValue = NSValue(CGPoint: CGPointMake(1, 1))
            scale.fromValue = NSValue(CGPoint: CGPointMake(2, 2))
            scale.duration = 0.8
            
            //.17,.67,.94,1.54
            scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.37, 0.67, 0.94, 1.34)
            self.testView.layer.addAnimation(scale, forKey: "scale")
            isLarge = false
        }
        
    }
    
    
    func animateWithSpringLittle(){
        let distance = self.view.bounds.width - uiAnimView.frame.origin.x - uiAnimView.frame.width
        let caDistance = self.view.bounds.width - caAnimView.frame.origin.x - caAnimView.frame.width
        
        print(distance)
        print(caDistance)
        
        if isLarge == false{
            self.view.userInteractionEnabled = false
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations:{
                self.uiAnimView.transform = CGAffineTransformMakeTranslation(distance, 0)
                self.view.userInteractionEnabled = true
            }) { (finished) in}
            
            
            let spring = CASpringAnimation(keyPath: "position.x")
            spring.toValue = self.caAnimView.frame.origin.x + caDistance + self.caAnimView.bounds.width/2
            spring.fromValue = self.caAnimView.frame.origin.x
            //spring.mass = 1
            spring.initialVelocity = 10
            spring.damping = 15.0
            //spring.stiffness = 0.0
            spring.removedOnCompletion = false
            spring.fillMode = kCAFillModeForwards
            spring.duration = 0.7
            spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            //CAMediaTimingFunction(controlPoints: 0.17, 0.67, 0.94, 1.54)
            self.caAnimView.layer.addAnimation(spring, forKey: "spring")
            
            isLarge = true
        }else{
            self.view.userInteractionEnabled = false
            let vwcenter = self.uiAnimView.center
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: {
                self.uiAnimView.transform = CGAffineTransformIdentity
                }, completion: {
                    finished in
                    UIView.animateWithDuration(0.7, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: {
                        self.uiAnimView.center = self.view.center
                        }, completion: {
                            finished in
                            UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
                                self.uiAnimView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                                }, completion: {
                                    finished in
                                    UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
                                        self.uiAnimView.transform = CGAffineTransformIdentity
                                        }, completion: {
                                            finished in
                                            UIView.animateWithDuration(0.7, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: {
                                                self.uiAnimView.center = vwcenter
                                                }, completion: {
                                                    finished in
                                                    if finished == true{
                                                        self.longFunCAAnimation()
                                                    }
                                            })
                                    })
                            })
                    })
                    
            })
            
            // this goes on in real time with the first UIView from above 😀
            let spring = CASpringAnimation(keyPath: "position.x")
            spring.toValue = self.caAnimView.frame.origin.x + self.caAnimView.bounds.width/2
            spring.fromValue = self.caAnimView.frame.origin.x + caDistance + self.caAnimView.bounds.width/2
            //spring.mass = 1
            spring.initialVelocity = 10
            spring.damping = 15.0
            //spring.stiffness = 0.0
            spring.removedOnCompletion = true
            spring.fillMode = kCAFillModeForwards
            spring.duration = 0.7
            spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            //CAMediaTimingFunction(controlPoints: 0.17, 0.67, 0.94, 1.54)
            self.caAnimView.layer.addAnimation(spring, forKey: "spring")
            isLarge = false
        }

    }
    
    func longFunCAAnimation(){
        
        let originalCenter = caAnimView.center
        // create a group for spin,corner radius and position
        let firstGroup = CAAnimationGroup()
        
        CATransaction.begin()
        let spring = CASpringAnimation(keyPath: "position")
        spring.toValue = NSValue(CGPoint: self.view.center)
        spring.fromValue = NSValue(CGPoint: originalCenter)
        spring.initialVelocity = 10
        spring.damping = 15.0
        spring.beginTime = 0.5
        CATransaction.setCompletionBlock({
            self.caAnimView.center = self.view.center
        })
        spring.duration = 0.7
        spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = 180.0.degreesToRadians
        rotation.fromValue = 0
        rotation.duration = 0.35
        rotation.beginTime = 0.5
        rotation.repeatCount = 2

        
        let cornerRadius = CASpringAnimation(keyPath: "cornerRadius")
        cornerRadius.fromValue = caAnimView.layer.cornerRadius
        cornerRadius.toValue  = 0
        cornerRadius.duration = 0.5
        cornerRadius.removedOnCompletion = false
        cornerRadius.fillMode = kCAFillModeForwards
    
        let unwindCorner = CASpringAnimation(keyPath: "cornerRadius")
        unwindCorner.fromValue = 0
        unwindCorner.toValue  = self.caAnimView.frame.width/2
        unwindCorner.duration = 0.2
        unwindCorner.beginTime = 1.0
        
        
        //rotation,cornerRadius,unwindCorner
        firstGroup.animations = [spring,rotation,cornerRadius,unwindCorner]
        firstGroup.duration = 1.2
        self.caAnimView.layer.addAnimation(firstGroup, forKey: nil)
        CATransaction.commit()
        
        
        
        
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.toValue = NSValue(CGPoint: CGPointMake(1.5, 1.5))
        scale.duration = 0.5
        scale.beginTime = CACurrentMediaTime() + 1.4
        scale.fillMode = kCAFillModeForwards
        scale.removedOnCompletion = false
        self.caAnimView.layer.addAnimation(scale, forKey: "scale")
        
        CATransaction.begin()
        let anotherScale = CASpringAnimation(keyPath: "transform.scale")
        anotherScale.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        anotherScale.fromValue = NSValue(CGPoint: CGPointMake(1.5, 1.5))
        anotherScale.duration = 0.5
        anotherScale.beginTime = CACurrentMediaTime() + 2.6
        anotherScale.fillMode = kCAFillModeForwards
        anotherScale.removedOnCompletion = false
        anotherScale.fillMode = kCAFillModeForwards
        anotherScale.removedOnCompletion = false
        self.caAnimView.layer.addAnimation(anotherScale, forKey: nil)
        
        
        CATransaction.begin()
        let lastSpring = CASpringAnimation(keyPath: "position")
        lastSpring.fromValue = NSValue(CGPoint: self.view.center)
        lastSpring.toValue = NSValue(CGPoint: originalCenter)
        lastSpring.beginTime = CACurrentMediaTime() + 3.4
        lastSpring.initialVelocity = 10
        lastSpring.damping = 15.0
        lastSpring.removedOnCompletion = false
        lastSpring.fillMode = kCAFillModeForwards
        lastSpring.duration = 5
        lastSpring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        CATransaction.setCompletionBlock({
            self.caAnimView.center = originalCenter
            self.caAnimView.layer.removeAllAnimations()
            self.view.userInteractionEnabled = true
        })
        self.caAnimView.layer.addAnimation(lastSpring, forKey: nil)
        
        CATransaction.commit()
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderDidSlide(sender: UISlider) {
        
        print(self.testView.frame)
        let adjustedSender : CGFloat = CGFloat(sender.value) * self.testView.frame.width
        
        if adjustedSender <= self.testView.frame.width/2{
            print(sender.value)
            
            CATransaction.begin()
            let basicSpring = CABasicAnimation(keyPath:"cornerRadius")
            basicSpring.fromValue = testView.layer.cornerRadius
            basicSpring.toValue = adjustedSender
            basicSpring.duration = 0.01
            CATransaction.setCompletionBlock {
                    self.testView.layer.cornerRadius = CGFloat(adjustedSender)
            }
            self.testView.layer.addAnimation(basicSpring, forKey: "cR")
            CATransaction.commit()
            cornerRadiusLabel.text = "\(adjustedSender)"
        
        }else{
            self.testView.layer.removeAnimationForKey("cR")
            self.testView.layer.cornerRadius = self.testView.frame.width/2
            cornerRadiusLabel.text = "\(self.testView.layer.cornerRadius)"
        }
        
    }

}

extension UIViewController{
    func presetOpacity(view:UIView){
        view.layer.opacity = 0
    }
    
    func scaleView(targetView:UIView,fromX:CGFloat,fromY:CGFloat,toX:CGFloat,toY:CGFloat,strength:CGFloat,keyPath:String,duration:Double,delay:Double,withReveal:Bool){
        
        var group : CAAnimationGroup?
        if withReveal == true{
            group = CAAnimationGroup()
        }
        
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.toValue = NSValue(CGPoint: CGPointMake(toX, toY))
        scale.fromValue = NSValue(CGPoint: CGPointMake(fromX, fromY))
        scale.duration = duration
        scale.damping = strength
        scale.beginTime = CACurrentMediaTime() + delay
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.17, 0.67, 0.94, 1.54)
        //CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //CAMediaTimingFunction(controlPoints: 0.17, 0.67, 0.94, 1.54)
        if group != nil{
            scale.beginTime = delay
            
            let opacity = self.revealOpacityAnimation(1, duration: duration * 0.05, delay: 0)
            opacity.beginTime = delay
            opacity.removedOnCompletion = false
            opacity.fillMode = kCAFillModeForwards
            group?.animations = [scale,opacity]
            group?.duration = duration + delay
            group?.removedOnCompletion = false
            group?.fillMode = kCAFillModeForwards
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                targetView.layer.opacity = 1
                targetView.layer.removeAllAnimations()
                
            })
            targetView.layer.addAnimation(group!, forKey: "group")
            CATransaction.commit()
        }else{
            scale.beginTime = CACurrentMediaTime() + delay
            targetView.layer.addAnimation(scale, forKey: "transform.scale")
        }
        
    }
    
    func revealOpacityAnimation(desiredOpacity:Double,duration:Double,delay:Double)->CABasicAnimation{
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.toValue = desiredOpacity
        opacity.fromValue = 0
        opacity.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        // opacity.beginTime = CACurrentMediaTime() + delay
        opacity.duration = duration
        return opacity
    }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}


