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
    case groupQuestions(groupId : Int)
    case getQuizQuestions(groupId : Int)
    case sendAnswer(answer : QuestionSavingAnswer)
    case sendAnswers(answers: [QuestionSavingAnswer])
    case deleteAnswers(groupData : GroupDeleteInfo)
    
    case getMatch(partnerId : Int)
    case getOfferToPartner(groupId: Int, questionId: Int, partnerId: Int)
    
    case getPartners
    case findPartner(login: String)
    case addPartner(partnerInfo: PartnerInfo)
    case confirmPartner(partnerInfo: PartnerInfo)
    case rejectPartner(partnerInfo: PartnerInfo)

}
extension KexApi: TargetType {
    var method: Moya.Method {
        switch self {
        case .registration, .login, .addPartner, .confirmPartner, .rejectPartner:
            return .post
        case .sendAnswer, .sendAnswers:
            return .put
        case .deleteAnswers:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .registration(registrationData):
            return .requestParameters(parameters: registrationData.toDict(), encoding: JSONEncoding.default)
        case let .login(loginData):
            return .requestParameters(parameters: loginData.toDict(), encoding: JSONEncoding.default)
        case let .groupQuestions(groupId):
            return .requestParameters(parameters: ["groupId" : groupId], encoding: URLEncoding.default)
        case let .getQuizQuestions(groupId):
            return .requestParameters(parameters: ["groupId": groupId], encoding: URLEncoding.default)
        case let .sendAnswer(answer):
            return .requestParameters(parameters: answer.toDict(), encoding: JSONEncoding.default)
        case let .sendAnswers(answers):
            return .requestParameters(parameters: answers.toDict(), encoding: JSONEncoding.default)
        case let .deleteAnswers(groupData):
            return .requestParameters(parameters: groupData.toDict(), encoding: JSONEncoding.default)
        case let .findPartner(login: login):
            return .requestParameters(parameters: ["login" : login], encoding: URLEncoding.default)
        case let .addPartner(partnerInfo: partnerInfo):
            return .requestParameters(parameters: partnerInfo.toDict(), encoding: JSONEncoding.default)
        case let .confirmPartner(partnerInfo: partnerInfo):
            return .requestParameters(parameters: partnerInfo.toDict(), encoding: JSONEncoding.default)
        case let .rejectPartner(partnerInfo: partnerInfo):
            return .requestParameters(parameters: partnerInfo.toDict(), encoding: JSONEncoding.default)
            
        case let .getMatch(partnerId: partnerId):
            return .requestParameters(parameters: ["partnerId": partnerId], encoding: URLEncoding.default)
        case let .getOfferToPartner(groupId: groupId, questionId: questionId, partnerId: partnerId):
            return .requestParameters(parameters: ["groupId": groupId, "questionId" : questionId, "partnerId": partnerId], encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .registration:
            return "/registration"
        case .allGroups:
            return "/groups"
        case .groupQuestions:
            return "/groups/byId"
        case .getQuizQuestions:
            return "/questions"
        case .sendAnswer:
            return "/questions/answer"
        case .sendAnswers:
            return "/questions/answers"
        case .deleteAnswers:
            return "/questions/answers"
            
        case .getMatch:
            return "/connection"
        case .getOfferToPartner:
            return "/questions/offer"
            
        case .getPartners:
            return "/partners"
        case .findPartner:
            return "/partners/find"
        case .addPartner:
            return "/partners/request"
        case .confirmPartner:
            return "/partners/confirm"
        case .rejectPartner:
            return "/partners/reject"
        }
        
    }
    
    var sampleData: Data {
        return Data()
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

}

extension Encodable {
    func toDict() -> [String: Any] {
        let dataEncoded = try? JSONEncoder().encode(self)
        if dataEncoded != nil {
            let jsonData = try? JSONSerialization.jsonObject(with: dataEncoded!) as? [String: Any]
            if jsonData != nil {
                return jsonData!
            }
        }
        return [:]
    }
}
