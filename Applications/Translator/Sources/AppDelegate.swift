//
//  AppDelegate.swift
//  Translator
//
//  Created by Yoshimasa Niwa on 8/18/24.
//

import AppKit
import Foundation
import TranslatorSupport

@MainActor
final class AppDelegate: NSObject {
    var translatorService: TranslatorService = TranslatorService()

    var localizedName: String {
        for case let infoDictionary? in [
            Bundle.main.localizedInfoDictionary,
            Bundle.main.infoDictionary
        ] {
            for key in [
                "CFBundleDisplayName",
                "CFBundleName"
            ] {
                if let localizedName = infoDictionary[key] as? String {
                    return localizedName
                }
            }
        }

        // Should not reach here.
        return ""
    }

    func presentAboutPanel() {
        if NSApp.activationPolicy() == .accessory {
            NSApp.activate(ignoringOtherApps: true)
        }
        NSApp.orderFrontStandardAboutPanel()
    }

    func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.servicesProvider = ServiceProvider(translatorService: translatorService)
        NSUpdateDynamicServices()

        translatorService.preloadModel()
    }
}
