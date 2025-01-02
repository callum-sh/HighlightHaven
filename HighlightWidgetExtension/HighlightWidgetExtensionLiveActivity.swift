//
//  HighlightWidgetExtensionLiveActivity.swift
//  HighlightWidgetExtension
//
//  Created by callum on 2025-01-01.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HighlightWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HighlightWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HighlightWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HighlightWidgetExtensionAttributes {
    fileprivate static var preview: HighlightWidgetExtensionAttributes {
        HighlightWidgetExtensionAttributes(name: "World")
    }
}

extension HighlightWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: HighlightWidgetExtensionAttributes.ContentState {
        HighlightWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HighlightWidgetExtensionAttributes.ContentState {
         HighlightWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HighlightWidgetExtensionAttributes.preview) {
   HighlightWidgetExtensionLiveActivity()
} contentStates: {
    HighlightWidgetExtensionAttributes.ContentState.smiley
    HighlightWidgetExtensionAttributes.ContentState.starEyes
}
