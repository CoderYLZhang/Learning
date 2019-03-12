//
//  ViewController.swift
//  Flo
//
//  Created by 张银龙 on 2019/3/8.
//  Copyright © 2019 yinlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Counter outlets
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    var isGraphViewShowing = false
    
    @IBOutlet weak var medalView: MedalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkTotal()
    }
    
    func checkTotal() {
        if counterView.counter >= 8 {
            medalView.showMedal(show: true)
        } else {
            medalView.showMedal(show: false)
        }
    }

    @IBAction func plusButtonPressed(_ sender: PushButton) {
        
        if isGraphViewShowing {
            counterViewTap(nil)
        }
        
        if sender.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        checkTotal()
    }
    
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            //hide Graph
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion:nil)
        } else {
            //show Graph
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
}

