//
//  EventBus.swift
//  EventBus
//
//  Created by 雷永麟 on 2021/7/24.
//

import Foundation

public struct EventBus: EventBusCompatible {
    public typealias Name = String
    
    public weak var target: AnyObject?
    public var name: Name
    public var userInfo: [AnyHashable: Any]?
    public var object: Any?
    
    fileprivate var scheduler: DispatchQueue = DispatchQueue.global()
    fileprivate var action: ((Self) -> Void)?
    
    public init(target: AnyObject?, name: Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        self.target = target
        self.name = name
        self.object = object
        self.userInfo = userInfo
    }
}

public struct EventBusCenter {
    
    public typealias EventBusCallBack = ((EventBus) -> Void)?
    public static var `default` = EventBusCenter()
    
    private var eventBuses: [EventBus.Name: [EventBus]] = [:]
    private let defaultDispatchQueue = DispatchQueue.global()
    
    public mutating func add(_ eventBus: EventBus, callBack: EventBusCallBack) {
        clearTargets()
        var addEventBus = eventBus
        addEventBus.action = callBack
        eventBuses.appendElement(addEventBus)
    }
    
    public mutating func add(_ target: AnyObject, name: EventBus.Name, object: Any?, callBack: EventBusCallBack) {
        let eventBus = EventBus(target: target, name: name, object: object, userInfo: nil)
        add(eventBus, callBack: callBack)
    }
    
    public mutating func call(_ name: EventBus.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
        clearTargets()
        let allEventBusForName = eventBuses[name]
        for eventBus in allEventBusForName ?? [] {
            var sendEventBus = eventBus
            sendEventBus.object = object
            sendEventBus.userInfo = userInfo
            eventBus.scheduler.async {
                eventBus.action?(sendEventBus)
            }
        }
    }
}

private extension EventBusCenter {
    
    mutating func clearTargets() {
        eventBuses = eventBuses.mapValues({
            return $0.filter({ event in event.target != nil })
        })
    }
}

private extension Dictionary where Key == EventBus.Name, Value == [EventBus] {
    
    mutating func appendElement(_ element: Value.Element) {
        
        if !(self[element.name]?.contains(where: { eventBus in
            if let currentTarget = eventBus.target, let target = element.target {
                return currentTarget.isEqual(target)
            }
            return false
        }) ?? false) {
            if self[element.name] != nil {
                self[element.name]?.append(element)
            } else {
                self[element.name] = [element]
            }
        }
        
    }
}

public extension EventBusWrapper where EventBusWrapperType == EventBus {
    
    func subscribeOn(_ scheduler: DispatchQueue) -> Self {
        self.eventBusWrappedValue.scheduler = scheduler
        return self
    }
    
    func subscribe(_ callBack: EventBusCenter.EventBusCallBack) {
        EventBusCenter.default.add(self.eventBusWrappedValue, callBack: callBack)
    }
}
