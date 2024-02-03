//
//  XCTestCase+Error.swift
//
//
//  Created by Dustyn August on 2/2/24.
//

import TestHelpers
import XCTest

final class XCTestCaseErrorTests: XCTestCase {
  enum EquatableError_1: Swift.Error, Equatable {
    case someEquatableError_1
  }
  
  struct NonEquatableError_1: Swift.Error { }
  
  class SomeNSError_1: CustomNSError {
    static let errorDomain = "SomeNSError_1-errorDomain"
    let errorCode = 42
    let errorUserInfo = ["SomeNSError_1": "errorUserInfo"]
  }
  
  private enum ErrorThrower {
    enum EquatableError_2: Swift.Error, Equatable {
      case someEquatableError_2
      case anotherEquatableError_2
    }
    
    struct NonEquatableError_2: Swift.Error { }
    
    class SomeNSError_2: CustomNSError {
      static let errorDomain = "SomeNSError_2-errorDomain"
      let errorCode = -42
      let errorUserInfo = ["SomeNSError_2": "errorUserInfo"]
    }
    
    static func throwEquatableError() async throws {
      throw EquatableError_2.someEquatableError_2
    }
    
    static func throwNonEquatableError() async throws {
      throw NonEquatableError_2()
    }
    
    static func throwNSError() async throws {
      throw SomeNSError_2()
    }
    
    static func noThrow() async throws { }
  }
}

// MARK: - Equatable Error Test(s)
extension XCTestCaseErrorTests {
  func test_expect_AsyncExpressionThrowsEquatableError_WhenEquatableErrorIsThrown() async throws {
    await expect(
      try await ErrorThrower.throwEquatableError(),
      throws: ErrorThrower.EquatableError_2.someEquatableError_2
    )
  }
  
  func test_expect_AsyncExpressionThrowsEquatableError_WhenUnexpectedEquatableErrorIsThrown() async throws {
    XCTExpectFailure("Expected to throw incorrect equatable error.")
    
    await expect(
      try await ErrorThrower.throwEquatableError(),
      throws: ErrorThrower.EquatableError_2.anotherEquatableError_2
    )
  }
  
  func test_expect_AsyncExpressionThrowsEquatableError_WhenEquatableErrorOfUnexpectedTypeIsThrown() async throws {
    XCTExpectFailure("Expected to throw equatable error of unexpected type.")
    
    await expect(
      try await ErrorThrower.throwEquatableError(),
      throws: EquatableError_1.someEquatableError_1
    )
  }
  
  func test_expect_AsyncExpressionThrowsEquatableError_WhenNoErrorThrown() async throws {
    XCTExpectFailure("No error should be thrown.")
    
    await expect(
      try await ErrorThrower.noThrow(),
      throws: ErrorThrower.EquatableError_2.someEquatableError_2
    )
  }
}

// MARK: - Error of Type Test(s)
extension XCTestCaseErrorTests {
  func test_expect_AsyncExpressionThrowsErrorType_WhenNonEquatableErrorThrown() async throws {
    await expect(
      try await ErrorThrower.throwNonEquatableError(),
      throwsErrorOfType: ErrorThrower.NonEquatableError_2.self
    )
  }
  
  func test_expect_AsyncExpressionThrowsErrorType_WhenUnexpectedNonEquatableErrorThrown() async throws {
    XCTExpectFailure("Expected to throw incorrect non-equatable error.")
    
    await expect(
      try await ErrorThrower.throwNonEquatableError(),
      throwsErrorOfType: NonEquatableError_1.self
    )
  }
  
  func test_expect_AsyncExpressionThrowsErrorType_WhenNoErrorThrown() async throws {
    XCTExpectFailure("No error should be thrown.")
    
    await expect(
      try await ErrorThrower.noThrow(),
      throwsErrorOfType: ErrorThrower.NonEquatableError_2.self
    )
  }
}

// MARK: - Error Thrown Test(s)
extension XCTestCaseErrorTests {
  func test_expect_ErrorThrownByAsyncExpression_WhenEquatableErrorThrown() async throws {
    await expectErrorThrown(
      by: try await ErrorThrower.throwEquatableError()
    )
  }
  
  func test_expect_ErrorThrownByAsyncExpression_WhenNonEquatableErrorThrown() async throws {
    await expectErrorThrown(
      by: try await ErrorThrower.throwNonEquatableError()
    )
  }
  
  func test_expect_ErrorThrownByAsyncExpression_WhenNoErrorThrown() async throws {
    XCTExpectFailure("No error should be thrown.")
    
    await expectErrorThrown(
      by: try await ErrorThrower.noThrow()
    )
  }
}

// MARK: - NSError Test(s)
extension XCTestCaseErrorTests {
  func test_expect_AsyncExpressionThrowsNSError_WhenNSErrorIsThrown() async throws {
    await expect(
      try await ErrorThrower.throwNSError(),
      throws: ErrorThrower.SomeNSError_2())
  }
  
  func test_expect_AsyncExpressionThrowsNSError_WhenUnexpectedNSErrorIsThrown() async throws {
    XCTExpectFailure("Expected to throw incorrect NSError error.")
    
    await expect(
      try await ErrorThrower.throwNSError(),
      throws: SomeNSError_1())
  }
  
  func test_expect_AsyncExpressionThrowsNSError_WhenNoNSErrorIsThrown() async throws {
    XCTExpectFailure("No error should be thrown.")
    
    await expect(
      try await ErrorThrower.noThrow(),
      throws: ErrorThrower.SomeNSError_2())
  }
}
