import Cocoa
import Carbon

class KeystrokeInterceptor {
    private var eventTap: CFMachPort?
    
    func start() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: keystrokeCallback,
            userInfo: nil
        ) else {
            print("Failed to create event tap")
            return
        }
        
        self.eventTap = eventTap
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        CFRunLoopRun()
    }
}

func keystrokeCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard type == .keyDown else {
        return Unmanaged.passRetained(event)
    }
    
    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
    let flags = event.flags
    
    if flags.contains(.maskAlternate) && (keyCode == 123 || keyCode == 124 || keyCode == 125 || keyCode == 126) {
        // Option + Arrow up/down key pressed
        let source = CGEventSource(stateID: .hidSystemState)
        
        for _ in 1...5 {
            if let arrowEvent = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(keyCode), keyDown: true) {
                arrowEvent.flags = []
                arrowEvent.post(tap: .cghidEventTap)
            }
        }
        
        return nil // Consume the original event
    }
    
    return Unmanaged.passRetained(event)
}

// Start the interceptor
let interceptor = KeystrokeInterceptor()
interceptor.start()
