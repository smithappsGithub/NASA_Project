//
//  Haptics.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-11.
//

import Foundation
import SwiftUI


enum Haptics {
    static func createHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
