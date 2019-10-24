//
//  VCXNetworkManager.swift
//  sampleTextApp
//
//  Created by Hemraj on 23/11/18.
//  Copyright © 2018 VideoChat. All rights reserved.
//

import UIKit
import Foundation
import Reachability

enum ReachabilityManagerType {
    case Wifi
    case Cellular
    case None
    
}
class VCXNetworkManager: NSObject {
    var reachability: Reachability!
    
    // Create a singleton instance
    static let sharedInstance: VCXNetworkManager = { return VCXNetworkManager() }()
    override init() {
        super.init()
        // Initialise reachability
        do {
        try reachability = Reachability()
        
        } catch {
   
    }
    
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (VCXNetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    
    
    // Network is reachable
    static func isReachable() -> Bool{
        if(VCXNetworkManager.sharedInstance.reachability).connection != .none{
            return true
        }
        else{
            return false
        }
    }
    // Network is unreachable
    static func isUnreachable() -> Bool {
        if(VCXNetworkManager.sharedInstance.reachability).connection == .none{
            return true
        }
        else{
            return false
        }
    }
    
    /*
     // Network is reachable
     static func isReachable(completed: @escaping (VCXNetworkManager) -> Void) {
        if (VCXNetworkManager.sharedInstance.reachability).connection != .none {
            completed(VCXNetworkManager.sharedInstance)
        }
    }
    static func isRich() -> Bool{
        if(VCXNetworkManager.sharedInstance.reachability).connection != .none{
            return true
        }
        else{
            return false
        }
    }
    // Network is unreachable
    static func isUnreachable(completed: @escaping (VCXNetworkManager) -> Void) {
        if (VCXNetworkManager.sharedInstance.reachability).connection == .none {
            completed(VCXNetworkManager.sharedInstance)
        }
    }*/
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (VCXNetworkManager) -> Void) {
        if (VCXNetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(VCXNetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (VCXNetworkManager) -> Void) {
        if (VCXNetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(VCXNetworkManager.sharedInstance)
        }
    }
}
