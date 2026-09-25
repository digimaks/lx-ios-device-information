# DeviceInformationPackage

Device state helpers for iOS — interface theme, passcode and biometry availability, and integrity checks.

It is one of the Swift packages used by **Digimaks**, a mobile digital wallet
continuing the work of the
[NOBID Consortium](https://www.nobidconsortium.com/) (the Nordic-Baltic eID
Project), one of the EU Large Scale Pilots preparing for eIDAS 2.0.

## Background

This package is the continuation of
[nobid-lsp-latvia/lx-ios-device-information](https://github.com/nobid-lsp-latvia/lx-ios-device-information),
developed within the NOBID Consortium and carried forward under the name
**Digimaks**.

## Requirements

- iOS 15+
- Swift 5.9+ / Xcode 15+

## Installation

Add the package to your `Package.swift`:

```swift
.package(url: "<repository-url>", from: "1.0.0")
```

or add it in Xcode via **File → Add Package Dependencies…**.

## Overview

| Type | Responsibility |
| ---- | -------------- |
| `DeviceInfoManager` | Current interface theme and device information |
| `DevicePasscodeHelper` | Whether a device passcode or biometry is enrolled, and whether the app may be entered |
| `DeviceTheme` | Type-safe `light` / `dark` theme, mapped from `UIUserInterfaceStyle` |

`DeviceTheme` also exposes `rawValue` (`"light"` / `"dark"`) for hosts that need
to pass the theme across a bridge as a string.

## Licence

Licensed under the [EUPL-1.2](LICENSE). See [Notice](Notice) for attribution.
