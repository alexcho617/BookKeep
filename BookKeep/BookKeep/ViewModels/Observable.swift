//
//  Observable.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/27.
//
import Foundation

class Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [self] in
                listener?(value)
            }
            
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
