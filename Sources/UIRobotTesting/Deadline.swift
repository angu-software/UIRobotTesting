//
//  Deadline.swift
//  Pandocs
//
//  Created by Andreas Günther on 25.08.25.
//

import Foundation

struct Deadline {

    static func now() -> Date {
        return Date()
    }

    let startDate: Date
    let timeout: Timeout
    let now: () -> Date

    init(startDate: Date = Date(), timeout: Timeout, now: @escaping () -> Date = { Date() } ) {
        self.startDate = startDate
        self.timeout = timeout
        self.now = now
    }

    func isElapsed() -> Bool {
        return now().timeIntervalSince(startDate) > timeout
    }
}
