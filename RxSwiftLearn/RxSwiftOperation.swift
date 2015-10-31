//
//  RxSwiftTransforming.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift

// 信号的变形
func rxSwiftTransforming(){

    // map
    // 这些高阶函数就基本和 Swift 原生的功能和用法基本相似
    example( false, name: "map"){
        print("RxSwift Version:")
        let originalSequence = sequenceOf(Character("A"), Character("B"), Character("C"))
        let _ = originalSequence.map{$0.hashValue}.subscribe{print($0)}
        
        print("Swift Version:")
        let swiftOriginalSequence = [Character("A"), Character("B"), Character("C")]
        let _ = swiftOriginalSequence.map{$0.hashValue}.forEach{print($0)}
        /*
        ----map star ----
        RxSwift Version:
        Next(4799450059485597671)
        Next(4799450059485597672)
        Next(4799450059485597677)
        Completed
        Swift Version:
        4799450059485597671
        4799450059485597672
        4799450059485597677
        ----map end ----
        */
    }
    
    
    // flatMap
    // 这里的 flatMap 好像就有一些差异
    example(false, name: "flatMap"){
        print("RxSwift Version:")
        let array : [[Int]] = [[1,2,3],[4,5,6],[7,8,9]]
        let originalSequence = array.map{$0.asObservable()}.asObservable()
        let otherSequence = ["A","B","C","D","---"].asObservable()
        let _ = originalSequence.flatMap{ int in
                otherSequence
            }.subscribe{print($0)}

        print("Swift Version:")
        print(array.flatMap{$0.map{String($0)}})
        /*
        ----flatMap star ----
        RxSwift Version:
        Next(A)
        Next(B)
        Next(C)
        Next(D)
        Next(---)
        Next(A)
        Next(B)
        Next(C)
        Next(D)
        Next(---)
        Next(A)
        Next(B)
        Next(C)
        Next(D)
        Next(---)
        Completed
        Swift Version:
        ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        ----flatMap end ----
        */
    }
    
    // scan / reduce
    // sacn 会显示每次中间计算的结果
    // reduce 只会显示最终的计算结果
    // 归纳
    example( false, name: "scan / reduce"){
        print("RxSwift Version:")
        let sequenceToSum = sequenceOf(0, 1, 2, 3, 4, 5, 6)
        let _ = sequenceToSum.scan(0){$0+$1}.subscribe{print($0)}
        
        let _ = sequenceToSum.reduce(0){$0+$1}.subscribe{print($0)}
        
        print("Swift Version:")
        let array = [1,2,3,4,5,6]
        print("Sum : \(array.reduce(0){$0+$1})");
        
        /*
        ----scan / reduce star ----
        RxSwift Version:
        Next(0)
        Next(1)
        Next(3)
        Next(6)
        Next(10)
        Next(15)
        Next(21)
        Completed
        Next(21)
        Completed
        Swift Version:
        Sum : 21
        ----scan / reduce end ----

        */
    }
}



// 信号的筛选
func rxSwiftFiltering(){
    // filter
    // 过滤
    example(false, name: "filter"){
        let array = [1,2,3,4,5,6,7,8,9]
        
        print("RxSwift Version:")
        let _ = array.asObservable().filter{ $0%2 == 0}.subscribe{print($0)}
        
        print("Swift Version:")
        array.filter{$0%2 == 0}.forEach{print($0)}
        
        /*
        ----filter star ----
        RxSwift Version:
        Next(2)
        Next(4)
        Next(6)
        Next(8)
        Completed
        Swift Version:
        2
        4
        6
        8
        ----filter end ----
        */
    }
    
    
    // distinctUntilChanged
    // 和前一次的值比较,直到值发生改变才发出信号(这个改变的依据可以用闭包来进行自定义)
    example(false, name: "distinctUntilChanged"){
        let array = [1,1,2,2,1,1,3,3,4,4]
        
        let _ = array.asObservable().distinctUntilChanged().subscribe{print($0)}
        /*
        ----distinctUntilChanged star ----
        Next(1)
        Next(2)
        Next(1)
        Next(3)
        Next(4)
        Completed
        ----distinctUntilChanged end ----
        */
    }
    
    // take
    // 这是一个系列的函数
    // 1. public func take(count: Int) -> RxSwift.Observable<Self.E>
    //    获取几次信号,通常用法是个限定只用一次
    example(false, name: "take"){
        let array = [1,2,3,4,5,6,7,8,9]
        let _ = array.asObservable().take(3).subscribe{print($0)}
        
        /*
        ----take star ----
        Next(1)
        Next(2)
        Next(3)
        Completed
        ----take end ----
        */
    }
}

