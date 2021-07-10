//
//  MainVC.swift
//  XploreNature
//
//  Created by user196210 on 7/7/21.
//

import Foundation
//
//  MainViewController.swift
//  Xplore nature
//
//  Created by user196210 on 6/23/21.
//

import UIKit
import CoreLocation
import Firebase
class MainVC: UIViewController {
    
    @IBOutlet weak var main_SC_type: UISegmentedControl!
    @IBOutlet weak var main_TV_xplorePosts: UITableView!
    
    var data: [Xplore] = []
    var user = User()
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        self.data = loadDataFromFB()
        displayData(data: self.data, user: user)
        // Do any additional setup after loading the view.
    }
    
    func loadUser() -> User? {
        let preference = myPreference()
        return preference.decodeUserFromPreference()
    }
    
    func loadDataFromFB() -> [Xplore] {
        var xploreList : [Xplore] = []
        for _ in 0...3 {
            let xplore = Xplore(name: "Title", type: 0, img: "xplore.png"
                                , desc: "description", ArrivalInstructions: "Arrival description", lat: 0, lon: 0)
            xploreList.append(xplore)
        }
        return xploreList
    }
    
    func setUserLocation() {
        print("REQUESTING PLAYER LOCATION...")
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func saveUser() {
        let preference = myPreference()
        preference.saveUserToPreference(user: self.user)
        print("USER SAVED!\t user:\(user)")
    }
    
    func filterData(type: Int, data: [Xplore])->[Xplore] {
        if(type == -1){
            return data
        } else {
            var xploreList : [Xplore] = []
            for xplore in data {
                if(xplore.type == type) {
                    xploreList.append(xplore)
                }
            }
            return xploreList
        }
    }
    
    func displayData(data: [Xplore],user: User) {
        let data = data.sorted(by: {$0.calcDistance(user: user, xplore: $0) > $1.calcDistance(user: user, xplore: $1)}) // Sort data by distance from user
        //update tablview data
        main_TV_xplorePosts.dataSource = self
        main_TV_xplorePosts.register(UINib(nibName: "XploreTableViewCell", bundle: nil), forCellReuseIdentifier: "xplorePostsCell")
        main_TV_xplorePosts.reloadData()
    }
    
    
    @IBAction func selectXploreTypePosts(_ sender: Any) {
        var type = -1
        switch main_SC_type.selectedSegmentIndex {
        case 0:
            type = -1
        case 1:
            type = 0
        case 2:
            type = 1
        case 3:
            type = 2
        case 4:
            type = 3
        default:
            type = -1
            break;
        }
        let filteredData = filterData(type: type, data: self.data)
        displayData(data: filteredData, user: user)
    }
    @IBAction func postXplore(_ sender: Any) {
        // Open new viewController
        guard let vc = storyboard?.instantiateViewController(identifier: "Post") as? PostVC else {
            print("failed to get vc from storyboard")
            return
        }
        present(vc, animated: true, completion: nil)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "XploreTableViewCell", for: indexPath) as! XploreTableViewCell
        cell.cell_LBL_name.text = data[indexPath.row].name
        cell.cell_LBL_type.text = "Type: \(String(describing: data[indexPath.row].getXploreType()))"
        cell.cell_LBL_date.text = data[indexPath.row].date
        cell.cell_LBL_img.image = UIImage(named: data[indexPath.row].img)
        cell.cell_LBL_description.text = data[indexPath.row].desc
        cell.cell_LBL_arrivalInstructions.text = data[indexPath.row].ArrivalInstructions
        return cell
    }
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error)")
        saveUser()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location readed.")
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = lastLocation.coordinate.latitude
            let lon = lastLocation.coordinate.longitude
            print("LOCATION MANAGER:\tlocation: [\(lat),\(lon)]")
            //Update player location
            user.setLocation(lat: lat, lon: lon)
        }
        saveUser()
    }
}

extension MainVC: CellActionDelegate{
    func cellBtnTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Post") as? PostVC else {
            print("failed to get vc from storyboard")
            return
        }
        present(vc, animated: true, completion: nil)
    }
}
