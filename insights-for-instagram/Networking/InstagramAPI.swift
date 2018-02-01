//
//  InstagramAPI.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup

struct Constant {
    static let baseURL = "https://insights-for-instagram.herokuapp.com/api/"
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let InstagramProvider = MoyaProvider<Instagram>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

public enum Instagram {
    case userMedia(String)
}

extension Instagram: TargetType {
    public var baseURL: URL { return URL(string: Constant.baseURL)! } // swiftlint:disable:this force_unwrapping
    public var path: String {
        switch self {
        case .userMedia(let name):
            guard let name = name.urlEscaped else { return "" }
            return "users/\(name)/media"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
   
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> [String: Any] {
        let any = try self.mapJSON()
        guard let array = any as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data? {
    @objc class TestClass: NSObject { }
    let bundle = Bundle(for: TestClass.self)
    guard let path = bundle.path(forResource: filename, ofType: "json") else { return nil }
    return (try? Data(contentsOf: URL(fileURLWithPath: path)))
}
