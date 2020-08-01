//
//  KexApi.swift
//  Kex
//
//  Created by Alex on 22.07.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//
import Foundation
import Moya

enum KexApi {
    case login(loginRequest: LoginRequest)
    case registration(registrationData: RegistrationRequest)
    case allGroups
}

extension KexApi: TargetType {
    var method: Moya.Method {
        switch self {
        case .registration, .login:
            return .post
        default:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .registration(registrationData):
            return .requestParameters(parameters: registrationData.toDict(), encoding: JSONEncoding.default)
        case let .login(loginData):
            return .requestParameters(parameters: loginData.toDict(), encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            return ["Authorization": "Bearer " + token!]
        } else {
            return nil
        }
    }

    var baseURL: URL { return URL(fileURLWithPath: "http://23.111.202.149:8080/") }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .registration:
            return "/registration"
        case .allGroups:
            return "/groups"
        }
    }
}

extension Encodable {
    func toDict() -> [String: String] {
        let dataEncoded = try? JSONEncoder().encode(self)
        if dataEncoded != nil {
            let jsonData = try? JSONSerialization.jsonObject(with: dataEncoded!) as? [String: String]
            if jsonData != nil {
                return jsonData!
            }
        }
        return [:]
    }
}
