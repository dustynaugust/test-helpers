//
//  XCTestCase+Error.swift
//
//
//  Created by Dustyn August on 2/2/24.
//

import XCTest

// MARK: - Error Expectations
extension XCTestCase {
  /// Expects an async expression to throw a specific Error.
  /// - Parameters:
  ///   - expression: The expression that should throw the Error.
  ///   - expectedError: The Error expected to be thrown.
  ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
  ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
  public func expect<T>(
    _ expression: @autoclosure () async throws -> T,
    throws expectedError: Error,
    in file: StaticString = #file,
    on line: UInt = #line
  ) async {
    let expectedNSError = expectedError as NSError
    
    await expect(
      try await expression(),
      throws: expectedNSError,
      in: file,
      on: line
    )
  }
  
  /// Expects an async expression to throw a specific Equatble Error.
  /// - Parameters:
  ///   - expression: The async expression that should throw the Error.
  ///   - expectedError: The specifc Error expected to be thrown.
  ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
  ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
  public func expect<T, E>(
    _ expression: @autoclosure () async throws -> T,
    throws expectedError: E,
    in file: StaticString = #file,
    on line: UInt = #line
  ) async where E: Error & Equatable {
    do {
      _ = try await expression()
      XCTFail("No error thrown. Expecting \(expectedError)", file: file, line: line)
      
    } catch {
      guard
        let actualError = error as? E
      else {
        XCTFail("Throws unexpected error type \"\(String(reflecting: error))\". Expecting \"\(String(reflecting: E.self))\".", file: file, line: line)
        return
      }
      
      guard
        actualError == expectedError
      else {
        XCTFail("Throws unexpected error \"\(actualError)\". Expecting \"\(expectedError)\".", file: file, line: line)
        return
      }
      
      // Success, the expected error was thrown
    }
  }
  
  /// Expects an async expression to throw an Error of a specified type.
  /// - Parameters:
  ///   - expression: The async expression that should throw the Error.
  ///   - expectedErrorType: The specified type of the Error that should be thrown.
  ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
  ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
  public func expect<T, E>(
    _ expression: @autoclosure () async throws -> T,
    throwsErrorOfType expectedErrorType: E.Type,
    in file: StaticString = #file,
    on line: UInt = #line
  ) async where E: Error {
    do {
      _ = try await expression()
      XCTFail("Expression did not throw an error", file: file, line: line)
      
    } catch {
      guard
        error is E
      else {
        XCTFail("Throws unexpected error type \(String(reflecting: error.self)). Expected type \(String(reflecting: expectedErrorType)))", file: file, line: line)
        return
      }
      
      // Success, an error of type E was thrown
    }
  }
  
  /// Expects an async expression to throw some Error.
  /// - Parameters:
  ///   - expression: The async expression that should throw an Error.
  ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
  ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
  public func expectErrorThrown<T>(
    by expression: @autoclosure () async throws -> T,
    in file: StaticString = #file,
    on line: UInt = #line
  ) async {
    do {
      _ = try await expression()
      XCTFail("Expression did not throw an error", file: file, line: line)
      
    } catch {
      // Success, an error was thrown
    }
  }
}

// MARK: - NSError Expectations
extension XCTestCase {
  /// Expects an async expression to throw a specific NSError.
  /// - Parameters:
  ///   - expression: The async expression that should throw the NSError.
  ///   - expectedError: The NSError expected to be thrown.
  ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
  ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
  public func expect<T>(
    _ expression: @autoclosure () async throws -> T,
    throws expectedError: NSError,
    in file: StaticString = #file,
    on line: UInt = #line
  ) async {
    do {
      _ = try await expression()
      XCTFail("No error thrown. Expecting \(expectedError)", file: file, line: line)
      
    } catch {
      let thrownError = error as NSError
      
      if thrownError.domain != expectedError.domain {
        XCTFail("Throws unexpected error domain \"\(thrownError.domain)\". Expecting \"\(expectedError.domain)\".", file: file, line: line)
      }
      
      if thrownError.code != expectedError.code {
        XCTFail("Throws unexpected error code \"\(thrownError.code)\". Expecting \"\(expectedError.code)\".", file: file, line: line)
      }
    }
  }
}
