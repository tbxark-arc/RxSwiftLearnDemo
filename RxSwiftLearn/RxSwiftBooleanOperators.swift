//
//  RxSwiftBooleanOperators.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift


func rxSwiftBooleanOperators(){

    // takeUntil 
    // 直到收到某个信号前,能一直发送信号,当收到 takeUntil 的后立即发送 complete 信号
    // 常用在 tableviewcell 中,当 cell 重用时避免信号重复
    
    example(false, name: "takeUntil"){
        let originalSequence = PublishSubject<Int>()
        let whenThisSendsNextWorldStops = PublishSubject<Int>()
        
        let _ = originalSequence.takeUntil(whenThisSendsNextWorldStops).subscribe {print($0)}
        
        originalSequence.on(.Next(1))
        originalSequence.on(.Next(2))
        originalSequence.on(.Next(3))
        originalSequence.on(.Next(4))
        
        whenThisSendsNextWorldStops.on(.Next(1))
        
        originalSequence.on(.Next(5))
    }
    
    // takeWhile
    // 通过 takeWhile 中的返回值类型为 Bool 的闭包来判断什么时候结束信号
    example(false, name: "takeWhile"){
        let sequence = PublishSubject<Int>()
        
        let _ = sequence.takeWhile { int in int < 4}.subscribe {print($0)}
        
        sequence.on(.Next(1))
        sequence.on(.Next(2))
        sequence.on(.Next(3))
        sequence.on(.Next(4))
        sequence.on(.Next(5))
    
    
    }
    


}