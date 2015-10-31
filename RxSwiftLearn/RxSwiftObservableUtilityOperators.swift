//
//  RxSwiftObservableUtilityOperators.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift

func rxSwiftObservableUtilityOperators(){
    
    // doOn
    // 相当于 RAC 里面的 doNext,doError,doComplete 的集合,可以在信号的传递链中的任意位置设置 hook 而不改变信号本身
    example(false, name: "doOn"){
        let sourceSignal = PublishSubject<String>()
        
        
        let _ = sourceSignal.doOn(onNext: { (str) -> Void in
                        print("Next")
                    }, onError: { (error) -> Void in
                        print("Error")

                    }, onCompleted: { () -> Void in
                        print("Complete")
                }).subscribe{print($0)};
        
        
        sourceSignal.onNext("One")
        sourceSignal.onNext("Two")
        sourceSignal.onComplete()
    }

}