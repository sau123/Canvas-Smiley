//
//  ViewController.swift
//  Canvas-Smiley
//
//  Created by Saumeel Gajera on 8/4/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var smileyOriginalCenter: CGPoint!
    
    var trayCenterWhenUp: CGFloat!
    var trayCenterWhenDown: CGFloat!
    
    var isTrayClosed: Bool? = true
    
    var newlyCreatedFace: UIImageView!

    
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

    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.translationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            let translation = point
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
            let velocity = panGestureRecognizer.velocityInView(trayView)
            if velocity.y > 0 {
                trayView.frame.origin.y = trayCenterWhenDown
            }else{
                trayView.frame.origin.y = trayCenterWhenUp
            }
        }
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

        }else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("smiley Gesture changed at: \(point)")
            let translation = point

            newlyCreatedFace.center = CGPoint(x: smileyOriginalCenter.x + translation.x, y: smileyOriginalCenter.y + translation.y)

        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("smiley Gesture ended at: \(point)")

        }
        
    }
    

}

