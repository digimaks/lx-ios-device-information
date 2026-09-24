// SPDX-License-Identifier: EUPL-1.2

//
//  DeviceInfoManager.swift
//  DeviceInformationPackage
//
//  Created by Matīss Mamedovs on 28/11/2024.
//
#if canImport(UIKit)

import Foundation
import UIKit

@MainActor
final public class DeviceInfoManager: Sendable {
    
    public static let shared = DeviceInfoManager()
    
    fileprivate let device = UIDevice.current
    
    public var appVersion: String {
        let release = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        return "\(release) (\(build))"
    }
    
    public var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    public var deviceName: String {
        return device.name
    }
    
    public var deviceModel: String {
        return device.model
    }
    
    public var systemName: String {
        return device.systemName
    }
    
    public var systemVersion: String {
        return device.systemVersion
    }
    
    public var identifier: String {
        return device.identifierForVendor?.uuidString ?? "N/A"
    }
    
    public var theme: DeviceTheme {
        DeviceTheme(osTheme)
    }
    
    public var getStringTheme: String {
        theme.rawValue
    }
    
    public var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    public var isJailBroken: Bool {
        get {
            if self.isSimulator { return false }
            if RootedHelper.hasCydiaInstalled() { return true }
            if RootedHelper.isContainsSuspiciousApps() { return true }
            if RootedHelper.isSuspiciousSystemPathsExists() { return true }
            return RootedHelper.canEditSystemFiles()
        }
    }
    
    public func canEnterApp() -> Bool {
        return !self.isUnsafeDevice() && DevicePasscodeHelper.shared.devicePasscodeEnabled()
    }
    
    public func isUnsafeDevice() -> Bool {
        return self.isJailBroken
    }
}

#endif

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
}

@MainActor
private struct RootedHelper {
    static func hasCydiaInstalled() -> Bool {
        guard let url = URL(string: "cydia://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let testString = "Developer Insider"
        let testPath = "/private/jb_test.txt"
        do {
            try testString.write(toFile: testPath, atomically: true, encoding: .utf8)
            try? FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }
    
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}

