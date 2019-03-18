//
//  Post.swift
//  whyiOS
//
//  Created by Eric Lanza on 12/11/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Post: Codable {
    let name: String
    let reason: String
    let cohort: String? 
}
