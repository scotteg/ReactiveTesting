// Threading.swift
//
// Copyright (c) 2015 Jens Ravens (http://jensravens.de)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
    Several functions that should make multithreading simpler.
    Use this functions together with Signal.ensure:
        Signal.ensure(Thread.main) // will create a new Signal on the main queue
*/
public final class Thread {
    #if os(Linux)
    #else
    /// Transform a signal to the main queue
    public static func main<T>(a: Result<T>, completion: Result<T>->Void) {
        queue(dispatch_get_main_queue())(a, completion)
    }
    #endif
    
    #if os(Linux)
    #else
    /// Transform the signal to a specified queue
    public static func queue<T>(queue: dispatch_queue_t) -> (Result<T>, Result<T>->Void) -> Void {
        return { a, completion in
            dispatch_async(queue){
                completion(a)
            }
        }
    }
    #endif
    
    #if os(Linux)
    #else
    /// Transform the signal to a global background queue with priority default
    public static func background<T>(a: Result<T>, completion: Result<T>->Void) {
        let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(q) {
            completion(a)
        }
    }
    #endif
}