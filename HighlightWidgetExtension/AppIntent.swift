//
//  AppIntent.swift
//  HighlightWidgetExtension
//
//  Created by callum on 2025-01-01.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }
}
