//
//  StubPopoverController.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Stubber
@testable import Allkdic

final class StubPopoverController: PopoverControllerType {
  func open() {
    return Stubber.invoke(open, args: (), default: Void())
  }
}
