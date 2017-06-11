//
//  CreateViewController.swift
//  Spott
//
//  Created by Amit Jain on 3/26/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import AddressBookUI
import CoreLocation


var latitudeIsa: Double = 0.0
var longitudeIsa: Double = 0.0


@available(iOS 10.0, *)
class CreateViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameOflocationForAddress: UITextField!
    
    
    @IBOutlet weak var addressTypeByUser: UITextField!

    @IBAction func saveAddress(_ sender: Any) {

        if (nameOflocationForAddress.text != "" &&  addressTypeByUser.text!.characters.count >  3 ){
            let nameEnterVal  = nameOflocationForAddress.text!
            let addressName = addressTypeByUser.text!
            
            nameOflocationForAddress.text = ""
            addressTypeByUser.text = ""
            CLGeocoder().geocodeAddressString(addressName, completionHandler: { (placemarks, error) in
                if(placemarks != nil){
                 //   if (placemarks?.count)! > 0 {
                       if placemarks!.count > 0 { 
                      //  let placemark = placemarks?[0]
                        let placemark = placemarks![0]
                        let location = placemark.location
                        let coordinate = location?.coordinate
                        latitudeIsa = coordinate!.latitude
                        longitudeIsa = coordinate!.longitude
                        
                        func insertDataWithAddress(){
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            
                            let user = User(context: context)
                            
                            let formatter = DateFormatter()
                            formatter.dateStyle = .full
                            
                            user.name = nameEnterVal
                            user.address = addressName
                            user.latitude = latitudeIsa
                            user.longitude = longitudeIsa
                            user.date = formatter.string(from: date)
                            
                            appDelegate.saveContext()

                        }
                        insertDataWithAddress()

                        
                    }
                    
                    // create the alert
                    let alert = UIAlertController(title: "Success", message: "Contact Saved", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                    
                else{
                    // create the alert
                    let alert = UIAlertController(title: "Failed", message: "Please Give Correct Address or check internet connection (For saving contact internet is needs). try again later.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameOflocationForAddress.resignFirstResponder()
        addressTypeByUser.resignFirstResponder()
        return (true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTypeByUser.delegate = self
        self.nameOflocationForAddress.delegate = self 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
