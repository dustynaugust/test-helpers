//
//  URLProtocolStub.swift
//
//
//  Created by Dustyn August on 2/2/24.
//

import Foundation

public class URLProtocolStub: URLProtocol {
  static var session: URLSession?
  private static var stub: Stub?
  
  private struct Stub {
    let data: Data?
    let response: URLResponse?
    let error: Error?
  }
  
  public static func stub(
    data: Data?,
    response: URLResponse?,
    error: Error?
  ) {
    stub = Stub(data: data, response: response, error: error)
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [URLProtocolStub.self]
    session = URLSession(configuration: configuration)
  }
  
  public static func startInterceptingRequests() {
    URLProtocol.registerClass(URLProtocolStub.self)
  }
  
  public static func stopInterceptingRequests() {
    URLProtocol.unregisterClass(URLProtocolStub.self)
    stub = nil
    session = nil
  }
  
  override public class func canInit(
    with request: URLRequest
  ) -> Bool {
    true
  }
  
  override public class func canonicalRequest(
    for request: URLRequest
  ) -> URLRequest {
    request
  }
  
  override public func startLoading() {
    if let data = URLProtocolStub.stub?.data {
      client?.urlProtocol(self, didLoad: data)
    }
    
    if let response = URLProtocolStub.stub?.response {
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    if let error = URLProtocolStub.stub?.error {
      client?.urlProtocol(self, didFailWithError: error)
    }
    
    
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override public func stopLoading() { }
}
