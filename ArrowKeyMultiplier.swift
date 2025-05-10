import Cocoa
import Carbon

class ArrowKeyMultiplier {
    private var eventTap: CFMachPort?
    private let multiplier: Int
    
    init(multiplier: Int = 5) {
        self.multiplier = multiplier
    }
    
    func start() {
        // Ensure we have accessibility permissions
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessibilityEnabled {
            print("Accessibility permissions are required for this app to function.")
            return
        }
        
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon in
                let multiplier = Unmanaged<ArrowKeyMultiplier>.fromOpaque(refcon!).takeUnretainedValue()
                return multiplier.keystrokeCallback(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap - ensure the app has proper permissions.")
            return
        }
        
        self.eventTap = eventTap
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        CFRunLoopRun()
    }
    
    private func keystrokeCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        guard type == .keyDown else {
            return Unmanaged.passRetained(event)
        }
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let flags = event.flags
        
        // Check for up/down arrow keys (125 is down, 126 is up)
        if (keyCode == 125 || keyCode == 126) && flags.contains(.maskAlternate) {
            let includeShift = flags.contains(.maskShift)
            let source = CGEventSource(stateID: .hidSystemState)
            
            for _ in 1...multiplier {
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
        
        return Unmanaged.passRetained(event)
    }
}

// Start the multiplier
let multiplier = ArrowKeyMultiplier(multiplier: 5)
multiplier.start()
