//
//  RxSwiftConnectableOperators.swift
//  RxSwiftLearn
//
//  Created by Tbxark on 15/11/2.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import Foundation
import RxSwift

func delay(time:Double,action:()->Void){
    let times : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,Int64(time * Double(NSEC_PER_SEC)));
    dispatch_after(times, dispatch_get_main_queue(), action)
}


func rxSwiftConnectableOperators(){
    // interval : 工具类定时器
    example(false, name: "inrerval"){
        let timer = interval(1, MainScheduler.sharedInstance)
        let _ = timer.subscribeNext{print("First Subscribe \($0)")};
        delay(10){
            let _ = timer.subscribeNext{print("Second Subscribe \($0)")};
        }
    }
    
    
    example(false, name: "multicast"){
        let publish = PublishSubject<String>()
        let _ = publish.subscribeNext{print("Subscribe \($0)")}
        let inter = interval(1, MainScheduler.sharedInstance).map{String($0)}.multicast(publish)
        let _ = inter.subscribe{"First : \($0)"}
        delay(2){
            print("Connect")
            inter.connect()
        }
        delay(4){
            let _ = inter.subscribe{"Second : \($0)"}
        }
        
    
    }
}
