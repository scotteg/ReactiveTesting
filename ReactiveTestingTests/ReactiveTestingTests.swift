//
//  ReactiveTestingTests.swift
//  ReactiveTestingTests
//
//  Created by Scott Gardner on 4/19/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import XCTest
import RxSwift
import ReactiveCocoa
import Result
import Bond
import Interstellar

class ReactiveTestingTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  ////////////////////////////////////////////
  
  // 0.082s (7% stdev)
  func test_measure_RxSwift_1() {
    measureBlock {
      var counter = 0
      let observable = Variable(0)
      _ = observable.asObservable().subscribeNext { counter += $0 }
      
      for i in 1..<100000 {
        observable.value = i
      }
    }
  }
  
  /// 0.209s (5% stdev)
  func test_measure_ReactiveCocoa_1() {
    measureBlock {
      var counter = 0
      let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
      signal.observeNext { counter += $0 }
      
      for i in 1..<100000 {
        observer.sendNext(i)
      }
    }
  }
  
  /// 0.124s (6% stdev)
  func test_measure_Bond_1() {
    measureBlock {
      var counter = 0
      let observable = Observable(0)
      observable.observe { counter += $0 }
      
      for i in 1..<100000 {
        observable.next(i)
      }
    }
  }
  
  // 0.147s (4% stdev)
  func test_measure_Interstellar_1() {
    measureBlock {
      var counter = 0
      let signal = Interstellar.Signal<Int>()
      signal.next { counter += $0 }
      
      for i in 1..<100000 {
        signal.update(i)
      }
    }
  }
  
  ////////////////////////////////////////////
  
  // 1.205s (9% stdev)
  func test_measure_RxSwift_2() {
    measureBlock {
      var counter = 0
      let observable = Variable(0)
      
      for _ in 1..<30 {
        _ = observable.asObservable().subscribeNext { counter += $0 }
      }
      
      for i in 1..<100000 {
        observable.value = i
      }
    }
  }
  
  // 2.147s (5% stdev)
  func test_measure_ReactiveCocoa_2() {
    measureBlock {
      var counter = 0
      let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
      
      for _ in 1..<30 {
        signal.observeNext { counter += $0 }
      }
      
      for i in 1..<100000 {
        observer.sendNext(i)
      }
    }
  }
  
  // 1.281s (4% stdev)
  func test_measure_Bond_2() {
    measureBlock {
      var counter = 0
      let observable = Observable(0)
      
      for _ in 1..<30 {
        observable.observe { counter += $0 }
      }
      
      for i in 1..<100000 {
        observable.next(i)
      }
    }
  }
  
  // 1.823s (3% stdev)
  func test_measure_Interstellar_2() {
    measureBlock {
      var counter = 0
      let signal = Interstellar.Signal<Int>()
      
      for _ in 1..<30 {
        signal.next { counter += $0 }
      }
      
      for i in 1..<100000 {
        signal.update(i)
      }
    }
  }
  
  ////////////////////////////////////////////
  
  // 1.787s (6% stdev)
  func test_measure_RxSwift_3() {
    measureBlock {
      let observable = Variable(0)
      
      for _ in 1..<30 {
        _ = observable.asObservable().filter { $0 % 2 == 0 }.map { $0 }.subscribeNext { _ in  }
      }
      
      for i in 1..<100000 {
        observable.value = i
      }
    }
  }
  
  // 8.009s (2% stdev)
  func test_measure_ReactiveCocoa_3() {
    measureBlock {
      let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
      
      for _ in 1..<30 {
        signal.filter{ $0 % 2 == 0 }.map { $0 }.observeNext { _ in }
      }
      
      for i in 1..<100000 {
        observer.sendNext(i)
      }
    }
  }
  
  // 5.367s (3% stdev)
  func test_measure_Bond_3() {
    measureBlock {
      let observable = Observable(0)
      
      for _ in 1..<30 {
        observable.filter{ $0 % 2 == 0 }.map { $0 }.observe { _ in }
      }
      
      for i in 1..<100000 {
        observable.next(i)
      }
    }
  }
  
  // 6.619s (2% stdev)
  func test_measure_Interstellar_3() {
    measureBlock {
      let signal = Interstellar.Signal<Int>()
      
      for _ in 1..<30 {
        signal.filter{ $0 % 2 == 0 }.map { $0 }.next { _ in }
      }
      
      for i in 1..<100000 {
        signal.update(i)
      }
    }
  }
  
}
