//
//  RxSubjectLearn.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift


func writeSequenceToConsole<O: ObservableType>(name: String, sequence: O) {
   let _ = sequence.subscribe {print("Subscription: \(name), event: \($0)")}
}


func rxSubjectLearn(){
    
    //PublishSubject
    //不断往外发出信号,不管有没有人订阅(相当于热信号),当前时间点订阅的订阅者不能收到之前的信号
    example( false, name: "PublishSubject"){
        let subject = PublishSubject<String>()
        subject.onNext("A");
        writeSequenceToConsole("1", sequence: subject)
        subject.onNext("B");
        subject.onNext("C");
        writeSequenceToConsole("2", sequence: subject)
        subject.onNext("D");
        
        /*
        ----PublishSubject star ----
        Subscription: 1, event: Next(B)
        Subscription: 1, event: Next(C)
        Subscription: 1, event: Next(D)
        Subscription: 2, event: Next(D)
        ----PublishSubject end ----
        */
    }
    
    //ReplaySubject
    //虽然也是不断往外发出信号,不管有没有人订阅(相当于热信号),但是订阅者无论什么时候订阅都能收到缓冲区里的所有信号,因为ReplaySubject会保存这些结果,并且重播,bufferSize表示它最大可缓存信号的个数
    example(false, name: "ReplaySubject"){
        let subject =  ReplaySubject<String>.create(bufferSize: 1)
        subject.onNext("A");
        writeSequenceToConsole("1", sequence: subject)
        subject.onNext("B");
        subject.onNext("C");
        writeSequenceToConsole("2", sequence: subject)
        subject.onNext("D");
        /*
        ----ReplaySubject star ----
        Subscription: 1, event: Next(A)
        Subscription: 1, event: Next(B)
        Subscription: 1, event: Next(C)
        Subscription: 2, event: Next(C)
        Subscription: 1, event: Next(D)
        Subscription: 2, event: Next(D)
        ----ReplaySubject end ----
        */
    }

    
    //BehaviorSubject
    //再有信号发出之前订阅会收到一个默认的信号,在有信号之后订阅就收不到了
    example(false, name: "BehaviorSubject"){
        let subject =  BehaviorSubject(value: "Flag")
        writeSequenceToConsole("1", sequence: subject)
        subject.onNext("A")
        writeSequenceToConsole("2", sequence: subject)
        subject.onNext("B")
        subject.onComplete()
        
        /*
        ----BehaviorSubject star ----
        Subscription: 1, event: Next(Flag)
        Subscription: 1, event: Next(A)
        Subscription: 2, event: Next(A)
        Subscription: 1, event: Next(B)
        Subscription: 2, event: Next(B)
        Subscription: 1, event: Completed
        Subscription: 2, event: Completed
        ----BehaviorSubject end ----
        */
    }
    
    //Variable
    //将BehaviorSubject 快速装包
    /*
    public var value: E {
        get {
            return lock.calculateLocked {
                return _value
            }
        }
        set(newValue) {
            lock.performLocked {
                _value = newValue
            }
            self.subject.on(.Next(newValue))
        }
    }
    */

    example(false, name: "Variable"){
        let subject = Variable("Flag")
        writeSequenceToConsole("1", sequence: subject)
        subject.value = "A"
        writeSequenceToConsole("2", sequence: subject)
        subject.value = "B"
//        subject.value =
        /*
        ----Variable star ----
        Subscription: 1, event: Next(Flag)
        Subscription: 1, event: Next(A)
        Subscription: 2, event: Next(A)
        Subscription: 1, event: Next(B)
        Subscription: 2, event: Next(B)
        ----Variable end ----
        */
    }
}




