//
//  jsonData.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/26.
//  Copyright © 2020 CS01196. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

struct ALLiBike : Codable {
    let X : Double?
    let Y : Double?
    let Position : String?
    let CAddress : String?
    let AvailableCNT : Int?
    let EmpCNT : Int?
    let UpdateTime : String?
    
}

class API {
    
    static let shared = API()
    private(set) var stations = [ALLiBike]()
    
    
    /*Escaping closure captures non-escaping parameter 'useData'，加上「@escaping」*/
    func decodeJson(useData: @escaping(_ bike: [ALLiBike]) -> Void) {
        
        guard let iBikeURL = URL(string: "http://e-traffic.taichung.gov.tw/DataAPI/api/YoubikeAllAPI") else { return }
        
        URLSession.shared.dataTask(with: iBikeURL) { (data, reponse, error) in
            
            if error == nil, let iBikedata = data {
                
                do {
                    
                    let jsonArray = try JSON(data: iBikedata).arrayValue
                    
                    let result = jsonArray.map { (data) -> ALLiBike in
                        return ALLiBike(X: data["X"].double,
                                        Y: data["Y"].double,
                                        Position: data["Position"].string,
                                        CAddress: data["CAddress"].string,
                                        AvailableCNT: data["AvailableCNT"].int,
                                        EmpCNT: data["EmpCNT"].int,
                                        UpdateTime: data["UpdateTime"].string)
                    }
                    
                    self.stations = result
                    useData(result)
                    
                }
                catch let Error {
                    print("Error: \(Error)")
                }
            }
        }.resume()
        
    }
    
    
    func drawDirection(origin: String, destination: String, callPolyline: @escaping(_ polyline: GMSPolyline) -> Void) {
        
        guard let directionURL = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAmkTSjQIXl9HaUUKtKNLLdnhL27jTdVAA") else {
            return
        }
        
        AF.request(directionURL).responseJSON { (reseponse) in
            
            guard let data = reseponse.data else { return }
            
            
            do {
                
                let googleData = try JSON(data: data)
                let routes = googleData["routes"].arrayValue
                for route in routes {
                    
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = nil
                    callPolyline(polyline)

                }
            }
            catch let Error {
                print("Error: \(Error)")
            }
        }
        
    }
    
}
