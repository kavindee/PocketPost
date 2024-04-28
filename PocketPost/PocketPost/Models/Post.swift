//
//  Post.swift
//  PocketPost
//
//  Created by kavin on BE 2567-04-24.
//

import Foundation

struct Post {
    let identifier: String
    let title: String
    let timestamp: TimeInterval
    let headerImageUrl: URL?
    let text: String
}
