//
//  MemoViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/09.
//

import UIKit
import SnapKit
import Toast

final class MemoViewController: UIViewController {
    var selectedMemo: Memo?
    var vm: DetailViewModel?
    weak var detailDelegate: DetailViewDelegate? //Detail ViewController
    let textView = {
        let view = UITextView()
        view.isEditable = true
        view.font = Design.fontDefault
        view.isScrollEnabled = true
        view.keyboardDismissMode = .onDrag
        
        
        return view
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        view.image = UIImage(systemName: "add")
        return view
    }()
    
    let datePicker = {
        let view = UIDatePicker()        
        return view
    }()
    
    @objc func saveButtonClicked(){
        print("MemoViewController-",#function)
        textView.resignFirstResponder()
        //add
        if selectedMemo == nil{
            vm?.addMemo(date: datePicker.date, contents: textView.text, handler: {
                //TODO: Literal
                let toast = Toast.text("📝메모가 추가되었습니다",config: .init(dismissBy: [.time(time: 2),.swipe(direction: .natural)]))
                toast.show(haptic: .success)
                self.navigationController?.popViewController(animated: true)
            })
        } else{ //update
            guard let selectedMemo = selectedMemo else {return}
            if vm?.updateMemo(memo: selectedMemo, date: datePicker.date, contents: textView.text) == true {
                let toast = Toast.text("📝메모가 변경되었습니다",config: .init(dismissBy: [.time(time: 2),.swipe(direction: .natural)]))
                toast.show(haptic: .success)
                self.detailDelegate?.reloadTableView()
                self.navigationController?.popViewController(animated: true)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set view
        view.addSubview(textView)
        view.addSubview(datePicker)
        textView.layer.cornerRadius = Design.paddingDefault

        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = Design.colorPrimaryBackground
        
        datePicker.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-Design.paddingDefault)
        }
        
        //load if data exists
        if selectedMemo != nil{
            datePicker.date = selectedMemo?.date ?? Date.now
            textView.text = selectedMemo?.contents
        }

    }
    

}
