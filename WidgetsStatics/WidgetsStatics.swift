//
//  WidgetsStatics.swift
//  WidgetsStatics
//
//  Created by 18476693 on 18.10.2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion:
        @escaping (SimpleEntry) -> ()) {
            let entry = SimpleEntry(date: Date(), configuration: configuration)
            completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date()
        
        let startOfDay = Calendar.current.startOfDay(for: now)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        var entries: [SimpleEntry] = []
        
        for min in 0 ..< 24*60 {
            let date = Calendar.current.date(byAdding: .minute, value: min, to: startOfDay)!
            entries.append(SimpleEntry(date: date, configuration: configuration))
        }
        
        completion(Timeline(entries: entries, policy: .after(nextDay)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetsStaticsEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Color.blue
            Text(entry.date, style: .time)
                .font(.system(size: 35))
                .frame(alignment: .center)
        }
    }
}

struct WidgetsStaticsPreview : View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Color.red
            Text(entry.date, style: .time)
                .font(.system(size: 35))
                .frame(alignment: .center)
        }
    }
}

struct WidgetsStatics: Widget {
    let kind: String = "WidgetsStatics"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsStaticsEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .configurationDisplayName("Subscribers")
        .description("Choose an account by clicking on the widget on the home screen.")
    }
}

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetsStatics()
    }
}

struct WidgetsStatics_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsStaticsPreview(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
