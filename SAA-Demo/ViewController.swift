//
//  ViewController.swift
//  SAA-Demo
//
//  Created by SAHIL AMRUT AGASHE on 13/08/24.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import Combine

class ViewController: UIViewController {

    // MARK: RxSwift Properties
    private let aObservable = Observable<Int>.create { (observer: AnyObserver<Int>) in
        observer.onNext(10)
        observer.onNext(20)
        observer.onNext(30)
        //observer.onError(NSError())
        observer.onCompleted()
        return Disposables.create()
    }
    
    // MARK: Combine Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        runYourCode()
    }

    // MARK: - Run Your Code
    private func runYourCode() {
        //aObservableDemo()
        //publishSubjectDemo()
        //publishSubjectDemoSecond()
        //behaviourSubjectDemo()
        //replaySubjectDemo()
        //publicRelayDemo()
        
        //currentValueSubjectDemo()
        //passthroughSubjectDemo()
        
        //ignoreElementsDemo()
        //elementAtDemo()
        filterDemo()
    }
    
    // MARK: - Analysis
    
    private func analysis() {

        /*
         PublishSubject from RxSwift is similar to
         PassthroughSubject from Combine
         */
        
        /*
         BehaviorSubject from RxSwift is similar to
         CurrentValueSubject from Combine
         */
    }
    
    // MARK: - RxSwift
    private func aObservableDemo() {
        // First subscription
        aObservable.subscribe(onNext: {debugPrint("On Next Called , Value =>", $0)},
                              onError: {debugPrint($0)},
                              onCompleted: {debugPrint("On Completed Called...")},
                              onDisposed: {debugPrint("On Disposed Called...")}).disposed(by: DisposeBag())
        
        // Second subscription by observerSecond
        let observerSecond = aObservable.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("observerSecond next event called , value => \(nextEventValue)")
            case .completed: debugPrint("observerSecond completed event called")
            case .error(_): debugPrint("observerSecond error event called")
            }
        }
        
        observerSecond.disposed(by: DisposeBag())
    }
    
    /// A PublishSubject only emits to current subscribers.
    /// So if you weren't subscribed to it when something was added to it previously, you don't get it when you do subscribe.
    private func publishSubjectDemo() {
        let pubSubject = PublishSubject<String>()
        pubSubject.onNext("Is anyone listening?")
        
        let subscriptionOne = pubSubject.subscribe { (event: Event<String>) in
            switch event {
            case .next(let nextEventValue): debugPrint("SubscriptionOne next event called , value => \(nextEventValue)")
            case .completed: debugPrint("SubscriptionOne completed event called")
            case .error(_): debugPrint("SubscriptionOne error event called")
            }
        }
        //subscriptionOne.disposed(by: DisposeBag())
        
        let subscriptionTwo = pubSubject.subscribe(
            onNext: {debugPrint("SubscriptionTwo onNext called ->", $0)},
            onError: {debugPrint($0)},
            onCompleted: {debugPrint("SubscriptionTwo onCompleted called.")},
            onDisposed: {debugPrint("SubscriptionTwo onDisposed called")}
        )
        
        print(subscriptionOne)
        print(subscriptionTwo)
        
        pubSubject.onNext("1")
        subscriptionTwo.disposed(by: DisposeBag())
        pubSubject.onNext("2")
        pubSubject.onCompleted()
        
        let subscriptionThree = pubSubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("SubscriptionThree next event called , value => \(nextEventValue)")
            case .completed: debugPrint("SubscriptionThree completed event called")
            case .error(_): debugPrint("SubscriptionThree error event called")
            }
        }
        
        print(subscriptionThree)
    }
    
    private func publishSubjectDemoSecond() {
        let pubSub1 = PublishSubject<String>()
        
        let subscriptionOne = pubSub1.subscribe { (event: Event<String>) in
            switch event {
            case .next(let nextEventValue): debugPrint("pubSub1 next event called , value => \(nextEventValue)")
            case .completed: debugPrint("pubSub1 completed event called")
            case .error(_): debugPrint("pubSub1 error event called")
            }
        }
        
        let pubSub2 = PublishSubject<String>()
        
        let subscriptionTwo = pubSub2.subscribe { (event: Event<String>) in
            switch event {
            case .next(let nextEventValue): debugPrint("pubSub2 next event called , value => \(nextEventValue)")
            case .completed: debugPrint("pubSub2 completed event called")
            case .error(_): debugPrint("pubSub2 error event called")
            }
        }
        
        let specialSubscription = pubSub1.subscribe(pubSub2)
        
        //pubSub2.onNext("Hey Hi, I am Sahil")
        pubSub1.onNext("What's up Sahil")
        

        print(subscriptionOne, subscriptionTwo , specialSubscription)
    }
    
    private func behaviourSubjectDemo() {
        let behaviourSubject = BehaviorSubject<Int>(value: 0)
        
        behaviourSubject.onNext(2)
        behaviourSubject.onNext(15)
        
        let firstSubscriber = behaviourSubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("firstSubscriber next event called , value => \(nextEventValue)")
            case .completed: debugPrint("firstSubscriber completed event called")
            case .error(_): debugPrint("firstSubscriber error event called")
            }
        }
            
        //firstSubscriber.disposed(by: DisposeBag())
        
        behaviourSubject.onNext(20)
        behaviourSubject.onNext(25)
        
        let secondSubscriber = behaviourSubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("secondSubscriber next event called , value => \(nextEventValue)")
            case .completed: debugPrint("secondSubscriber completed event called")
            case .error(_): debugPrint("secondSubscriber error event called")
            }
        }
        
        behaviourSubject.onNext(30)
        behaviourSubject.onNext(50)
        
        let thirdSubscriber = behaviourSubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("thirdSubscriber next event called , value => \(nextEventValue)")
            case .completed: debugPrint("thirdSubscriber completed event called")
            case .error(_): debugPrint("thirdSubscriber error event called")
            }
        }
        
        print(firstSubscriber, secondSubscriber , thirdSubscriber)
    }
    
    private func replaySubjectDemo() {
        let replySubject = ReplaySubject<Int>.create(bufferSize: 2)
        replySubject.onNext(1)
        replySubject.onNext(2)
        replySubject.onNext(20)
        replySubject.onNext(25)
        
        let subscriberOne = replySubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("subscriberOne next event called , value => \(nextEventValue)")
            case .completed: debugPrint("subscriberOne completed event called")
            case .error(_): debugPrint("subscriberOne error event called")
            }
        }
        
        replySubject.onNext(26)
        replySubject.onNext(28)
        replySubject.onNext(35)
        
        let subscriberTwo = replySubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("subscriberTwo next event called , value => \(nextEventValue)")
            case .completed: debugPrint("subscriberTwo completed event called")
            case .error(_): debugPrint("subscriberTwo error event called")
            }
        }
        
        replySubject.onNext(100)
        replySubject.onError(NSError())
        replySubject.disposed(by: DisposeBag())
        
        let subscriberThree = replySubject.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("subscriberThree next event called , value => \(nextEventValue)")
            case .completed: debugPrint("subscriberThree completed event called")
            case .error(_): debugPrint("subscriberThree error event called")
            }
        }
        
        replySubject.onNext(1)
        print(subscriberOne, subscriberTwo, subscriberThree)
    }
    
    /// PublishRelay and BehaviourRelay are wrap their corresponding subjects, but only accept .next events.
    /// You cannot add .completed or .error event onto relays at all.
    /// So they are great for non-terminating sequences.
    private func publicRelayDemo() {
        let pubRelay = PublishRelay<Int>()
        pubRelay.accept(-5)
        
        let subscriberOne = pubRelay.asObservable().subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("subscriberOne next event called , value => \(nextEventValue)")
            case .completed: debugPrint("subscriberOne completed event called")
            case .error(_): debugPrint("subscriberOne error event called")
            }
        }
        
        pubRelay.accept(10)
        pubRelay.accept(20)
        
        let subscriberTwo = pubRelay.subscribe { event in
            switch event {
            case .next(let nextEventValue): debugPrint("subscriberTwo next event called , value => \(nextEventValue)")
            case .completed: debugPrint("subscriberTwo completed event called")
            case .error(_): debugPrint("subscriberTwo error event called")
            }   
        }
        
        pubRelay.accept(50)
        
        print(subscriberOne, subscriberTwo)
    }
    
    // MARK: - Combine
    private func currentValueSubjectDemo() {
        let currentValueSub = CurrentValueSubject<String, Never>.init("Hi")
        
        let subscriber1: () = currentValueSub.sink { str in
            print("Subscriber1: value received => \(str)")
        }.store(in: &cancellables)
        
        //currentValueSub.send(completion: .finished)
        
        currentValueSub.send("Sahil , How are you?")
        
        let subscriber2: () = currentValueSub.sink { str in
            print("Subscriber2: value received => \(str)")
        }.store(in: &cancellables)
        
        let subscriber3: () = currentValueSub.sink { str in
            print("Subscriber3: value received => \(str)")
        }.store(in: &cancellables)
        
        currentValueSub.send("What's up")
        currentValueSub.send("Believe That!")
    }
    
    private func passthroughSubjectDemo() {
        let passthroughSub = PassthroughSubject<String, Never>()
        
        let subscriber1 = passthroughSub.sink { str in
            print("Subscriber1: value received => \(str)")
        }.store(in: &cancellables)
        
        passthroughSub.send("Sahil, How are you???")
        //passthroughSub.send(completion: .finished)
        
        let subscriber2: () = passthroughSub.sink { str in
            print("Subscriber2: value received => \(str)")
        }.store(in: &cancellables)
        
        let subscriber3: () = passthroughSub.sink { str in
            print("Subscriber3: value received => \(str)")
        }.store(in: &cancellables)
        
        passthroughSub.send("What's up")
        passthroughSub.send("Believe That!")
    }

}

// MARK: - Filtering Operators
extension ViewController {
    func ignoreElementsDemo() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        
        strikes
            .ignoreElements()
            .subscribe(onNext: { (a: Never) in
                print("Hi next event!")
            }, onCompleted: {
                print("You are out!")
            })
            .disposed(by: disposeBag)
        
        strikes.onNext("X")
        strikes.onNext("Y")
        strikes.onNext("Z")
        
        strikes.onCompleted()
    }
    
    func elementAtDemo() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        
        strikes
            .element(at: 2)
            .subscribe(onNext: { str in
                print("String is \(str)")
            })
            .disposed(by: disposeBag)
        
        strikes.onNext("0")
        strikes.onNext("1")
        strikes.onNext("2")
        strikes.onNext("3")
        
    }
    
    func filterDemo() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
            .filter({$0 % 2 == 0})
            .subscribe(onNext: { val in
                print("Value is \(val)")
            })
            .disposed(by: disposeBag)
    }
}
