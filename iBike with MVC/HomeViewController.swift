//
//  ViewController.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/26.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var nearbyButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showStationsView: UIView!
    @IBOutlet weak var showStationsTableView: UITableView!
    
    /*locationManager有CLLocationManager屬性*/
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 24.164005, longitude: 120.637622, zoom: 12.0)
        mapView.camera = camera
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundView.layer.borderWidth = 1
        
        /*宣告HomeViewController為locationManager的Delegate，並且開始更新位置*/
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        /*宣告HomeViewController為searchBar的Delegate*/
        searchBar.delegate = self
        
        /*查看使用者先前是否有允許位置存取，有的話就向locationManager要使用者位置*/
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            
            /*使用者位置會顯示藍點，地圖上也會顯示位置按鈕*/
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            
            /*假設使用者先前沒有允許位置存取，就向使用者要求授權*/
            locationManager.requestWhenInUseAuthorization()
        }
        
        showStationsView.isHidden = true
        showStationsTableView.dataSource = self
        showStationsTableView.delegate = self
        
        showMarkers()
    }
    
    /*解析後的JSON放入地圖中，產生GMSMarker()，並指定position、title、snippet*/
    func showMarkers() {
        decodeJson { (stationName, lat, long, address, available, empty, updateTime) in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = "\(stationName)"
            marker.snippet = "\(address)\n可借車位：\(available), 可停空位：\(empty)\nUpdate Time：\(updateTime)"
            marker.map = self.mapView
        }
        
    }
    
    @IBAction func didTapNearbyButton(_ sender: Any) {
        
        if (showStationsView.isHidden == true) {
            showStationsView.isHidden = false
            mode = .showNearbyStations
            showStationsTableView.reloadData()
        }
        else {
            showStationsView.isHidden = true
        }
    }
    
    enum situation {
        case showAllStations
        case showNearbyStations
        case showSearchStations
    }
    
    var mode : situation = .showAllStations
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch mode {
        case .showAllStations:
            return allStationsArray.count
        
        case .showNearbyStations:
            return nearbyStationsArray.count
        
        case .showSearchStations:
            return searchResultsArray.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "showStationsCell") as? ShowStationsTableViewCell {
            
            var data: ALLiBike?
            
            switch mode {
                
            case .showAllStations:
                data = allStationsArray[indexPath.row]
                
            case .showNearbyStations:
                data = nearbyStationsArray[indexPath.row]
                
            case .showSearchStations:
                data = searchResultsArray[indexPath.row]
            }
            
            cell.stationsNameButton.contentHorizontalAlignment = .leading
            cell.stationsNameButton.setTitle(data?.Position!, for: .normal)
            cell.availableImageView.image = UIImage(named: "availableImage")
            cell.availableLabel.text = String((data?.AvailableCNT!)!)
            cell.emptyImageView.image = UIImage(named: "emptyImage")
            cell.emptyLabel.text = String((data?.EmpCNT!)!)
            cell.addressLabel.text = String((data?.CAddress!)!)
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    
}

extension HomeViewController: CLLocationManagerDelegate, UISearchBarDelegate {
    
    // MARK: - LocationManager
    /*Tells the delegate its authorization status when the app creates the location manager and when the authorization status changes.*/
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        /*向locationManager索取位置*/
        locationManager.requestLocation()
        
        /*添加使用者位置指示*/
        mapView.isMyLocationEnabled = true
        /*添加使用者位置按鈕*/
        mapView.settings.myLocationButton = true
        
    }
    
    /*Tells the delegate that new location data is available.*/
    /*locations: An array of CLLocation objects containing the location data.*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*收到新的位置資訊就會執行*/
        guard let location = locations.last else {
            return
        }
        
        /*將map's camera移到使用者的位置，放大設15，方位角度設零*/
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        let currentLocation = locations[(locations.count)-1] as CLLocation;
        
        decodeJson { (stationName, lat, long, address, available, empty, updateTime) in
            
            /*coordinate1設為現在位置經緯度*/
            let coordinate1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            /*coordinate設為站點經緯度*/
            let coordinate2 = CLLocation(latitude: Double(lat), longitude: Double(long))
            /*計算他們之間的距離*/
            let distanceInMeters = coordinate2.distance(from: coordinate1)
            
            /*distanceInMeters小於1500的，放到nearbyStationsArray裡面*/
            if distanceInMeters < 1500 {
                
                print(distanceInMeters)
                let nearbyStations = ALLiBike.init(X: long, Y: lat, Position: stationName, CAddress: address, AvailableCNT: available, EmpCNT: empty, UpdateTime: updateTime)
                nearbyStationsArray.append(nearbyStations)
                print(nearbyStations)
                
            }

        }
   
        
    }

    /*如果locationManager收到error參數就印出錯誤，*/
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: - SearchBar
    /*Tells the delegate when the user begins editing the search text.*/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        /*開始打字的時候，mode是顯示全部站點*/
        mode = .showAllStations
        showStationsTableView.reloadData()
        showStationsView.isHidden = false
    }
    
    /*Tells the delegate that the user changed the search text.*/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*如果輸入字串是空的，就顯示全部站點*/
        guard !searchText.isEmpty else {
            mode = .showAllStations
            showStationsTableView.reloadData()
            return
        }
        
        /*使用「.filter」過濾allStationsArray裡的字串*/
        /*filterArray做為閉包的參數去回傳布林值，指出words是否包含在filterArray內*/
        searchResultsArray = allStationsArray.filter({(filterArray) -> Bool in
            guard let words = searchBar.text else { return false }
            return (filterArray.Position?.contains(words))!
        })
        
        mode = .showSearchStations
        showStationsTableView.reloadData()
    }
}
