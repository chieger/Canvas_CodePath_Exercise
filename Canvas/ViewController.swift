//
//  ViewController.swift
//  Canvas
//
//  Created by Charles Hieger on 5/22/15.
//  Copyright (c) 2015 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBOutlet weak var treyView: UIView!
    @IBOutlet weak var treyArrow: UIImageView!
    
    var treyInitialFrame: CGPoint!
    var treyUp: CGPoint!
    var treyDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var initialCenter: CGPoint!
    
    var scale = CGFloat(1.0)
    var rotation = CGFloat(0)
    var frictionDrag: CGFloat!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        treyUp = CGPoint(x: 0, y: 348)
        treyDown = CGPoint(x: 0, y: 521)
        treyView.frame.origin = treyDown
        treyArrow.transform = CGAffineTransformMakeRotation(CGFloat(180 * M_PI / 180))
        frictionDrag = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTreyView(sender: UIPanGestureRecognizer) {
        
        var treyLocation = sender.locationInView(view)
        var treyTranslation = (sender.translationInView(view))
        var treyVelocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            treyInitialFrame = treyView.frame.origin
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            if treyView.frame.origin.y < treyUp.y {
                treyInitialFrame = treyView.frame.origin
                sender.setTranslation(CGPointZero, inView: view)
                treyTranslation.y /= frictionDrag
                
            }
            
            treyView.frame.origin = CGPoint(x: treyInitialFrame.x, y:treyInitialFrame.y + treyTranslation.y)
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if treyVelocity.y < 0 {
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.treyView.frame.origin = self.treyUp
                    self.treyArrow.transform = CGAffineTransformMakeRotation(0)
                    
                    }, completion: nil)
                
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    self.treyView.frame.origin = self.treyDown
                    self.treyArrow.transform = CGAffineTransformMakeRotation(CGFloat(180 * M_PI / 180))
                    
                    }, completion: nil)
            }
        }
    }
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += treyView.frame.origin.y
            initialCenter = newlyCreatedFace.center
            
            var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanFaceCanvas:")
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "didPinchFaceCanvas:")
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            pinchGestureRecognizer.delegate = self;
            
            var rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "didRotateFaceCanvas:")
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            panGestureRecognizer.delegate = self;
            
            var doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didDoubleTapFaceCanvas:")
            doubleTapGestureRecognizer.numberOfTapsRequired = 2;
            newlyCreatedFace.addGestureRecognizer(doubleTapGestureRecognizer)
            
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(2.4, 2.4)
            })
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            newlyCreatedFace.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if newlyCreatedFace.center.y >= treyView.frame.origin.y {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.newlyCreatedFace.center = self.initialCenter
                    self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { (Bool) -> Void in
                        self.newlyCreatedFace.removeFromSuperview()
                })
                
            } else {
                
                UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                    self.newlyCreatedFace.transform = CGAffineTransformMakeScale(2, 2)
                })
            }
            
        }
        
    }
    func didPanFaceCanvas(panGestureRecognizer: UIPanGestureRecognizer) {
        var translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = panGestureRecognizer.view as! UIImageView
            initialCenter = newlyCreatedFace.center
            newlyCreatedFace.superview?.bringSubviewToFront(view)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
        }
    }
    
    func didPinchFaceCanvas(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        scale = pinchGestureRecognizer.scale
        newlyCreatedFace = pinchGestureRecognizer.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformScale(newlyCreatedFace.transform, scale, scale)
        pinchGestureRecognizer.scale = 1
        
        //updateTransform()
    }
    
    func didRotateFaceCanvas(rotationGestureRecognizer: UIRotationGestureRecognizer) {
        rotation = rotationGestureRecognizer.rotation
        newlyCreatedFace = rotationGestureRecognizer.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformRotate(newlyCreatedFace.transform, rotation)
        rotationGestureRecognizer.rotation = 0
    }
    
    func didDoubleTapFaceCanvas(doubleTapGestureRecognizer: UITapGestureRecognizer) {
        newlyCreatedFace = doubleTapGestureRecognizer.view as! UIImageView
        newlyCreatedFace.removeFromSuperview()
    }
    
    
    
}

