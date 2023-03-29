//
//  Comments.swift
//  MtsHackNew
//
//  Created by  Даниил on 29.03.2023.
//

import Foundation

class Comment: Equatable {
    let startTime: TimeInterval
    let endTime: TimeInterval
    let text: String
    var isPlayed = false
    var volume: Float
    
    init(startTime: TimeInterval, endTime: TimeInterval, text: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
        if startTime == 103 || startTime == 140 {
            volume = 1.5
        } else {
            volume = 1
        }
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.startTime == rhs.startTime &&
        lhs.endTime == rhs.endTime &&
        lhs.text == rhs.text &&
        lhs.isPlayed == rhs.isPlayed
    }
}
