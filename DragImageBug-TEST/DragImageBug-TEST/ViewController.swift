//
//  ViewController.swift
//  DragImageBug-TEST
//
//  Created by dnguyen on 5/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var redView: UIView!
    @IBOutlet var greenView: UIView!
    @IBOutlet var blueView: UIView!
    
    var colors = [UIView]()
    var layouts = [Layout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colors.append(redView)
        colors.append(greenView)
        colors.append(blueView)
        
        for color in self.colors {
            addGestures(color)
            
            // Doing a copy of the array (so that it contains its own values)
            var newLayout = Layout(center: color.center, tag: color.tag)
            layouts.append(newLayout)
        }

    }


    func addGestures(view: UIView){
        let panRec = UIPanGestureRecognizer(target: self, action: "draggedViewHandler:")
        view.addGestureRecognizer(panRec)
    }
    
    func draggedViewHandler(sender:UIPanGestureRecognizer){
        
        if(sender.state == .Began)
        {
            // If you drag the recently dropped view, this line will cause the view to jump back
            // to its original position that was layout in Autoview.  If you turn off Autolayout, it works fine.
            self.view.bringSubviewToFront(sender.view!)
        }
        
        // increase image size, add border, and bring to front
        sender.view!.transform = CGAffineTransformMakeScale(1.2, 1.2)
        sender.view!.layer.borderColor = UIColor.blackColor().CGColor
        sender.view!.layer.borderWidth = 1.5;
        
        
        // this drags the image
        var translation = sender.translationInView(self.view)
        sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        
        if(sender.state == .Ended) {
            
            // user lets go of touch
            UIView.animateWithDuration(0.3, animations: {
                
                var _activeLayout: CGPoint
                
                for layout in self.layouts {
                    if (layout.tag == sender.view!.tag) {
                        
                        _activeLayout = layout.center
                        
                        // swap the dragged image with the image it overlays
                        self.checkIfdraggedImageWithinBoundaries(sender.view!, activeLayout: _activeLayout)
                        
                        // resize image back to normal
                        sender.view!.transform = CGAffineTransformMakeScale(1, 1)
                        sender.view!.layer.borderWidth = 0.0;

                    }
                }
            })
        }

    }
    
    func checkIfdraggedImageWithinBoundaries(draggedView: UIView, activeLayout: CGPoint){
        
        var boundaryFound = false
        
        // loop through the layouts and find the one the user is overlaying
        for layout in layouts {
            if (layout.tag != draggedView.tag) {
                var differenceX = layout.center.x - draggedView.center.x
                var differenceY = layout.center.y - draggedView.center.y
                
                // find the abs (absolute value) difference
                if (abs(differenceX) <= 30 && abs(differenceY) <= 30) {
                    boundaryFound = true
                    
                    //println("in boundaries: \(draggedView.tag)")

                    // update array for the dragged image
                    var _cIndex1 = self.getColorIndex(draggedView.tag)!
                    colors[_cIndex1].center = layout.center!
                    
                    // update the layout array for the dragged image
                    var _lIndex1 = self.getLayoutIndex(draggedView.tag)!
                    layouts[_lIndex1].center = layout.center!
                    
                    
                    // update fighters array for the overlayed image
                    var _cIndex2 = self.getColorIndex(layout.tag!)!
                    colors[_cIndex2].center = activeLayout
                    
                    // update layout array for the overlayed image
                    var _lIndex2 = self.getLayoutIndex(layout.tag!)!
                    layouts[_lIndex2].center = activeLayout


                    
                }
            }
        }
        
        if(boundaryFound == false) {
            //println("not within any boundaries | dragged Tag: \(draggedView.tag)")
            draggedView.center = activeLayout
        }
    }

    func getColorIndex(tagId: Int) -> Int? {
        for color in self.colors {
            if( color.tag == tagId) {
                return find(self.colors, color)!
            }
        }
        
        return nil
    }
    
    func getLayoutIndex(tagId: Int) -> Int? {
        for layout in self.layouts {
            if( layout.tag == tagId) {
                return find(self.layouts, layout)
            }
        }
        
        return nil
    }

    
}

