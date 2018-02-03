//
//  Model.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Foundation

protocol Model: Codable {
  static var encoder: JSONEncoder { get }
  static var decoder: JSONDecoder { get }
}

extension Model {
  static var encoder: JSONEncoder {
    let encoder = JSONEncoder()
    return encoder
  }

  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    return decoder
  }

  init(data: Data) throws {
    self = try Self.decoder.decode(Self.self, from: data)
  }

  init(json: Any) throws {
    guard JSONSerialization.isValidJSONObject(json) else { throw ModelDecodingError.invalidJSON(json) }
    let data = try JSONSerialization.data(withJSONObject: json)
    self = try Self.init(data: data)
  }

  func json() throws -> Any {
    let data = try Self.encoder.encode(self)
    return try JSONSerialization.jsonObject(with: data)
  }
}

enum ModelDecodingError: Error {
  case invalidJSON(Any)
  case coerceFailure
}
