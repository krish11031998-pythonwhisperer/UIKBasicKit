//
//  ViewController.swift
//  UIKBasicKit
//
//  Created by 56647167 on 07/14/2023.
//  Copyright (c) 2023 56647167. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private lazy var tableView: UITableView = { .init() }()
    private lazy var stackView: UIStackView = { .VStack(spacing: 8) }()
    private var collectionButton: UIButton!
    private var tableButton: UIButton!
    
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        view.addSubview(stackView)
        stackView.fillSuperview(inset: .init(by: 32))
        
        stackView.insetsLayoutMarginsFromSafeArea = true
        
        collectionButton = UIButton()
        collectionButton.setTitle("Collection", for: .normal)
        collectionButton.backgroundColor = .red
        collectionButton.titleLabel?.textColor = .white
        collectionButton.setHeight(height: 44)
        
        tableButton = UIButton()
        tableButton.setTitle("Table", for: .normal)
        tableButton.backgroundColor = .blue
        tableButton.titleLabel?.textColor = .white
        tableButton.setHeight(height: 44)
        
        
        [.spacer(), collectionButton, tableButton].addToView(stackView)
    }
    
    private func bind() {
        collectionButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.navigationController?.pushViewController(CollectionViewTest(), animated: true)
            }
            .store(in: &bag)
        tableButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.navigationController?.pushViewController(TableViewTest(), animated: true)
            }
            .store(in: &bag)
    }
}




extension UIControl {
    
    //use like: textField.publisher(for: .editingChanged)
    func publisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, controlEvent: event)
    }
    
    // creating a publisher for the UIControl
    struct EventPublisher: Publisher {
        
        typealias Output = UIControl // we are passing in the data stream the uicontrol as value
        typealias Failure = Never
        
        let control: UIControl
        let controlEvent: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = EventSubscription(control: control, event: controlEvent, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }

    // the subscription is where the main work is done
    class EventSubscription<S: Subscriber>: Subscription
    where S.Input == UIControl, S.Failure == Never {
        
        let control: UIControl
        let event: UIControl.Event
        var subscriber: S?
        
        var currentDemand = Subscribers.Demand.none
        
        init(control: UIControl, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addTarget(self,
                              action: #selector(eventOccured),
                              for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self,
                                 action: #selector(eventOccured),
                                 for: event)
        }
        
        @objc func eventOccured() {
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(control) ?? .none
                currentDemand -= 1
            }
        }
    }
}
