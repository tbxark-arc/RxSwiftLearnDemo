//
//  RxSwiftErrorHanding.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift

func rxSwiftErrorHanding(){
    
    // catchError
    // 在捕获到错误信号后返回指定信号
    
    example(false, name: "catchError"){
        let sequenceThatFails = PublishSubject<Int>()
        let recoverySequence = sequenceOf(100, 200, 300, 400)
        
        let _ = sequenceThatFails.catchError{_ in return recoverySequence}.subscribe {print("Common \($0)")}
        let _ = sequenceThatFails.catchErrorJustReturn(9999).subscribe{print("Just:\($0)")}
        
        sequenceThatFails.on(.Next(1))
        sequenceThatFails.on(.Next(2))
        sequenceThatFails.on(.Error(NSError(domain: "Test", code: 0, userInfo: nil)))

        /*
        ---- catchError star ----
        Common Next(1)
        Just:Next(1)
        Common Next(2)
        Just:Next(2)
        Common Next(100)
        Common Next(200)
        Common Next(300)
        Common Next(400)
        Common Completed
        Just:Next(9999)
        Just:Completed
        ---- catchError end ----
        */
    }
    
    // retry
    // 发生错误时重新订阅信号
    // retry : 可以无限重试
    // retry(maxAttemptCount: Int) : 可以指定重试次数
    example(false, name: "retry"){
        
        var sendError = true
        let sourceSignal : Observable<Int> = create{ observer in
            print("Create Signal")
            observer.on(.Next(1))
            observer.on(.Next(2))
            if sendError{
                let error = NSError(domain: "Test", code: 0, userInfo: nil)
                observer.onError(error)
                sendError = false
            }else{
                observer.onComplete()
            }
            return NopDisposable.instance
        }
        
        let _ = sourceSignal.retry().subscribe{print($0)}
        
        /*
        ----retry star ----
        Create Signal
        Next(1)
        Next(2)
        Create Signal
        Next(1)
        Next(2)
        Completed
        ----retry end ----
        */
    
    }
    
    
    
}