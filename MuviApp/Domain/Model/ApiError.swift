//
//  ApiError.swift
//  MuviApp
//
//  Created by Mutakin on 12/09/25.
//

enum ApiError: Error {
  case unknown
  case connectionError
  case invalidJSONError
  case middlewareError(code: Int, message: String?)
  case failedMappingError
}
