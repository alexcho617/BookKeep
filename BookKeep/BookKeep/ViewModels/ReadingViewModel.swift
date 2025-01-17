//
//  ReadingViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import Foundation
import MagicTimer
import RealmSwift

enum ReadingState: String{
    case reading
    case standby
}

class ReadingViewModel{
    var isbn: String
    var book: Observable<RealmBook?> = Observable(nil)
    let startTime = Date()
    let timer = MagicTimer()
    var elapsedTime: Observable<TimeInterval> = Observable(0.0)
    var readingState: Observable<ReadingState> = Observable(ReadingState.standby)
    
    
    init(isbn: String) {
        self.isbn = isbn
        self.readingState = Observable(.standby)
        fetchBookFromRealm(isbn: self.isbn)
        setTimer()
        
    }
    
    //TODO: Timer 시작하지 않는 이슈
    func setTimer(){
        print(#function)
        timer.countMode = .stopWatch
        timer.defultValue = 0 //시작 값
        timer.effectiveValue = 1 // 단위
        timer.timeInterval = 1 // 주기
        timer.isActiveInBackground = true
//        timer.observeElapsedTime = observeTimeHandler(time:)
        UserDefaults.standard.set(isbn, forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.set(startTime, forKey: UserDefaultsKey.LastStartTime.rawValue)

        // Set up event handlers
        timer.lastStateDidChangeHandler = { state in
            print("Timer state changed: \(state)")
        }

        timer.elapsedTimeDidChangeHandler = { time in
            print("Elapsed time updated: \(time)")
            self.elapsedTime.value = time
            UserDefaults.standard.set(time, forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        }
        mainButtonClicked()
    }
//      
//    func observeTimeHandler(time: TimeInterval) -> Void{
//        //update view
//        elapsedTime.value = time
//        //1초마다 저장
//        //⚠️TODO: Timer라벨이 업데이트 안되는 이슈. 
//        print(#function, time)
//        UserDefaults.standard.set(elapsedTime.value, forKey: UserDefaultsKey.LastElapsedTime.rawValue)
//    }
//    
    func mainButtonClicked(){
        print(#function, timer.elapsedTime)
        switch readingState.value{
        case .reading:
            readingState.value = .standby
            timer.stop()
           
        case .standby:
            readingState.value = .reading
            timer.start()
        }
        UserDefaults.standard.set(readingState.value.rawValue, forKey: UserDefaultsKey.LastReadingState.rawValue)
        
    }
    
    //저장하지 않고 종료
    func abortReading(){
        timer.reset()
        elapsedTime.value = 0.0
        readingState.value = .standby
        clearUD()
    }
    
    func addSession(startTime: Date, endPage: Int, duration: Double, handler: @escaping () -> Void){
        //add to realm
        let newSession = ReadSession(startTime: startTime, endPage: endPage, duration: duration)
        let realm = Realm.safeInit()
        try! realm?.write {
            book.value?.readSessions.append(newSession)
        }
        handler()
    }
    
    //미사용 함수
    func saveCurrentStatusToUD(){
        UserDefaults.standard.set(readingState.value.rawValue, forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.set(elapsedTime.value, forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        UserDefaults.standard.set(isbn, forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.set(startTime, forKey: UserDefaultsKey.LastStartTime.rawValue)

    }
    
    func clearUD(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastStartTime.rawValue)
        print("DEBUG: UD is Cleared")
     }
    
    func fetchBookFromRealm(isbn: String) {
        do {
            try book.value = BooksRepository.shared.fetchBookByPK(isbn: isbn)
        } catch {
            print(error)
        }
    }
    
    deinit {
        print("ReadingVM Deinit")
    }
}


