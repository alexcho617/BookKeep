//
//  ReadingViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import Foundation
import MagicTimer

enum TimerState{
    case on
    case off
}

class ReadingViewModel{
    let isbn: String
    let timer = MagicTimer()
    var currentTime: Observable<TimeInterval> = Observable(0.0)
    var timerState: Observable<TimerState>
    
    
    init(isbn: String) {
        self.isbn = isbn
        self.timerState = Observable(.off) //#VALUE FROM UserDefaults
        setTimer()
    }
    
    func setTimer(){
        timer.countMode = . stopWatch
        timer.defultValue = 0
        timer.effectiveValue = 1
        timer.timeInterval = 1
        timer.isActiveInBackground = true
        timer.observeElapsedTime = observe(time:)
    }
    
    func observe(time: TimeInterval) -> Void{
        //update view
        print("현재 시간:",currentTime.value)
        currentTime.value = time
        
    }
    
}
