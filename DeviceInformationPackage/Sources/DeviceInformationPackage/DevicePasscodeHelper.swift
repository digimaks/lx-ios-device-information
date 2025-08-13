// SPDX-License-Identifier: EUPL-1.2

//
//  DevicePasscodeHelper.swift
//  DeviceInformationPackage
//
//  Created by Matīss Mamedovs on 11/03/2025.
//

import Foundation
import LocalAuthentication

public final class DevicePasscodeHelper: Sendable {
    
    
    public static let shared = DevicePasscodeHelper()
    
    @available(iOS 8.0, *)
    private func devicePasscodeEnabledUsingKeychain() -> Bool {
        let query: [String:Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : UUID().uuidString,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            kSecValueData as String: "HelloWorld".data(using: String.Encoding.utf8)!,
            kSecReturnAttributes as String : kCFBooleanTrue
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        
        if status == errSecItemNotFound {
            let createStatus = SecItemAdd(query as CFDictionary, nil)
            guard createStatus == errSecSuccess else { return false }
            status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        }
        
        guard status == errSecSuccess else { return false }
        
        return true
    }
    
    public func devicePasscodeEnabled() -> Bool {
        if #available(iOS 9.0, *) {
            let context = LAContext()
            return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        } else {
            return devicePasscodeEnabledUsingKeychain()
        }
    }
    
    @available(iOS 8.0, *)
    public func deviceBiometricsEnabled() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
