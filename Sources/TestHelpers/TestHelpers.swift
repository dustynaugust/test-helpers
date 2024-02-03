// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  TestHelpers.swift
//
//
//  Created by Dustyn August on 2/2/24.
//

import XCTest

public var anyError: Swift.Error { anyNSError }

public var anyNSError: NSError {
  makeNSError(localizedDescription: "anyNSError")
}

public func anyURL() throws -> URL {
  try XCTUnwrap(URL(string: "http://any-url.com"))
}

public func anyURLRequest() throws -> URLRequest {
  let url = try anyURL()
  
  return URLRequest(url: url)
}

public func anyURLResponse() throws -> URLResponse {
  let url = try anyURL()
  
  return URLResponse(
    url: url,
    mimeType: nil,
    expectedContentLength: 1,
    textEncodingName: nil
  )
}

public func any200HTTPURLResponse() throws -> HTTPURLResponse {
  let url = try anyURL()
  
  return try XCTUnwrap(
    HTTPURLResponse(
      url: url,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
  )
}

public func invalidJSONData() throws -> Data {
  try XCTUnwrap("Definitely Not JSON!".data(using: .utf8))
}

public func makeNSError(
  localizedDescription: String
) -> NSError {
  NSError(
    domain: Bundle.main.bundleIdentifier ?? "",
    code: -1,
    userInfo: [NSLocalizedDescriptionKey: localizedDescription]
  )
}
