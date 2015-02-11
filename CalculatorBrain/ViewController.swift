//
//  ViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 2/5/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userAlreadyEnteredADecimalPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
//        println("digit = \(digit)");
        
        if userIsInTheMiddleOfTypingANumber {
//----- Уничтожаем лидирующие нули ---------------
            if (digit == "0") && ((display.text == "0") || (display.text == "-0"))
                                                                     { return }
            if (digit != ".") && ((display.text == "0") || (display.text == "-0"))
                                                  { display.text = digit ; return }
//--------------------------------------------------
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func decimalPoint(sender: UIButton) {
        if !userAlreadyEnteredADecimalPoint {
            appendDigit(sender)
            userAlreadyEnteredADecimalPoint = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // error?
                displayValue = 0  // задание 2
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
         userAlreadyEnteredADecimalPoint = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // error?
            displayValue = 0  // задание 2
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            let stack = brain.displayStack()
            if !stack!.isEmpty {
                history.text = stack! + " ="
            }
        }
    }

}

