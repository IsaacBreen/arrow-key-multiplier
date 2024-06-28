import Cocoa
import Carbon
import ServiceManagement

class KeystrokeInterceptor {
    private var eventTap: CFMachPort?
    private let numberOfKeystrokes: Int
    
    init(numberOfKeystrokes: Int = 5) {
        self.numberOfKeystrokes = numberOfKeystrokes
    }
    
    func start() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon in
                let interceptor = Unmanaged<KeystrokeInterceptor>.fromOpaque(refcon!).takeUnretainedValue()
                return interceptor.keystrokeCallback(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
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
            
            for _ in 1...numberOfKeystrokes {
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
    
    static func registerForStartup() {
        let bundleIdentifier = "com.user.KeystrokeInterceptor"
        
        if SMLoginItemSetEnabled(bundleIdentifier as CFString, true) {
            print("Successfully registered for startup")
        } else {
            print("Failed to register for startup")
        }
    }
}

// Check if we should register for startup
if CommandLine.arguments.contains("--register") {
    KeystrokeInterceptor.registerForStartup()
    exit(0)
}

// Start the interceptor
let interceptor = KeystrokeInterceptor(numberOfKeystrokes: 5)
interceptor.start()
