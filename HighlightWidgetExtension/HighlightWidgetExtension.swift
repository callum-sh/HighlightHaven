//
//  HighlightWidgetExtension.swift
//  HighlightWidgetExtension
//
//  Created by Callum on 2025-01-01.
//

import WidgetKit
import SwiftUI

/// The timeline entry for the App Intent widget
struct HighlightAppIntentEntry: TimelineEntry {
    let date: Date
    let highlight: Highlight
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    typealias Entry = HighlightAppIntentEntry
    
    func placeholder(in context: Context) -> HighlightAppIntentEntry {
        HighlightAppIntentEntry(
            date: Date(),
            highlight: Highlight(text: "Loading highlight..."),
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> HighlightAppIntentEntry {
        HighlightAppIntentEntry(
            date: Date(),
            highlight: Highlight(text: "Snapshot highlight preview"),
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<HighlightAppIntentEntry> {
        
        let randomHighlight = HighlightData.allHighlights.randomElement()
                            ?? Highlight(text: "No highlights found")
        
        let entry = HighlightAppIntentEntry(
            date: Date(),
            highlight: randomHighlight,
            configuration: configuration
        )
        
        // refresh highlight every hour
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

struct HighlightWidgetExtensionEntryView: View {
    let entry: HighlightAppIntentEntry

    var body: some View {
        ZStack {
            Text(entry.highlight.text)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

struct HighlightWidgetExtension: Widget {
    let kind: String = "HighlightWidgetExtension"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            HighlightWidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
                               .configurationDisplayName("Random Kindle Highlight")
                               .description("Displays a random highlight from your Kindle collection.")
                               .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemLarge) {
    HighlightWidgetExtension()
} timeline: {
    HighlightAppIntentEntry(
        date: .now,
        highlight: Highlight(text: "Preview highlight #1"),
        configuration: ConfigurationAppIntent()
    )
    HighlightAppIntentEntry(
        date: .now.addingTimeInterval(60 * 60),
        highlight: Highlight(text: "Preview highlight #2"),
        configuration: ConfigurationAppIntent()
    )
}
