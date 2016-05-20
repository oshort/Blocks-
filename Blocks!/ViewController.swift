//
//  ViewController.swift
//  Blocks!
//
//  Created by Oliver Short on 5/20/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Blocks
    
    //Our blocks - these are created progrmatically, using lazy var's, which means they aren't created until they are absolutely needed, and can make the system run more quickly. Because of this, the syntax for writing 'lazy' variables is a bit different that normal ones.
    
    lazy var greenBlock: UIView = {
        let view = UIView(frame: CGRect(x: self.view.center.x + 20, y: self.view.center.y + -100, width: 100.0, height: 100.0))
        view.backgroundColor = .greenColor()
        return view
    }()
    
    lazy var blueBlock: UIView = {
        let view = UIView(frame: CGRect(x: self.view.center.x + 100, y: self.view.center.y - 100, width: 50.0, height: 50.0))
        view.backgroundColor = .blueColor()
        return view
    }()
    
    lazy var redBlock: UIView = {
        let view = UIView(frame: CGRect(x:self.view.center.x + 20, y: self.view.center.y - 200, width: 25.0, height: 25.0))
        view.backgroundColor = .redColor()
        return view
    }()
    
    lazy var purpleBlock: UIView = {
        let view = UIView(frame: CGRect(x:self.view.center.x + 30, y: self.view.center.y - 300, width: 40.0, height: 40.0))
        view.backgroundColor = .purpleColor()
        return view
    }()
    
    //Create the animator to be used in the VDL
    var animator : UIDynamicAnimator?
    
    //Gravity Behavior and Vector configurations for rotations. The positive value is for falling down, and the negative value is for falling up
    
    var gravityBehavior : UIGravityBehavior?
    lazy var regularGravityVector : CGVector = {
        CGVector(dx: 0, dy: 1.0)
    }()
    lazy var invertedGravityVector : CGVector = {
        CGVector(dx: 0, dy: -1.0)
    }()
    
    //Boundary collision behavior for the entire system, including the boundary of the superview, and the edges of the views themselves
    var boundaryCollisionBehavior: UICollisionBehavior?
    
    //Elasticity behavior for the system. This affects how "bouncy" the blocks are
    var elasticityBehavior: UIDynamicItemBehavior?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
        
        //Add our blocks
        
        func addBlocks(){
        
        view.addSubview(greenBlock)
        view.addSubview(blueBlock)
        view.addSubview(redBlock)
        view.addSubview(purpleBlock)
            
        }
        addBlocks()
        //Put them into an items array
        let blocks = [greenBlock, blueBlock, redBlock,purpleBlock]
        
        //Initialize our animator relative to its view
        animator = UIDynamicAnimator(referenceView: view)
        
        //Define the gravity behvaior for our system
        gravityBehavior = UIGravityBehavior(items: blocks)
        
        //Define the collision behavior for our system
        boundaryCollisionBehavior = UICollisionBehavior(items: blocks)
        boundaryCollisionBehavior?.translatesReferenceBoundsIntoBoundary = true
        
        //Define the elasticity for our system
        elasticityBehavior = UIDynamicItemBehavior(items: blocks)
        elasticityBehavior?.elasticity = 0.8
        
        //Add everything to our animator
        animator?.addBehavior(gravityBehavior!)
        animator?.addBehavior(boundaryCollisionBehavior!)
        animator?.addBehavior(elasticityBehavior!)
        
    }
    
    func orientationChanged(notification: NSNotification){
        if let device = notification.object as? UIDevice{
            switch device.orientation {
            case .Portrait:
                portraitOrientationChange()
                
            case .PortraitUpsideDown:
                portraitUpsideDownOrientationChange()
            default:
                return
            }
        }
    }
    
    func portraitOrientationChange() {
        gravityBehavior?.gravityDirection = regularGravityVector
    }
    
    func portraitUpsideDownOrientationChange(){
        gravityBehavior?.gravityDirection = invertedGravityVector
    }
    
}

