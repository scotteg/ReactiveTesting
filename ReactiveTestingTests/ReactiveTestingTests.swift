//
//  ReactiveTestingTests.swift
//  ReactiveTestingTests
//
//  Created by Scott Gardner on 4/19/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import XCTest
@testable import ReactiveTesting
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
  
  // 0.096s (3% stdev)
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
  
  /// 0.189s (3% stdev)
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
  
  /// 0.119s (6% stdev)
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
  
  // 0.140s (10% stdev)
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
  
  // 1.277s (6% stdev)
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
  
  // 1.897s (5% stdev)
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
  
  // 1.247s (4% stdev)
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
  
  // 1.562s (3% stdev)
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
  
  // 3.480s (5% stdev)
  func test_measure_RxSwift_3() {
    measureBlock {
      let observable = Variable(0)
      
      for _ in 1..<30 {
        _ = observable.asObservable().filter { $0 % 2 == 0 }.map(String.init).subscribeNext { _ in  }
      }
      
      for i in 1..<100000 {
        observable.value = i
      }
    }
  }
  
  // 11.036s (3% stdev)
  func test_measure_ReactiveCocoa_3() {
    measureBlock {
      let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
      
      for _ in 1..<30 {
        signal.filter{ $0 % 2 == 0 }.map(String.init).observeNext { _ in }
      }
      
      for i in 1..<100000 {
        observer.sendNext(i)
      }
    }
  }
  
  // 5.833s (2% stdev)
  func test_measure_Bond_3() {
    measureBlock {
      let observable = Observable(0)
      
      for _ in 1..<30 {
        observable.filter{ $0 % 2 == 0 }.map(String.init).observe { _ in }
      }
      
      for i in 1..<100000 {
        observable.next(i)
      }
    }
  }
  
  // 7.772s (3% stdev)
  func test_measure_Interstellar_3() {
    measureBlock {
      let signal = Interstellar.Signal<Int>()
      
      for _ in 1..<30 {
        signal.filter{ $0 % 2 == 0 }.map(String.init).next { _ in }
      }
      
      for i in 1..<100000 {
        signal.update(i)
      }
    }
  }
  
}
