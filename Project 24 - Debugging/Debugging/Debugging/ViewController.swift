//
//  ViewController.swift
//  Debugging
//
//  Created by Mr.Kevin on 30/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    /// 1. Using print() for debuggnig:
    
    // print with string interpolation
//    let a = 50
//    print("Inside View didload, value of a is \(a)")
    
    // separator, lets you provide a string that should be placed between every item in the print() call.
//    print(1,2,3,4, separator: "-")    // 1-2-3-4
    
    // terminator, is what should be placed after the final item. It’s \n by default, which means “line break”.
//    print("Some message", terminator: ".")    // Some message.
    
    
    /// 2. Using assert() for debuging:
    
    // assertions, are debug-only checks that will force your app to crash if a specific condition isn't true.
    // The advantage to assertions is that their check code is never executed in a live app, so your users are never aware of their presence.
    // assert() takes two parameters: something to check, and a message to print out of the check fails.
//    assert(1 == 1, "Maths failure!")
//    assert(1 == 2, "Maths failure!")    // will cause a crash!!
    
    
    /// 3. Debugging with breakpoints:
    for i in 1...20 {
      print("nr: \(i)")
    }
  }


}

