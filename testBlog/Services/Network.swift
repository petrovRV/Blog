//
//  File.swift
//  testBlog
//
//  Created by Mac on 17.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import SystemConfiguration

class Network {
    
    private var disposeBag = DisposeBag()
    private var decoder = JSONDecoder()
    var dateFormatter = DateFormatter()
    
    init() {
        disposeBag = DisposeBag()
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    //MARK: Check internet connection
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK: Method for request
    func getObject<D: Decodable>(method: HTTPMethod = .get, url: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, heder: [String : String]? = nil, type: D.Type) -> Observable<D> {
        
        return requestData(method, url, parameters: parameters, encoding: encoding, headers: heder)
            .map{ (r, data) in
                do {
                    return try self.decoder.decode(type, from: data)
                }catch {
                    throw NetworkError.IncorrectDataReturned
                }
        }
    }
    
}
