//
//  LocalizedString.swift
//  Allkdic
//
//  Created by 전수열 on 9/28/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import Foundation

func gettext(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
