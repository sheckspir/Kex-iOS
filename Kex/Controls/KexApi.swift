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
}

extension KexApi: TargetType {
    var method: Moya.Method {
//        todo здесь добавить различные методы для пост, гет, пут и делете
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        // а чё проще нельзя было?! todo автоматический перевод объекта в json
        case let .registration(registrationData):
            return .requestParameters(parameters: [
                "name": registrationData.name,
                "email": registrationData.email,
                "password": registrationData.password,
                "login": registrationData.login,
                "sex": Sex.M.rawValue,
            ], encoding: JSONEncoding.default)
        case let .login(loginData):
            return .requestParameters(parameters: [
                "username": loginData.username,
                "password": loginData.password,
            ], encoding: JSONEncoding.default)
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
        }
    }
}
