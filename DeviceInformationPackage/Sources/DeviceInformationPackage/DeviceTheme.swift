// SPDX-License-Identifier: EUPL-1.2

//
//  DeviceTheme.swift
//  DeviceInformationPackage
//
//  Created by Matīss Mamedovs on 21/09/2026.

import Foundation

public enum DeviceTheme: String, Sendable, CaseIterable {
    case light
    case dark
}

#if canImport(UIKit)

import UIKit

extension DeviceTheme {
    public init(_ style: UIUserInterfaceStyle) {
        switch style {
        case .dark:
            self = .dark
        case .light, .unspecified:
            self = .light
        @unknown default:
            self = .light
        }
    }
}

#endif
