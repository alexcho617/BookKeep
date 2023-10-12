//
//  ReadingViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import Foundation
import MagicTimer

enum ReadingState: String{
    case reading
    case standby
}

class ReadingViewModel{
    let isbn: String
    let timer = MagicTimer()
    var elapsedTime: Observable<TimeInterval> = Observable(0.0)
    var readingState: Observable<ReadingState>
    static var saveTime: TimeInterval = 0
    
    
    init(isbn: String) {
        self.isbn = isbn
        self.readingState = Observable(.standby) //#VALUE FROM UserDefaults
        setTimer()
        
    }
    
    func setTimer(){
        print(#function)
        timer.countMode = .stopWatch
        if let savedElapsedTime = UserDefaults.standard.value(forKey: UserDefaultsKey.LastElapsedTime.rawValue) as? TimeInterval {
            timer.defultValue = savedElapsedTime//시작 값?

        }else{
            timer.defultValue = 0 //시작 값?

        }
        timer.effectiveValue = 1 // 단위
        timer.timeInterval = 1 // 주기
        timer.isActiveInBackground = true
        timer.observeElapsedTime = observeTimeHandler(time:)
    }
    
  
    
    func observeTimeHandler(time: TimeInterval) -> Void{
        //update view
        elapsedTime.value = time + timer.defultValue//TODO: 이걸 지금 계속 더하고 있는게 문제임 사실 magictime package에서 나갔다 왔을때 기존 값이 사라지는게 원초적인 문제긴 함
//        print("현재 시간:",currentTime.value.converToValidFormat())
        //1초마다 저장
        UserDefaults.standard.set(elapsedTime.value, forKey: UserDefaultsKey.LastElapsedTime.rawValue)

        
        
    }
    
    func mainButtonClicked(){
        switch readingState.value{
            
        case .reading:
            print("Reading...")
            readingState.value = .standby
            timer.stop()
           
        case .standby:
            print("Standby")
            readingState.value = .reading
            timer.start()
        }
        
        UserDefaults.standard.set(readingState.value.rawValue, forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.set(isbn, forKey: UserDefaultsKey.LastISBN.rawValue)
        
    }
    
    //저장하지 않고 종료
    func exitProcedue(){
        timer.reset()
        elapsedTime.value = 0.0
        readingState.value = .standby
        UserDefaults.standard.set(readingState.value.rawValue, forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.set(elapsedTime.value, forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        UserDefaults.standard.set(isbn, forKey: UserDefaultsKey.LastISBN.rawValue)


    }
    
    deinit {
        print("ReadingVM Deinit")
    }
}