func rxSwiftCombing(){
    
    // startWith
    // 实质上实在原有Observables前面加上新的元素然后组成新的Observables,但是不改变原有Observables
    example(false, name: "startWith"){
        let originalSequence = [1,2,3,].asObservable().startWith(123)
        let _ = originalSequence.startWith(12).startWith(11).startWith(10).subscribe{print($0)}
        let _ = originalSequence.subscribe{print($0)}
        
        /*
        ----startWith star ----
        Next(0)
        Next(0)
        Next(0)
        Next(1)
        Next(2)
        Next(3)
        Completed
        Next(1)
        Next(2)
        Next(3)
        Completed
        ----startWith end ----
        */
    }
    
    
    // combineLatest
    // 将两个Observables组合成一个Observables, 条件是Observables必须有一个.Next ,然后combineLatest 就会将两个Observables最后的.Next 信号合在一起
    example(false, name: "combineLatest"){
        
        let pub1 = PublishSubject<Int>()
        let pub2 = PublishSubject<String>()
        
        let _ = combineLatest(pub1, pub2){ String($0) + "." + $1}.subscribe{print($0)}
        
        pub1.on(.Next(1))
        pub1.on(.Next(2))
        pub2.on(.Next("A"))
        pub2.on(.Next("B"))
        
        /*
        ----combineLatest star ----
        Next(2.A)
        Next(2.B)
        ----combineLatest end ----
        */
        
    }
    
    
    // zip
    // 按顺序一次组合,而不是像 combineLatest 选最后一个
    example(false, name: "zip"){
        let pub1 = PublishSubject<Int>()
        let pub2 = PublishSubject<String>()
        
        let _ = zip(pub1, pub2){ String($0) + "." + $1}.subscribe{print($0)}
        
        pub1.on(.Next(1))
        pub1.on(.Next(2))
        pub1.on(.Next(3))
        pub2.on(.Next("A"))
        pub1.on(.Next(4))
        pub2.on(.Next("B"))
        pub2.on(.Next("C"))
        pub2.on(.Next("D"))
        pub2.on(.Next("E"))
        pub2.on(.Next("F"))

        
        /*
        ----zip star ----
        Next(1.A)
        Next(2.B)
        Next(3.C)
        Next(4.D)
        ----zip end ----
        */
    }
    
    
    // merge
    // 可以想象成两个水管合并,两个Observables之间不发生组合,而是在同一个Observables中传递
    // 但是merge 不能将两个不同类 Observables 组合在一起(可以用 Any或 AnyObject 解决,但是不建议,可以对其中一个序列使用 map 从而使得两者类型相同)
    example(false, name: "merge"){
        
        let pub1 = PublishSubject<Int>()
        let pub2 = PublishSubject<Int>()
        
        let _  =  sequenceOf(pub1, pub2).merge().subscribe{print($0)}
        
        pub1.on(.Next(1))
        pub1.on(.Next(2))
        pub1.on(.Next(3))
        pub2.on(.Next(100))
        pub1.on(.Next(4))
        pub2.on(.Next(200))
        pub2.on(.Next(300))
        pub2.on(.Next(400))
        
        /*
        ----merge star ----
        Next(1)
        Next(2)
        Next(3)
        Next(100)
        Next(4)
        Next(200)
        Next(300)
        Next(400)
        ----merge end ----
        */
    }

    // contact
    // 一个信号完成后才能开始另一个信号,将两个信号头尾相接
    // 通常用在 网络请求后进行本地数据库写入
    example(false, name: "contact"){
        let var1 = BehaviorSubject(value: 0)
        let var2 = BehaviorSubject(value: 200)
        
        // var3 is like an Observable<Observable<Int>>
        let var3 = BehaviorSubject(value: var1)
        
        let _ = var3.concat().subscribe{print($0)}
        
        var1.on(.Next(1))
        var1.on(.Next(2))
        var1.on(.Next(3))
        var1.on(.Next(4))
        
        var3.on(.Next(var2))
        
        var2.on(.Next(201))
        
        var1.on(.Next(5))
        var1.on(.Next(6))
        var1.on(.Next(7))
        var1.on(.Completed)
        
        var2.on(.Next(202))
        var2.on(.Next(203))
        var2.on(.Next(204))
        
        /*
        ----contact star ----
        Next(0)
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Next(5)
        Next(6)
        Next(7)
        Next(201)
        Next(202)
        Next(203)
        Next(204)
        ----contact end ----
        */

    }
    
    
    // switchLatest
    // 解决信号中的信号问题
    
    example(false, name: "switchLatest"){
        let inner1 = Variable(1)
        
        //这个就是信号中的信号
        let container = Variable(inner1)
        
        
        print("Origin :")
        let _ = container.subscribe{print($0)}
        
        print("SwitchLatest :")
        let _ = container.switchLatest().subscribe{print($0)}
        
        /*
        ----switchLatest star ----
        Origin :
        Next(RxSwift.Variable<Swift.Int>)
        SwitchLatest :
        Next(1)
        ----switchLatest end ----
        */
    }
}



