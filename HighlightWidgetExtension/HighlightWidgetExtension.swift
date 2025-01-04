//
//  HighlightWidgetExtension.swift
//  HighlightWidgetExtension
//
//  Created by Callum on 2025-01-01.
//

import WidgetKit
import SwiftUI

struct HighlightWidgetExtensionEntry: TimelineEntry {
    let date: Date
    let highlight: Highlight
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    typealias Entry = HighlightWidgetExtensionEntry
    
    func placeholder(in context: Context) -> HighlightWidgetExtensionEntry {
        // This is a placeholder entry for the widget previews
        let placeholderHighlight = Highlight(
            text: "Placeholder highlight text",
            book: "Placeholder Book",
            author: "Placeholder Author"
        )
        return HighlightWidgetExtensionEntry(
            date: Date(),
            highlight: placeholderHighlight,
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> HighlightWidgetExtensionEntry {
        // This is shown in the widget gallery in Xcode previews
        let snapshotHighlight = Highlight(
            text: "Sample snapshot highlight",
            book: "Sample Book",
            author: "Sample Author"
        )
        return HighlightWidgetExtensionEntry(
            date: Date(),
            highlight: snapshotHighlight,
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<HighlightWidgetExtensionEntry> {
        // Read the highlight from the shared container (written by the main app)
        let highlight: Highlight
        
        if let userDefaults = UserDefaults(suiteName: "group.com.sharrock.highlightwidget"),
           let text = userDefaults.string(forKey: "focusText"),
           let book = userDefaults.string(forKey: "focusBook"),
           let author = userDefaults.string(forKey: "focusAuthor") {
            
            highlight = Highlight(text: text, book: book, author: author)
            
        } else {
            // Fallback highlight if nothing is stored
            highlight = Highlight(text: "No highlights found",
                                  book: "loading...",
                                  author: "tbd...")
        }
        
        let entry = HighlightWidgetExtensionEntry(
            date: Date(),
            highlight: highlight,
            configuration: configuration
        )
        
        // Decide how often the widget should refresh on its own
        // (system may throttle or override this if needed)
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        
        // Return a single entry, set to refresh after `refreshDate`
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

struct HighlightWidgetExtensionEntryView: View {
    let entry: HighlightWidgetExtensionEntry

    var body: some View {
        // Display the highlight
        VStack(alignment: .leading) {
            (
                Text("\"\(entry.highlight.text)\"\n\n")
                    .font(.custom("TimesNewRomanPSMT", size: 18))
                + Text(entry.highlight.book).italic()
                + Text(" by \(entry.highlight.author)")
                    .font(.headline)
            )
            .multilineTextAlignment(.leading)
        }
        .padding()
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
    HighlightWidgetExtensionEntry(
        date: .now,
        highlight: Highlight(text: "Be yourself; everyone else is already taken.",
                             book: "Unknown",
                             author: "Oscar Wilde"),
        configuration: ConfigurationAppIntent()
    )
    HighlightWidgetExtensionEntry(
        date: .now.addingTimeInterval(60 * 60),
        highlight: Highlight(text: "Life, although it may only be an accumulation of anguish, is dear to me, and I will defend it.",
                             book: "Frankenstein",
                             author: "Mary Shelley"),
        configuration: ConfigurationAppIntent()
    )
}
