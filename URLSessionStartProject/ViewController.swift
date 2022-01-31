//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeCall()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<String> = { result, response in
            guard let responseUnwrapped = response else { return }

            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let team):
                print("team = \(team)")
                
            case .failure(let error):
                print(error)
            }
        }
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}

final class GetNameEndpoint: ObjectResponseEndpoint<String> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/public/characters" }
    let timeStamp = NSDate().timeIntervalSince1970
    let publicApiKey = "0974ca1c2fd4f246e6c0f6a8816c072a"
    let privateApiKey = "4fbd8a1701e52eba2fa8205ff864818148047132"
    var obligatoryItems: [URLQueryItem] {
        return [URLQueryItem(name: "ts", value: "\(timeStamp)"),
        URLQueryItem(name: "apikey", value: "\(publicApiKey)"),
        URLQueryItem(name: "hash", value: "\(md5Hash(String(timeStamp) + privateApiKey + publicApiKey))")]
    }
    
    override init() {
        super.init()
        queryItems = [URLQueryItem(name: "name", value: "Groot")] + obligatoryItems
    }
    
    private func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }

}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

