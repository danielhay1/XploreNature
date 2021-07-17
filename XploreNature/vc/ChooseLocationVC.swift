//
//  ChooseLocationVC.swift
//  XploreNature
//
//  Created by user196210 on 7/8/21.
//

import UIKit
import CoreLocation
import MapKit

class ChooseLocationVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var marker: MKPointAnnotation?
    let preference = myPreference()
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializeTheLocationManager()
        let gestureRecognizer = UITapGestureRecognizer(
                                      target: self, action:#selector(handleTap))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        //set location
        if(marker != nil){
            let lat = marker!.coordinate.latitude
            let lon = marker!.coordinate.longitude
            preference.savePostLocationToPreference(lat: lat, lon: lon)
            //change to PostVC
            guard let vc = storyboard?.instantiateViewController(identifier: "Post") as? PostVC else {
                print("failed to get vc from storyboard")
                return
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

}

extension ChooseLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location readed.")
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let center = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            print("My location:[\(lastLocation.coordinate.latitude),\(lastLocation.coordinate.longitude)]")
        }
    }
}

extension ChooseLocationVC: MKMapViewDelegate {

   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      print("calloutAccessoryControlTapped")
   }

   func mapView(_ mapView: MKMapView, didSelect view:   MKAnnotationView){
        print("didSelectAnnotationTapped")
   }
}

extension ChooseLocationVC: UIGestureRecognizerDelegate {
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        if(marker != nil) {
            mapView.removeAnnotation(marker!)
        }
        marker = annotation
        mapView.addAnnotation(marker!)
        print("new marker at:[\(coordinate.latitude),\(coordinate.longitude)]")
    }
}
