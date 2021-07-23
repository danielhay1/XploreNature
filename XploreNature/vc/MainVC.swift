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
    var user = User()
    var locationManager: CLLocationManager = CLLocationManager()
    let firebase = MyFirebaseServies()
    let preference = myPreference()
    override func viewDidLoad() {
        super.viewDidLoad()
        main_TV_xplorePosts.rowHeight = UITableView.automaticDimension
        //in case that user chose post location and didn't poste the Xplore -> clears post data from memory
        self.preference.removePostLocationFromPreference()
        preference.removePostImageFromPreference()

        self.firebase.delegate = self
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
    
    func initXploreListView() {
        self.firebase.loadAllXploresFromFirebase()   // load all xplores from firebase
        
        //for _ in 0...3 {
        //    let xplore = Xplore(name: "Title", type: 0, img: "xplore.png"
        //                       , desc: "description", ArrivalInstructions: "Arrival description", lat: 0, lon: 0)
        //    xploreList.append(xplore)
        //}
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
    
    func textView(_ textView: UITextView, replacementText text: String) {

    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.data.count)
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("UPDATING TABLEVIEW...,Index path = \(indexPath)")
        let cell = main_TV_xplorePosts.dequeueReusableCell(withIdentifier: "xplorePostCell", for: indexPath) as! xplorePostCell
        //Init cell UI configuration:
        
        
        // this will turn on `masksToBounds` just before showing the cell
        cell.lat = self.data[indexPath.row].lat
        cell.lon = self.data[indexPath.row].lon
        cell.cell_LBL_name.text = "Posted by: \(self.data[indexPath.row].name)"
        cell.cell_LBL_type.text = "Type: \(String(describing: self.data[indexPath.row].getXploreType()))"
        cell.cell_LBL_date.text = "\(self.data[indexPath.row].date)"
        //cell.cell_IMG.downloaded(from: self.data[indexPath.row].img)
        self.firebase.downloadImage(strUrl: self.data[indexPath.row].img, ImageView: cell.cell_IMG)
        cell.actionDelegate = self
        cell.cell_LBL_description.text = "Description: ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd. \(self.data[indexPath.row].desc)"
        cell.cell_LBL_arrivalInstructions.text = "arrivalInstructions: \(self.data[indexPath.row].ArrivalInstructions)"
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
        // load all xplores
        initXploreListView()
    }
}

extension MainVC: CellActionDelegate{
    func navigateDest(lat: Double, lon: Double) {
        let coordinate = CLLocationCoordinate2DMake(lat,lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])    }
}

extension MainVC: MyFireBaseDelegate {
    func uploadImageFinished() {
        self.initXploreListView()
    }
    
    func downloadImageFinished(strUrl: String, ImageView: UIImageView) {
        DispatchQueue.main.async{
            ImageView.downloaded(from: strUrl)
        }
    }
    
    func dataIsReady(xplores: [Xplore]) {
        self.data = xplores
        print("DATA: \(String(describing: self.data))")
        self.data = self.data.sorted(by: {$0.calcDistance(user: user, xplore: $0) > $1.calcDistance(user: user, xplore: $1)}) // Sort data by distance from user
        self.displayData(data: self.data, user: self.user)
    }
}
