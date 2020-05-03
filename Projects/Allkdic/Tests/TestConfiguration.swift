//
//  TestConfiguration.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Testing

final class TestConfiguration: QuickConfiguration {
  override class func configure(_ configuration: Configuration) {
    configuration.beforeEach {
      Stubber.clear()
    }
  }
}
