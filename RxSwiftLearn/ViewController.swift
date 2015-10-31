//
//  ViewController.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit
import RxSwift

func example(active:Bool,name:String,action:()->()){
    if active{
        print("----\(name) star ----")
        action()
        print("----\(name) end ----");
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rxSwiftObservableTest()
        rxSubjectLearn()
        rxSwiftTransforming()
        rxSwiftFiltering()
        rxSwiftCombing()
        rxSwiftErrorHanding()
        rxSwiftObservableUtilityOperators()
        rxSwiftBooleanOperators()
    }
}

