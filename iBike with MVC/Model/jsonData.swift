//
//  jsonData.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/26.
//  Copyright © 2020 CS01196. All rights reserved.
//

import Foundation

struct ALLiBike : Codable {
    let X : Double?
    let Y : Double?
    let Position : String?
    let CAddress : String?
    let AvailableCNT : Int?
    let EmpCNT : Int?
    let UpdateTime : String?
    
}

var stations = [ALLiBike]()
var nearbyStationsArray : [ALLiBike] = []
var allStationsArray : [ALLiBike] = []
var searchResultsArray : [ALLiBike] = []

/*Escaping closure captures non-escaping parameter 'useData'，所以加上「@escaping」*/
func decodeJson(useData: @escaping(_ position: String, _ lat: Double, _ long: Double, _ address: String, _ available: Int, _ empty: Int, _ update: String) -> Void){
    
    guard let iBikeURL = URL(string: "http://e-traffic.taichung.gov.tw/DataAPI/api/YoubikeAllAPI") else {
        return }
    
    URLSession.shared.dataTask(with: iBikeURL) { (data, reponse, error) in
        
        if error == nil {
            do {
                
                stations = try JSONDecoder().decode([ALLiBike].self, from: data!)
                print("jsonData() stations.count：\(stations.count)")
                
                DispatchQueue.main.async {
                    for item in stations {
                        
                        let allStations = ALLiBike.init(X: Double(item.X!), Y: Double(item.Y!), Position: String(item.Position!), CAddress: String(item.CAddress!), AvailableCNT: item.AvailableCNT!, EmpCNT: item.EmpCNT!, UpdateTime: String(item.UpdateTime!))
                        allStationsArray.append(allStations)
                        
                        useData(item.Position!, item.Y!, item.X!, item.CAddress!, item.AvailableCNT!, item.EmpCNT!, item.UpdateTime!)
                    }
                }
            }
            catch let Error {
                print("Error: \(Error)")
            }
        }
    }.resume()
    
}

