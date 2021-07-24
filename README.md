# EventBus

[![CI Status](https://img.shields.io/travis/ylei11@volvocars.com/EventBus.svg?style=flat)](https://travis-ci.org/ylei11@volvocars.com/EventBus)
[![Version](https://img.shields.io/cocoapods/v/EventBus.svg?style=flat)](https://cocoapods.org/pods/EventBus)
[![License](https://img.shields.io/cocoapods/l/EventBus.svg?style=flat)](https://cocoapods.org/pods/EventBus)
[![Platform](https://img.shields.io/cocoapods/p/EventBus.svg?style=flat)](https://cocoapods.org/pods/EventBus)

## Author

1473781785@qq.com

## License

EventBus is available under the MIT license. See the LICENSE file for more info.

## Background

一开始想要通过 `Notification` 来接收通知消息，并做一定的逻辑，但是通过 `Notification` 的方式来接收通知过于的不方便，所以想要实现一套事件分发框架进行时间通知的接收

## Core

参考了`RxSwift`的使用方式，并能够在某个线程中订阅事件通知

#### Core Idea

- 通过 `EventBusCenter` (参考 `NotificationCenter` )方式进行事件的分发和订阅
- 通过 `EventBus` 的直接订阅来接收事件（分发依然通过 `EventBusCenter` ）

## Usage

#### 一、EventBUsCenter

- `public mutating func add(_ eventBus: EventBus, callBack: EventBusCallBack)`

    * 通过这个方法进行`event`订阅，直接通过订阅对象`EventBus`进行处理

- `public mutating func add(_ target: AnyObject, name: EventBus.Name, object: Any?, callBack: EventBusCallBack)`
    
    * 通过`target`、`name`、`object`、`callBack` 进行 `EventBus` 对象的构建，依然通过上面的方法进行 `event` 订阅

- 线程的处理和更加方便的使用（待添加）

- 内存释放时机和方式（待添加）

#### 二、EventBus

- 直接通过`EventBus`的exntension方法进行订阅
```swift
    EventBus(target: self,
                 name: EventBusName.Login.notLogin.rawValue,
                 object: nil,
                 userInfo: nil)
            .event
            .subscribeOn(DispatchQueue.main)
            .subscribe { [weak self] eventBus in

            }
```
