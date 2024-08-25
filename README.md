## How to Add Events to Your Calendar Using SwiftUI and EventKit

---

### Introduction

In this tutorial, you'll learn how to integrate calendar functionality into your SwiftUI application using the `EventKit` framework. We'll create a simple app that allows users to add events to their calendar with just a tap. This guide will walk you through setting up a SwiftUI view, requesting calendar access, and adding events programmatically.

By the end of this tutorial, you'll have a working feature that adds events to the user's calendar and provides feedback on whether the operation was successful.

### Prerequisites

- Basic knowledge of Swift and SwiftUI.
- Xcode installed on your Mac.
- Familiarity with event management is a plus but not required.

### Step 1: Import Required Frameworks

First, import the necessary frameworks. `SwiftUI` will be used for building the UI, and `EventKit` for managing calendar events.

```swift
import SwiftUI
import EventKit
```

### Step 2: Create an Event Model

We'll start by defining a simple `Event` model that represents the events you want to add to the calendar.

```swift
struct Event: Identifiable {
    let id: UUID = UUID()
    let title: String
    let date: Date
    let description: String
}
```

### Step 3: Build the ContentView
Now, let's create the main `ContentView` where we'll display a list of events.
```swift
struct ContentView: View {
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    let events: [Event] = [
        Event(title: "Mike's birthday", date: Date() + 86400 * 9, description: ""),
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
}
```

### Step 4: Ask the calendar permission and add the event

```swift
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
```

### Step 5: Understanding the Code

- `Event` Model: The `Event` struct represents an event with a title, date, and description.
 
- State Properties: 
 - `showAlert` controls the display of alerts.
 - `alertTitle` and `alertMessage` provide feedback to the user when an event is added or if there's an error.
 
- `events` Array: This array holds the events that you want to display and potentially add to the calendar.
- `DateFormatter`: The formatter is used to display the event's date in a readable format.
-`requestCalendarAccess(_:)`: This function requests access to the user's calendar. If granted, it creates and saves an event to the calendar. It also handles errors and updates the alert properties accordingly.
### Step 6: Update the Info's target

Click on your project file then on your target and Info and add two new key:
-`Privacy - Calendars Write Only Usage Description`
-`NSCalendarUsageDescription` and `Request calendar access to add event` as value
### Step 7: Running the App

- Build and Run the App: Open the project in Xcode and run it on a physical device (calendar functionality requires a real device).
- Add Events to Calendar: Tap any event in the list, and it should be added to your calendar. The app will show an alert indicating whether the event was added successfully or if there was an error.
Conclusion
You've successfully built a SwiftUI app that can add events to a user's calendar using `EventKit`. This functionality is a great addition to any app that needs to manage dates, reminders, or appointments.

### Conclusion
You've successfully built a SwiftUI app that can add events to a user's calendar using `EventKit`. This functionality is a great addition to any app that needs to manage dates, reminders, or appointments.
