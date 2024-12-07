//
//  SecondController.swift
//  SAA-Demo
//
//  Created by SAHIL AMRUT AGASHE on 04/12/24.
//

import RxSwift
import UIKit

class SecondController: UIViewController {
 
    var timer: Observable<Int>?
    var pollingDisposeBag = DisposeBag()
    private var pollingApiCalled = 0
    private var pollingIternval: Int = 2
    private var pollingTimeout: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        startPolling()
    }
    
    private func startPolling() {
        guard timer == nil else { return }
        Observable<Int>.interval(.seconds(pollingIternval), scheduler: MainScheduler.instance)
            .take(until: Observable<Int>.interval(.seconds(pollingTimeout), scheduler: MainScheduler.instance))
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self else { return }
                    self.makeApiCall()
                },
                onCompleted: {
                    print("Completed called..")
                }
            )
        .disposed(by: pollingDisposeBag)
    }
    
    private func makeApiCall() {
        pollingApiCalled = pollingApiCalled + Int(pollingIternval)
        print("Making api called", pollingApiCalled)
    }
    
    private func fetchDataAPI() -> Observable<String> {
        return Observable.just("Hi Sahil")
    }
}
