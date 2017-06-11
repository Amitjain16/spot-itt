//
//  ViewController.swift
//  Spott
//
//  Created by Amit Jain on 3/25/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import AddressBookUI
import CoreData


//var name = ""
var latitudeIs: Double = 0.0
var longitudeIs: Double = 0.0
let date = Date()

@available(iOS 10.0, *)
class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    @IBOutlet weak var viewForMap: UIView!
    
    @IBOutlet weak var nameOfLocation: UITextField!
    
    
    @IBOutlet var popupViewForSaveContact: UIView!
    


    

    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

        super.viewDidLoad()



    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        latitudeIs = location.coordinate.latitude
        longitudeIs = location.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 16)
        
          let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.viewForMap.frame.size.width, height: self.viewForMap.frame.size.height), camera: camera)


             viewForMap.addSubview(mapView)

            let marker  = GMSMarker()
            marker.position = camera.target
            marker.snippet = "My Location"
            marker.map = mapView
           // self.view = mapView
    
    }
    
    
    @IBAction func SaveButtonOpenPopup(_ sender: Any) {
        animateIn()
        
    }
    func animateIn(){
        self.view.addSubview(popupViewForSaveContact)
        popupViewForSaveContact.center =  self.view.center
        popupViewForSaveContact.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupViewForSaveContact.alpha = 0
        UIView.animate(withDuration: 0.4){
          
            self.popupViewForSaveContact.alpha = 1
            self.popupViewForSaveContact.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations:{
            self.popupViewForSaveContact.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popupViewForSaveContact.alpha = 0
            
            
        }) {(success: Bool) in
            self.popupViewForSaveContact.removeFromSuperview()
        }
    }
    
    
    
    
    @IBAction func saveContactNLatNLon(_ sender: Any) {
        if(nameOfLocation.text != ""){
            var nameEnterIs  = nameOfLocation.text!

            nameOfLocation.text = ""
            animateOut()
            
            
            let newLocation = CLLocation(latitude: latitudeIs, longitude: longitudeIs)

            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
                if error != nil {
                    // create the alert
                    let alert = UIAlertController(title: "Failed", message: "Need internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)

                }
                if(placemarks == nil) {
                    
                }
                    
                else if (placemarks!.count > 0 && placemarks != nil) {
                    let placemark = placemarks![0]

                  //       let address = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false);
                    
                    //Inserting data
                    func insertData(){
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        

                        let user = User(context: context)
                        let formatter = DateFormatter()
                        formatter.dateStyle = .full

                        user.name = nameEnterIs
                        user.latitude = latitudeIs
                        user.longitude = longitudeIs
                  //      user.address = address
                        user.date = formatter.string(from: date)
                        
                        appDelegate.saveContext()

                        
                    }
                    insertData()
                    
                    
                    
                }
                else{
                    // create the alert
                    let alert = UIAlertController(title: "Failed", message: "Need strong internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                
                }
                
            })
            animateOut()
        
        
        
        }
        
        
    }
    
    //share button
    
    @IBAction func sharewithsocial(_ sender: Any) {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location: CLLocation = locations.last!
            
            latitudeIs = location.coordinate.latitude
            longitudeIs = location.coordinate.longitude

            
        }
        
            let latit : String = String(latitudeIs)
             let longit : String = String(longitudeIs)
            let url = URL(string: "https://maps.google.com/?q=\(latit),\(longit)")!
            
             let shareLocation = UIActivityViewController(activityItems: [url], applicationActivities: nil)
     
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                if shareLocation.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                shareLocation.popoverPresentationController?.sourceView = shareLocation.view
                }
            }
            self.present(shareLocation, animated : true, completion : nil)

            

        
    }
    
    
    @IBAction func parkingSpotButtonAction(_ sender: Any) {
        var nameEnterIs  = "Parked Spot"
        
         animateOut()
        
        let newLocation = CLLocation(latitude: latitudeIs, longitude: longitudeIs)

        CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
            if error != nil {
                // create the alert
                let alert = UIAlertController(title: "Failed", message: "Need internet connection", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)

            }
            if(placemarks == nil) {
                
            }
            
            else if (placemarks!.count > 0 && placemarks != nil) {
                let placemark = placemarks![0]
                
                
          //      let address = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false);
                
                //Inserting data
                func insertData(){
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    
                    let user = User(context: context)
                    let formatter = DateFormatter()
                    formatter.dateStyle = .full
                    
                    user.name = nameEnterIs
                    user.latitude = latitudeIs
                    user.longitude = longitudeIs
           //         user.address = address
                    user.date = formatter.string(from: date)
                    
                    appDelegate.saveContext()

                    
                }
                insertData()
                
            }
            else{
                // create the alert
                let alert = UIAlertController(title: "Failed", message: "Need strong internet connection", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        })
        animateOut()
        
    }

    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            // create the alert
            let alert = UIAlertController(title: "Location Access", message: "Location access was restricted.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("Location access was restricted.")
        case .denied:
            let alert = UIAlertController(title: "Location Access", message: "Please allow to access the location.Change in the settings for location access.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            // create the alert
            let alert = UIAlertController(title: "Location Access", message: "Location status is not determined", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

    
    @IBAction func cancelButtonDismiss(_ sender: Any) {
        animateOut()
        
    }
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()

    }

}

