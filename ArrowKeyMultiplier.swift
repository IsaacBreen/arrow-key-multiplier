import Cocoa
import Carbon
import ServiceManagement

class ArrowKeyMultiplier {
    private var eventTap: CFMachPort?
    private let verticalMultiplier: Int
    private let horizontalMultiplier: Int
    
    init(verticalMultiplier: Int = 5, horizontalMultiplier: Int = 5) {
        self.verticalMultiplier = verticalMultiplier
        self.horizontalMultiplier = horizontalMultiplier
    }
    
    func start() {
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
        
        // Check for up/down/left/right arrow keys (125 is down, 126 is up, 123 is left, 124 is right)
        let isVertical = (keyCode == 125 || keyCode == 126)
        let isHorizontal = (keyCode == 123 || keyCode == 124)
        // Check for option command + arrow keys
        if (isVertical || isHorizontal) && flags.contains(.maskAlternate) && flags.contains(.maskCommand) {
            let multiplier = isVertical ? verticalMultiplier : horizontalMultiplier
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
    
    static func registerForStartup() {
        let bundleIdentifier = "com.user.ArrowKeyMultiplier"
        
        if SMLoginItemSetEnabled(bundleIdentifier as CFString, true) {
            print("Successfully registered for startup")
        } else {
            print("Failed to register for startup")
        }
    }
}

// Check if we should register for startup
if CommandLine.arguments.contains("--register") {
    ArrowKeyMultiplier.registerForStartup()
    exit(0)
}

// Start the multiplier
let multiplier = ArrowKeyMultiplier(verticalMultiplier: 5, horizontalMultiplier: 5)
multiplier.start()
