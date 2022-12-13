//
//  Utils.swift
//  shorts-demo
//
//  Created by Andre on 2022/12/8.
//

import Foundation
import AVFoundation

// MARK: - NSObject
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    static var className: String {
        return String(describing: self)
    }
}

// MARK: - AVPlayer
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
