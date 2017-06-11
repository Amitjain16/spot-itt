//
//  ContactViewController.swift
//  Spott
//
//  Created by Amit Jain on 3/26/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import CoreData
import MapKit
import AddressBookUI
import GoogleMaps
import GooglePlaces
import Contacts

var listName: [User] = []
var filteredList: [User] = []

@available(iOS 10.0, *)
class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentSearch(searchText: searchController.searchBar.text!)
    }
    
    var listSorted:[String] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredList.count
        }

        return listName.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //   let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
            if searchController.isActive && searchController.searchBar.text != "" {
                cell.name.text = filteredList[indexPath.row].name
            }
            else{
                let list = listName[indexPath.row]
                
                cell.name.text = list.name!
               // cell.name.text = listName[indexPath.row].name
                cell.goButton.tag = indexPath.row
                cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
             //    cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
              //  let goImageApply = UIImage(named: "GImage.png")
              //  let goImageView = UIImageView(image: goImageApply)
              //  cell.accessoryView = goImageView
                
             //   cell.tintColor = UIColor.clear
            }
          return (cell)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let listNameAre = listName[indexPath.row]
            context.delete(listNameAre)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //   fetchData()
            
            do{
                listName = try context.fetch(User.fetchRequest())
            }
            catch{
                // create the alert
                let alert = UIAlertController(title: "Failed", message: "Failed to delete Contact close and open app again", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
            
            //  listName.remove(at: indexPath.row)
            tableView.reloadData()
            
            
        }
        
    }
    
    
    func fetchData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        do{
            listName = try context.fetch(User.fetchRequest())
            
         //     let sortedarray = listName.sorted(by: { $0.name! < $1.name! })

            
        }
        catch{
            // create the alert
            let alert = UIAlertController(title: "Failed", message: "Failed to Load Contacts close and open app again", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func filterContentSearch(searchText: String, scope: String = "All"){
        
        //    filteredList = listName.filter{user in return user.name(searchText.lowercased().contains(searchText.lowercased()))
        filteredList = listName.filter {
            user in return (user.name?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
 /*   override func viewDidAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // Do any additional setup after loading the view.
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        let listNameAre = listName[indexPath.row]
        let latitudeIs = listNameAre.latitude
        let longitudeIs = listNameAre.longitude
        let locationName = listNameAre.name
        let latitude: CLLocationDegrees = latitudeIs
        
        let longitude: CLLocationDegrees = longitudeIs
        let newLocation = CLLocation(latitude: latitude, longitude: longitude)
        let coordinates:  CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
            
            if placemarks!.count > 0 {
            /*    let placemark = placemarks![0]

                var addressName: String = ""
                 // Location name
                if let locationName = placemark.addressDictionary?["Name"] as? String {
                    addressName += locationName + ", "
                }
                
           /*     // Street address  name is already having street name
                if let street = placemark.addressDictionary?["Thoroughfare"] as? String {
                    addressName += street + ", "
                }
            */
                
                // City
                if let city = placemark.addressDictionary?["City"] as? String {
                    addressName += city + ", "
                }
                // City
                if let state = placemark.addressDictionary?["State"] as? String {
                    addressName += state + ", "
                }
                
                // Zip code
                if let zip = placemark.addressDictionary?["ZIP"] as? String {
                    addressName += zip + ", "
                }
                
                // Country
                if let country = placemark.addressDictionary?["Country"] as? String {
                    addressName += country
                }

                */
                let pin = MKPointAnnotation()
                
                pin.coordinate.latitude = coordinates.latitude
                pin.coordinate.longitude = coordinates.longitude
                
                let lat = coordinates.latitude
                let lon = coordinates.longitude

                
                let place = MKPlacemark(coordinate: coordinates)

                let mapItem = MKMapItem(placemark: place)
                mapItem.name = locationName
                
                /// Launch in apple map HERE
            //    mapItem.openInMaps(launchOptions: nil)
          
                // launch in google map
           
                let url = URL(string: "https://maps.google.com/?q=\(lat),\(lon)")!

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                
            }
        })
        
    }
    
    // create segue to show deatils of selected row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailOfContact", sender: listName[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailOfContact" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let listDetail : User
                if searchController.isActive && searchController.searchBar.text != "" {
                    
                    listDetail = filteredList[indexPath.row]
                }else{
                    listDetail  = listName[indexPath.row]
                }
                
                let contactDetail = segue.destination as! TableViewDetailCellViewViewController
                
                if(listDetail.name != nil){
              //      contactDetail.detailInfoContact = listDetail.address!
                    contactDetail.latitudeToShare = listDetail.latitude
                    contactDetail.longitudeToShare = listDetail.longitude
                    contactDetail.nameContact = listDetail.name!
                    if (listDetail.date != nil){
                    contactDetail.dateAdded = listDetail.date!
                    }
                    if(listDetail.address != nil){
                         contactDetail.detailInfoContact = listDetail.address!
                    }

                }
                else{
                    contactDetail.detailInfoContact = ""
                }
            }
            
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
