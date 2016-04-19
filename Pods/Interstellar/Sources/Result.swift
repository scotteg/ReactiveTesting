// Result.swift
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


/**
    A result contains the result of a computation or task. It might be either successfull
    with an attached value or a failure with an attached error (which conforms to Swift 2's
    ErrorType). You can read more about the implementation in
    [this blog post](http://jensravens.de/a-swifter-way-of-handling-errors/).
*/
public enum Result<T> {
    case Success(T)
    case Error(ErrorType)
    
    /**
        Initialize a result containing a successful value.
    */
    public init(success value: T) {
        self = Success(value)
    }
    
    /**
        Initialize a result containing an error
    */
    public init(error: ErrorType) {
        self = Error(error)
    }
    
    /**
        Transform a result into another result using a function. If the result was an error,
        the function will not be executed and the error returned instead.
    */
    public func map<U>(@noescape f: T -> U) -> Result<U> {
        switch self {
        case let .Success(v): return .Success(f(v))
        case let .Error(error): return .Error(error)
        }
    }
    
    /**
        Transform a result into another result using a function. If the result was an error,
        the function will not be executed and the error returned instead.
    */
    public func map<U>(f:(T, (U->Void))->Void) -> (Result<U>->Void)->Void {
        return { g in
            switch self {
            case let .Success(v): f(v){ transformed in
                    g(.Success(transformed))
                }
            case let .Error(error): g(.Error(error))
            }
        }
    }
    
    /**
        Transform a result into another result using a function. If the result was an error,
        the function will not be executed and the error returned instead.
    */
    public func flatMap<U>(@noescape f: T -> Result<U>) -> Result<U> {
        switch self {
        case let .Success(v): return f(v)
        case let .Error(error): return .Error(error)
        }
    }
    
    /**
    Transform a result into another result using a function. If the result was an error,
    the function will not be executed and the error returned instead.
    */
    public func flatMap<U>(@noescape f: T throws -> U) -> Result<U> {
        return flatMap { t in
            do {
                return .Success(try f(t))
            } catch let error {
                return .Error(error)
            }
        }
    }
    /**
        Transform a result into another result using a function. If the result was an error,
        the function will not be executed and the error returned instead.
    */
    public func flatMap<U>(f:(T, (Result<U>->Void))->Void) -> (Result<U>->Void)->Void {
        return { g in
            switch self {
            case let .Success(v): f(v, g)
            case let .Error(error): g(.Error(error))
            }
        }
    }
    
    /** 
        Call a function with the result as an argument. Use this if the function should be
        executed no matter if the result was a success or not.
    */
    public func ensure<U>(@noescape f: Result<T> -> Result<U>) -> Result<U> {
        return f(self)
    }
    
    /**
        Call a function with the result as an argument. Use this if the function should be
        executed no matter if the result was a success or not.
    */
    public func ensure<U>(f:(Result<T>, (Result<U>->Void))->Void) -> (Result<U>->Void)->Void {
        return { g in
            f(self, g)
        }
    }
    
    /**
        Direct access to the content of the result as an optional. If the result was a success,
        the optional will contain the value of the result.
    */
    public var value: T? {
        switch self {
        case let .Success(v): return v
        case .Error(_): return nil
        }
    }
    
    /**
        Direct access to the error of the result as an optional. If the result was an error,
        the optional will contain the error of the result.
    */
    public var error: ErrorType? {
        switch self {
        case Success: return nil
        case Error(let x): return x
        }
    }
    
    /**
        Access the value of this result. If the result contains an error, that error is thrown.
    */
    public func get() throws -> T {
        switch self {
        case let Success(value): return value
        case Error(let error): throw error
        }
    }
}


/**
    Provide a default value for failed results.
*/
public func ?? <T> (result: Result<T>, @autoclosure defaultValue: () -> T) -> T {
    switch result {
    case .Success(let x): return x
    case .Error: return defaultValue()
    }
}
