//
//  HTTPURLResponse+StatusCode.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
