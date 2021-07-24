//
//  EventBusCompitable.swift
//  EventBus
//
//  Created by 雷永麟 on 2021/7/24.
//

import Foundation

public protocol EventBusCompatible {
    associatedtype EventBusWrapperType
    var event: EventBusWrapperType { get }
    static var EVENT: EventBusWrapperType.Type { get }
}

public extension EventBusCompatible {
    var event: EventBusWrapper<Self> { return EventBusWrapper(value: self) }
    static var EVENT: EventBusWrapper<Self>.Type { EventBusWrapper.self }
}

public protocol EventBusWrapperProtocol {
    associatedtype EventBusWrapperType
    var eventBusWrappedValue: EventBusWrapperType { get }
    init(value: EventBusWrapperType)
}

public final class EventBusWrapper<EventBusWrapperType>: EventBusWrapperProtocol {
    
    public var eventBusWrappedValue: EventBusWrapperType
    
    public init(value: EventBusWrapperType) {
        eventBusWrappedValue = value
    }
}
