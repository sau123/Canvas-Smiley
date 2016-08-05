//
//  ViewController.swift
//  Canvas-Smiley
//
//  Created by Saumeel Gajera on 8/4/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var smileyOriginalCenter: CGPoint!
    
    var trayCenterWhenUp: CGFloat!
    var trayCenterWhenDown: CGFloat!
    
    var isTrayClosed: Bool? = true
    
    var newlyCreatedFace: UIImageView!
    
    var scaleNewlyCreatedFace: CGFloat? = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayCenterWhenUp = view.frame.height - trayView.frame.height
        trayCenterWhenDown = view.frame.height - 44
        trayView.frame.origin.y = trayCenterWhenDown
//        trayView.frame.origin.y = trayCenterWhenDown
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onTrayTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        if isTrayClosed == false{
        trayView.frame.origin.y = trayCenterWhenDown
            isTrayClosed = true
        }else{
            trayView.frame.origin.y = trayCenterWhenUp
            isTrayClosed = false
        }
    }

    //gesture delegate. // to allow pinch to work before panning.
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.translationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let translation = point
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            let velocity = panGestureRecognizer.velocityInView(trayView)
            if velocity.y > 0 {
                trayView.frame.origin.y = trayCenterWhenDown
            }else{
                trayView.frame.origin.y = trayCenterWhenUp
            }
        }
    }
    
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
//        let velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            smileyOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransformMakeScale(scaleNewlyCreatedFace!+1, scaleNewlyCreatedFace!+1)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: smileyOriginalCenter.x + translation.x, y: smileyOriginalCenter.y + translation.y)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            newlyCreatedFace.transform = CGAffineTransformMakeScale(scaleNewlyCreatedFace!, scaleNewlyCreatedFace!)
        }
    }
    
    // custom pinch for the newly created smiley on parent view.
    func onCustomPinch(pinchGestureRecognizer: UIPinchGestureRecognizer){
        let scale = pinchGestureRecognizer.scale
        print("pinch scale factor : \(scale)")
        newlyCreatedFace.transform = CGAffineTransformMakeScale(scaleNewlyCreatedFace!+scale, scaleNewlyCreatedFace!+scale)
        
        if pinchGestureRecognizer.state == UIGestureRecognizerState.Ended{
            scaleNewlyCreatedFace = scale
        }
    }
    
    // custom rotate for the newly created smiley on parent view
    // not able to integrate this with pinch zoom
    func onCustomRotate(rotationGestureRecognizer: UIRotationGestureRecognizer){
        let rotation = rotationGestureRecognizer.rotation
        print("rotation gesture : \(rotation)")
        newlyCreatedFace.transform = CGAffineTransformMakeRotation(CGFloat(rotation * CGFloat(M_PI) / 180))
    }
    
    func onSmileyDoubleTap(doubleTapRecognizer: UITapGestureRecognizer){
        print("double tapped delegate func")
        newlyCreatedFace.removeFromSuperview()
    }
    
    
    @IBAction func onSmileyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.translationInView(self.view)

        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("smiley Gesture began at: \(point)")

            let imageView = panGestureRecognizer.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)

            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.x += trayView.frame.origin.x
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFace.userInteractionEnabled = true
            smileyOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.transform = CGAffineTransformMakeScale(2, 2)
            
            let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer1)

        }else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("smiley Gesture changed at: \(point)")
            let translation = point

            newlyCreatedFace.center = CGPoint(x: smileyOriginalCenter.x + translation.x, y: smileyOriginalCenter.y + translation.y)

        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("smiley Gesture ended at: \(point)")
            newlyCreatedFace.transform = CGAffineTransformMakeScale(1, 1)

            // would like to add the pinch gesture to the newlyCreatedface after it has panned.
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onCustomPinch:")
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            pinchGestureRecognizer.delegate = self
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "onSmileyDoubleTap:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(doubleTapRecognizer)
            doubleTapRecognizer.delegate = self
            
            /*
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "onCustomRotate:")
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            rotateGestureRecognizer.delegate = self
            */
            
        }
        
    }
    

}

