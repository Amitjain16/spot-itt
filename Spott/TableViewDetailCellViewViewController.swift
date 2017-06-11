//
//  TableViewDetailCellViewViewController.swift
//  Spott
//
//  Created by Amit Jain on 3/26/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import CoreData


import GoogleMaps
import GooglePlaces
import Contacts

class TableViewDetailCellViewViewController: UIViewController {
    
    var latitudeToShare: Double = 0.0
    var longitudeToShare: Double = 0.0
    
    @IBOutlet weak var NameOfContact: UILabel!
    
    @IBOutlet weak var detailInfo: UITextView!
    
    @IBOutlet weak var dateContactAdded: UILabel!
    
    @IBAction func shareContact(_ sender: Any) {
        let url = URL(string: "https://maps.google.com/?q=\(latitudeToShare),\(longitudeToShare)")!

        let shareLocation = UIActivityViewController(activityItems: ["Name:",NameOfContact.text!, "Address ",url], applicationActivities: nil)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if shareLocation.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                shareLocation.popoverPresentationController?.sourceView = shareLocation.view
            }
        }
        self.present(shareLocation, animated : true, completion : nil)
        
    }

    
    var nameContact = "Name"
    var dateAdded = "Date"
    var detailInfoContact = "Address"



    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameOfContact.text = nameContact
        dateContactAdded.text = dateAdded

        detailInfo.isUserInteractionEnabled = false
        
        if(detailInfoContact == "Address"){
            let latit = latitudeToShare
            let longi = longitudeToShare
            
            let newLocation = CLLocation(latitude: latit, longitude: longi)
            
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
             
                    if error != nil {

                        
                    }

                 if(placemarks == nil) {
                    

                     self.detailInfo.text =  "Internet connection is required to fetch the address"
                     self.detailInfo.isUserInteractionEnabled = false
                    
                }

                else if(placemarks!.count > 0 &&  placemarks != nil ) {
                    let placemark = placemarks![0]
                    
                    self.detailInfoContact = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false);
        
       
                    self.detailInfo.text =  self.detailInfoContact
                    self.detailInfo.isUserInteractionEnabled = false
                    
                }

            })

        }
        else if((detailInfoContact != "Address")){
     
       
                    self.detailInfo.text =  self.detailInfoContact
                    self.detailInfo.isUserInteractionEnabled = false

        }
        else{
        
            self.detailInfo.text =  "Need internet connection to get the address for this contact as it is saved from the map. But still you can share and navigate this address"
            self.detailInfo.isUserInteractionEnabled = false
        }
      
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
