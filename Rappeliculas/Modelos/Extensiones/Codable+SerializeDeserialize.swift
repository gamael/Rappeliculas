//
//  Codable+SerializeDeserialize.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 31/10/18.
//  Tomado de proyecto con Bradley Suira
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
