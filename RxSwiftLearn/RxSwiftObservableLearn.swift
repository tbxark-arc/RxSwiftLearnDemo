//
//  RxSwiftObservableLearn.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/10/30.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift



func rxSwiftObservableTest(){
    example(false, name: "empty"){
        
        let signal : Observable<Int> = empty()
        let _ = signal.subscribe{print($0)}
        
        /*
        ----empty star ----
        Completed
        ----empty end ----
        */
    }
    
    
    example(false, name: "never"){
        let signal : Observable<Int> = never()
        let _ = signal.subscribe{print($0)}
        
        /*
        ----never star ----
        ----never end ----
        */
        
    }
    
    example(false, name: "just"){
        let signal : Observable<Int> = just(666)
        let _ = signal.subscribe{print($0)}
        
        /*
        ----just star ----
        Next(666)
        Completed
        ----just end ----
        */
        
    }
    
    example(false, name: "sequenceOf"){
        let signal : Observable<Int> = sequenceOf(1,2,3,4,5,6,7,8,9)
        let _ = signal.subscribe{print($0)}
        /*
        ----sequenceOf star ----
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Next(5)
        Next(6)
        Next(7)
        Next(8)
        Next(9)
        Completed
        ----sequenceOf end ----
        */
    }
    
    example(false, name: "asObservable"){
        let signal : Observable<Int> = [1,2,3,4,5,6,7,8,9].asObservable()
        let _ = signal.subscribe{print($0)}
        /*
        ----asObservable star ----
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Next(5)
        Next(6)
        Next(7)
        Next(8)
        Next(9)
        Completed
        ----asObservable end ----
        */
        
    }
    
    example(false, name: "create"){
        var createCount = 0
        var subcribeCount = 0
        let signal : Observable<Int> = create { observer in
            createCount++
            print("Create \(createCount) times")
            observer.on(.Next(1))
            observer.on(.Next(2))
            observer.on(.Next(3))
            observer.on(.Next(4))
            observer.on(.Completed)
            
            return NopDisposable.instance
        }
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        
        /*
        ----create star ----
        Subscribe 1 times
        Create 1 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        Subscribe 2 times
        Create 2 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        Subscribe 3 times
        Create 3 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        ----create end ----
        */
    }
    
    
    
    example(false, name: "failWith"){
        let error = NSError(domain: "None", code: 1, userInfo: nil)
        let signal : Observable<Int> = failWith(error)
        let _ = signal.subscribe{print($0)}
        /*
        ----failWith star ----
        Error(Error Domain=None Code=1 "(null)")
        ----failWith end ----
        */
    }
    
    
    example(false, name: "deferred"){
        
        var createCount   = 0
        var subcribeCount = 0
        var deferredCount  = 0
        let signal : Observable<Int> = deferred({ () -> Observable<Int> in
            deferredCount++
            print("Defrred \(deferredCount) times")
            return create { observer in
                createCount++
                print("Create \(createCount) times")
                observer.on(.Next(1))
                observer.on(.Next(2))
                observer.on(.Next(3))
                observer.on(.Next(4))
                observer.on(.Completed)
                
                return NopDisposable.instance
            }
        })
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        subcribeCount++
        print("Subscribe \(subcribeCount) times")
        let _ = signal.subscribe{print($0)}
        
        
        /*
        ----deferred star ----
        Subscribe 1 times
        Defrred 1 times
        Create 1 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        Subscribe 2 times
        Defrred 2 times
        Create 2 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        Subscribe 3 times
        Defrred 3 times
        Create 3 times
        Next(1)
        Next(2)
        Next(3)
        Next(4)
        Completed
        ----deferred end ----
        */
    }

}

