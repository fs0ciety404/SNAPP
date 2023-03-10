//
//  HapticEngine.swift
//  MC3
//
//  Created by Davide Ragosta on 15/02/23.
//
import Foundation

#if os(iOS)

import CoreHaptics

class HapticManager {
    
    var hapticEngine: CHHapticEngine
    
    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return nil
        }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine.start()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine.start()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
        }
    }
    
    func playPattern() {
        do {
            let pattern = try basicPattern()
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            print("Failed to play pattern: \(error)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

extension HapticManager {
    private func basicPattern() throws -> CHHapticPattern {
        
        let initialSharpness = 0
        
        let initialIntensity = 1
        
        // Create an intensity parameter:
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: Float(initialIntensity))
        
        // Create a sharpness parameter:
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: Float(initialSharpness))
        
        // Create a continuous event with a long duration from the parameters.
        let pattern = CHHapticEvent(eventType: .hapticContinuous,
                                    parameters: [intensity, sharpness],
                                    relativeTime: 0,
                                    duration: 1)
        
        return try CHHapticPattern(events: [pattern], parameters: [])
    }
    
    func playSlice() {
        do {
            // 1
            let pattern = try basicPattern()
            // 2
            try hapticEngine.start()
            // 3
            let player = try hapticEngine.makePlayer(with: pattern)
            // 4
            try player.start(atTime: CHHapticTimeImmediate)
            // 5
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            print("Failed to play slice: \(error)")
        }
    }
}

#endif
