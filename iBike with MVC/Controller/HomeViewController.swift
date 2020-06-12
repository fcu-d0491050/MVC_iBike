//
//  ViewController.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/26.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {
    
    enum Situation {
           case showAllStations
           case showNearbyStations
           case showSearchStations
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var nearbyButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showStationsView: UIView!
    @IBOutlet weak var showStationsTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    
    var mode : Situation = .showAllStations
    var nearbyStationsArray : [ALLiBike] = []
    var searchResultsArray: [ALLiBike] = []
    
    /*locationManager有CLLocationManager屬性*/
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundView.layer.borderWidth = 1
        menuView.isHidden = true
        
        /*宣告HomeViewController為searchBar的Delegate*/
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        showStationsView.isHidden = true
        showStationsTableView.dataSource = self
        showStationsTableView.delegate = self
        
        getStationData()
        
    }
    
    // MARK: - TapButton
    @IBAction func didTapMenuButton(_ sender: Any) {
        
        menuView.isHidden = !menuView.isHidden
        
    }
    
    @IBAction func didTapServiceButton(_ sender: Any) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let serviceVC = storyboard.instantiateViewController(identifier: "ServiceTableViewController")
           serviceVC.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(serviceVC, animated: true)
           
       }
       
       
    @IBAction func didTapWebButton(_ sender: Any) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let webVC = storyboard.instantiateViewController(identifier: "WebViewController")
           webVC.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(webVC, animated: true)
    }
    
    @IBAction func didTapNearbyButton(_ sender: Any) {
        
        if (showStationsView.isHidden == true) {
            mode = .showNearbyStations
            showStationsTableView.reloadData()
            showStationsView.isHidden = false
        }
        else {
            showStationsView.isHidden = true
        }
    }
    
}

// MARK: - Set GoogleMap
extension HomeViewController {
    
    private func initMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 24.164005, longitude: 120.637622, zoom: 12.0)
        mapView.camera = camera
        /*宣告HomeViewController為locationManager的Delegate*/
        locationManager.delegate = self
        /*宣告HomeViewController為mapView的Delegate*/
        mapView.delegate = self
        
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
    }
    
    private func getStationData() {
        API.shared.decodeJson { map in
            DispatchQueue.main.async {
                self.initMap()
            }
            
        }
    }
    
}

// MARK: - TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch mode {
        case .showAllStations:
            return API.shared.stations.count
            
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
                data = API.shared.stations[indexPath.row]
                
            case .showNearbyStations:
                data = nearbyStationsArray[indexPath.row]
                
            case .showSearchStations:
                data = searchResultsArray[indexPath.row]
            }
            
            if let iBikeData = data {
                cell.configCell(iBikeData, delegate: self)
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
    
}

// MARK: - LocationManager
extension HomeViewController: CLLocationManagerDelegate {
    
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
        
        nearbyStationsArray = []
        let allStationsArray = API.shared.stations
        for item in allStationsArray {
            let coordinate1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let coordinate2 = CLLocation(latitude: item.Y!, longitude: item.X!)
        
            if coordinate2.distance(from: coordinate1) < 1500 {
                nearbyStationsArray.append(item)
            }
        }
        
    }
    
    /*如果locationManager收到error參數就印出錯誤，*/
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

// MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        showStationsView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        showStationsView.isHidden = true
    }
    
    /*Tells the delegate when the user begins editing the search text.*/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        /*開始打字的時候，mode是顯示全部站點*/
        self.mode = .showAllStations
        self.showStationsTableView.reloadData()
        self.showStationsView.isHidden = false
        
    }
    
    
    /*Tells the delegate that the user changed the search text.*/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*如果輸入字串是空的，就顯示全部站點*/
        guard !searchText.isEmpty else {
            self.mode = .showAllStations
            self.showStationsTableView.reloadData()
            return
        }
        
        /*使用「.filter」過濾allStationsArray裡的字串*/
        /*filterArray做為閉包的參數去回傳布林值，指出words是否包含在filterArray內*/
        searchResultsArray = API.shared.stations.filter{(filterArray) -> Bool in
            guard let words = searchBar.text else { return false }
            return (filterArray.Position?.contains(words))!
        }
        
        self.mode = .showSearchStations
        self.showStationsTableView.reloadData()
    }
    
}


// MARK: - MapView
extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if mapView.camera.zoom < 14 {
            mapView.clear()
        }
        
        let allStationsArray = API.shared.stations
        for station in allStationsArray {
            
            let cameraPosition = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            let stations = CLLocation(latitude: station.Y!, longitude: station.X!)
            
            if cameraPosition.distance(from: stations) < 1500 {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: station.Y!, longitude: station.X!)
                marker.title = "\(station.Position!)"
                marker.snippet = "\(station.CAddress!)\n可借車位：\(station.AvailableCNT!), 可停空位：\(station.EmpCNT!)"
                marker.map = self.mapView
                
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        /*移除掉現有的marker顏色*/
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = GMSMarker.markerImage(with: nil)
        }
        
        /*把新Tap的marker變成綠色*/
        mapView.selectedMarker = marker
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        
        let currentLocationLat = locationManager.location!.coordinate.latitude
        let currentLocationLong = locationManager.location!.coordinate.longitude
        let destinationLat = marker.layer.latitude
        let destinationLong = marker.layer.longitude
        
        let origin = "\(currentLocationLat),\(currentLocationLong)"
        let destination = "\(destinationLat),\(destinationLong)"
        
        API.shared.drawDirection(origin: origin, destination: destination) { (polyline) in
            mapView.clear()
            marker.map = mapView
            polyline.map = mapView

        }
        return true
    }
    
    /*點地圖的時候Menu收起來*/
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        menuView.isHidden = true
    }
    
    /*拖曳地圖的時候Menu收起來*/
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture == true {
            menuView.isHidden = true
            showStationsView.isHidden = true
        }
    }
    
}

// MARK: - MyButtonDelegate
extension HomeViewController: ShowStationsCellDelegate {
    
    func tapButton(data: ALLiBike) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: data.Y!, longitude: data.X!))
        NSLog("ALLiBike: \(data)")
        
    }
}
