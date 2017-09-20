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

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let InstagramProvider = MoyaProvider<Instagram>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Instagram {
    case userMedia(String,String?)
}

extension Instagram: TargetType {
    public var baseURL: URL { return URL(string: "https://www.instagram.com")! }
    public var path: String {
        switch self {
        case .userMedia(let name, _):
            return "/\(name.urlEscaped)/media"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .userMedia(_, let offset):
            guard offset != nil else {
                return nil
            }
            return ["max_id": offset ?? "0"]
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        switch self {
        case .userMedia(_, let offset):
            guard offset != nil else {
                return .requestPlain
            }
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        }
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

//MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> Dictionary<String, AnyObject> {
        let any = try self.mapJSON()
        guard let array = any as? Dictionary<String, AnyObject> else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
