//
//  ReadingViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import Foundation
import MagicTimer

enum ReadingState{
    case reading
    case standby
}

class ReadingViewModel{
    let isbn: String
    let timer = MagicTimer()
    var currentTime: Observable<TimeInterval> = Observable(0.0)
    var timerState: Observable<ReadingState>
    
    
    init(isbn: String) {
        self.isbn = isbn
        self.timerState = Observable(.standby) //#VALUE FROM UserDefaults
        setTimer()
        
    }
    
    func setTimer(){
        timer.countMode = .stopWatch
        timer.defultValue = 0 //시작 값?
        timer.effectiveValue = 1 // 단위
        timer.timeInterval = 1 // 주기
        timer.isActiveInBackground = true
        timer.observeElapsedTime = observeTimeHandler(time:)
        //timer에 차이를 추가하는 기능이 없으니 effectiveValue를 조절하는 방식으로 사용해보자? 1번만 더해질거란걸 보장 할 수 있나?
    }
    
    func addTime(by: TimeInterval){
        
    }
    
    func observeTimeHandler(time: TimeInterval) -> Void{
        //update view
        currentTime.value = time
//        print("현재 시간:",currentTime.value.converToValidFormat())
        
        
    }
    
    func mainButtonClicked(){
        switch timerState.value{
        case .reading:
            print("Reading...")
            timerState.value = .standby
            timer.stop()
        case .standby:
            print("Standby")
            timerState.value = .reading
            timer.start()
        }
    }
    
    func stopButtonClicked(){
//        print(#function)
        timer.reset()
        currentTime.value = 0.0
        timerState.value = .standby
    }
    
    //다 날림
    func exitProcedue(){
        timer.reset()
        currentTime.value = 0.0
        timerState.value = .standby
    }
    
    deinit {
        print("ReadingVM Deinit")
    }
}


