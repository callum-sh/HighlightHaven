//
//  ContentView.swift
//  HighlightHaven
//
//  Created by callum on 2025-01-01.
//

import SwiftUI

struct ContentView: View {
    @State private var focusHighlight: Highlight? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                // show the currently “focused” highlight
                if let highlight = focusHighlight {
                    VStack(alignment: .leading, spacing: 8) {
                        (
                            Text("\"\(highlight.text)\"\n\n").font(.custom("TimesNewRomanPSMT", size: 20))
                            + Text(highlight.book).italic()
                            + Text(" by \(highlight.author)")
                                .font(.headline)
                        )
                        .multilineTextAlignment(.leading)
                    }
                    .padding()
                } else {
                    Text("No highlight in focus.")
                        .padding()
                }
                
                // show the list of all highlights
                List(HighlightData.allHighlights) { highlight in
                    (
                        Text("\"\(highlight.text)\"\n\n")
                            .font(.custom("TimesNewRomanPSMT", size: 16))
                        + Text(highlight.book).italic()
                        + Text(" by \(highlight.author)")
                            .font(.headline)
                    )
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Highlight Haven")
        }
        // load the focus highlight whenever this view appears
        .onAppear {
            loadFocusedHighlight()
        }
    }

    private func loadFocusedHighlight() {
        // Pick a random highlight
        let randomHighlight = HighlightData.allHighlights.randomElement()
                            ?? Highlight(text: "No highlights found",
                                         book: "loading...",
                                         author: "tbd...")
        
        // Save it to an app group container so the main app can read it
        if let userDefaults = UserDefaults(suiteName: "group.com.sharrock.highlightwidget") {
            userDefaults.set(randomHighlight.text,   forKey: "focusText")
            userDefaults.set(randomHighlight.book,   forKey: "focusBook")
            userDefaults.set(randomHighlight.author, forKey: "focusAuthor")
        }
        
        focusHighlight = randomHighlight
    }
}

#Preview {
    ContentView()
}
