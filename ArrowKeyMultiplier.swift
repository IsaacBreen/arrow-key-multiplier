import Cocoa
import Carbon
import ServiceManagement

class ArrowKeyMultiplier {
    private var eventTap: CFMachPort?
    private let multiplier: Int

    init(multiplier: Int = 5) {
        self.multiplier = multiplier
    }

    func start() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: keystrokeCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap. Check accessibility permissions in System Preferences -> Security & Privacy -> Privacy.")
            return
        }

        self.eventTap = eventTap

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)

        CFRunLoopRun()
    }

    private let keystrokeCallback: CGEventTapCallBack = { proxy, type, event, refcon in
        guard let event = event else { return nil }

        guard type == .keyDown else {
            return Unmanaged.passUnretained(event).toOpaque()
        }

        let multiplier = Unmanaged<ArrowKeyMultiplier>.fromOpaque(refcon!).takeUnretainedValue()

        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let flags = event.flags

        // Check for up/down arrow keys (125 is down, 126 is up) and Option key
        if (keyCode == 125 || keyCode == 126) && flags.contains(.maskAlternate) {
            let includeShift = flags.contains(.maskShift)
            guard let source = CGEventSource(stateID: .hidSystemState) else { return Unmanaged.passUnretained(event).toOpaque() }

            for _ in 1...multiplier.multiplier {
                if let arrowEvent = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(keyCode), keyDown: true) {
                    if includeShift {
                        arrowEvent.flags = .maskShift
                    } else {
                        arrowEvent.flags = []
                    }
                    arrowEvent.post(tap: .cghidEventTap)
                }
            }

            return nil // Consume the original event
        }

        return Unmanaged.passUnretained(event).toOpaque()
    }

    static func registerForStartup() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.example.ArrowKeyMultiplier"

        do {
            try SMAppService.mainApp().register()
            print("Successfully registered for startup")
        } catch {
            print("Failed to register for startup: \(error)")
        }
    }
}

// Check if we should register for startup
if CommandLine.arguments.contains("--register") {
    ArrowKeyMultiplier.registerForStartup()
    exit(0)
}

// Start the multiplier
let multiplier = ArrowKeyMultiplier(multiplier: 5)
multiplier.start()