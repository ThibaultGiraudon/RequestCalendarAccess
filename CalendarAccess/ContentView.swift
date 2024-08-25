//
//  ContentView.swift
//  CalendarAccess
//
//  Created by Thibault Giraudon on 25/08/2024.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id: UUID = UUID()
    let title: String
    let date: Date
    let description: String
}

struct ContentView: View {
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    let events: [Event] = [
        Event(title: "Mike birthday", date: Date() + 86400 * 9, description: ""),
        Event(title: "Date", date: Date() + 86400 * 5, description: "Bring some flowers")
    ]
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd LLL YYYY"
        return formatter
    }()
    var body: some View {
        List {
            ForEach(events) { event in
                Button {
                    requestCalendarAccess(event)
                } label: {
                    HStack {
                        Text("\(formatter.string(from: event.date))")
                        Text(event.title)
                            .font(.headline)
                    }
                    
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage))
        }
    }
    
    private func requestCalendarAccess(_ event: Event) {
        let eventStore = EKEventStore()
        
        eventStore.requestWriteOnlyAccessToEvents() { (granted, error) in
            if granted && error == nil {
                let calendarEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = event.title
                calendarEvent.startDate = event.date
                calendarEvent.endDate = event.date.addingTimeInterval(3600)
                calendarEvent.notes = event.description
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    alertTitle = "Event Added"
                    alertMessage = "The event has been successfully added to your calendar."
                    showAlert = true
                } catch {
                    alertTitle = "Error"
                    alertMessage = "There was an error adding the event to your calendar."
                    showAlert = true
                }
            } else {
                alertTitle = "Error"
                alertMessage = "Access to the calendar was denied."
                showAlert = true
            }
        }
    }
}

#Preview {
    ContentView()
}
