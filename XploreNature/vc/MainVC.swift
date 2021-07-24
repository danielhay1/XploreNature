//
//  MainVC.swift
//  XploreNature
//
//  Created by user196210 on 7/7/21.
//

import Foundation
import MapKit
import UIKit
import CoreLocation
class MainVC: UIViewController {
    
    @IBOutlet weak var main_SC_type: UISegmentedControl!
    @IBOutlet weak var main_TV_xplorePosts: UITableView!
    
    var postImages: [UIImageView] = []
    var data: [Xplore] = []
    var filteredData: [Xplore] = []
    var user = User()
    var locationManager: CLLocationManager = CLLocationManager()
    let firebase = MyFirebaseServies()
    let preference = myPreference()
    override func viewDidLoad() {
        super.viewDidLoad()
        //in case that user chose post location and didn't poste the Xplore -> clears post data from memory
        self.preference.RemovePostDetails()
        self.firebase.delegate = self
        // load all xplores
        if(self.data.isEmpty) {
            self.firebase.listenDatabase()
        }
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadUser() -> User? {
        let preference = myPreference()
        return preference.decodeUserFromPreference()
    }
    
    func saveUser() {
        let preference = myPreference()
        preference.saveUserToPreference(user: self.user)
        print("USER SAVED!\t user:\(user)")
    }
    
    func filterData(type: Int, data: [Xplore])->[Xplore] {
        print("Selected type:\(type)")
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
    
    func displayData() {
        //update tablview data
        self.main_TV_xplorePosts.dataSource = self
        self.main_TV_xplorePosts.register(UINib(nibName: "xplorePostCell", bundle: nil), forCellReuseIdentifier: "xplorePostCell")
        DispatchQueue.main.async{
            self.main_TV_xplorePosts.reloadData()
        }
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
        self.filteredData = filterData(type: type, data: self.data)
        displayData()
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
        print(self.filteredData.count)
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("UPDATING TABLEVIEW...,Index path = \(indexPath)")
        let cell = main_TV_xplorePosts.dequeueReusableCell(withIdentifier: "xplorePostCell", for: indexPath) as! xplorePostCell
        cell.lat = self.filteredData[indexPath.row].lat
        cell.lon = self.filteredData[indexPath.row].lon
        cell.cell_LBL_name.text = "Place Name: \(self.filteredData[indexPath.row].name)"
        cell.cell_LBL_type.text = "Type: \(String(describing: self.filteredData[indexPath.row].getXploreType()))"
        cell.cell_LBL_date.text = "\(self.filteredData[indexPath.row].date)"
        //cell.cell_IMG.downloaded(from: self.data[indexPath.row].img)
        self.firebase.downloadImage(strUrl: self.filteredData[indexPath.row].img, ImageView: cell.cell_IMG)
        cell.actionDelegate = self
        cell.cell_LBL_description.text = "Description:\n\(self.filteredData[indexPath.row].desc)"
        cell.cell_LBL_arrivalInstructions.text = "arrivalInstructions:\n\(self.filteredData[indexPath.row].ArrivalInstructions)"
        return cell
    }
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error)")
        saveUser()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\nLocation readed.")
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
    func googleIt(search: String) {
        print("Searching in google...")
        if let url = URL(string:"https://google.com") {
            print("***")
            UIApplication.shared.open(url)
        }
    }
    
    func navigateDest(lat: Double, lon: Double) {
        let coordinate = CLLocationCoordinate2DMake(lat,lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])    }
}

extension MainVC: MyFireBaseDelegate {
    func downloadImageFinished(strUrl: String, ImageView: UIImageView) {
        DispatchQueue.main.async{
            ImageView.downloaded(from: strUrl)
        }
    }
    
    func dataIsReady(xplore: Xplore) {
        self.data.append(xplore)
        xplore_counter = data.count
        print("DATA: \(String(describing: self.data))")
        self.data = self.data.sorted(by: {$0.calcDistance(user: user, xplore: $0) < $1.calcDistance(user: user, xplore: $1)}) // Sort data by distance from user
        self.filteredData = self.data
        self.displayData()
        print("xplore_counter = \(xplore_counter)")

    }
}
