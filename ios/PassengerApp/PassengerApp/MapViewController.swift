//
//  MapViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    let URL = "http://localhost:8000/api"
    
    var mapView:GMSMapView?
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create the map once
        createMap()
        
        print("A07104218")
        //Get the stations' locations once
        getElementsFromApi(route: "/stations", httpMethod: "GET", callbackFunction: self.placeStationsOnMap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(false)
        
        //Update the crafter' locations every time the view appears
        getElementsFromApi(route: "/crafters", httpMethod: "GET", callbackFunction: self.placeCraftersOnMap)
    }
    
    /**
     *  Function that makes an HTTP request to the backend server and
     *  gets a list of the given entities
     *
     *  @param route the route to be used in the HTTP request
     *  @param httpMethod the HTTP method to be used in the request
     *  @param callbackFunction the function to be called within this function
     */
    @objc func getElementsFromApi(route: String, httpMethod: String, callbackFunction: @escaping (_ data: Data?) -> Void) {

        let ROUTE_URL = URL + route
        
        if dataTask != nil {

            dataTask?.cancel()
        }

        let url = NSURL(string: ROUTE_URL)

        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod

        dataTask = defaultSession.dataTask(with: request as URLRequest){

            data, response, error in
            
            if error != nil {
                
                print(error!.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                
                //If the request was successful
                if httpResponse.statusCode == 200 {
                    
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        //Call the call-back function with the data received from the request
                        callbackFunction(data)
                    }
                }
            }
        }

        dataTask?.resume()
    }
    
    /**
     *  Function that places markers on the map representing the
     *  crafters in their current locations.
     *
     *  @param data the data returned from an HTTP request
     */
    func placeCraftersOnMap(data: Data?) {
        
        do{
            //Parse the data into an array of Crafter structs
            let craftersArray = try JSONDecoder().decode([Crafter].self, from: data!)
            
            //Iterate on the Crafter struct array
            for crafter in craftersArray {
                
                //Create a marker
                let marker = GMSMarker()
                
                //Add the marker's coordinates
                marker.position = CLLocationCoordinate2DMake(Double(crafter.lat), Double(crafter.lng))
                
                marker.title = String(crafter.name)
                marker.snippet = String(crafter.id)
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
                
                //Set the marker's custom image
                marker.icon = UIImage(named: "icon_crafter.png")
                
                //Set the marker's view
                marker.map = self.mapView
            }
            
        } catch let jsonError{
            
            print(jsonError)
        }
    }
    
    /**
     *  Function that places markers on the map representing the
     *  stations.
     *
     *  @param data the data returned from an HTTP request
     */
    func placeStationsOnMap(data: Data?) {
        
        do{
            //Parse the data into an array of Station structs
            let stationsArray = try JSONDecoder().decode([Station].self, from: data!)
            
            //Iterate on the Station struct array
            for station in stationsArray {
                
                //Create a marker
                let marker = GMSMarker()
                
                //Add the marker's coordinates
                marker.position = CLLocationCoordinate2DMake(Double(station.lat), Double(station.lng))
                
                marker.title = String(station.name)
                marker.snippet = getStationMarkerSnippet(station: station)
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
                
                //Set the marker's custom image
                marker.icon = UIImage(named: "icon_station.png")
                
                //Set the marker's view
                marker.map = self.mapView
            }
            
        } catch let jsonError{
            
            print(jsonError)
        }
    }
    
    /**
     *  Function to create a snippet for the stations' markers
     *
     *  @param station a station struct whose marker snippet is to be created
     *  @returns markerSnippet a string corresponding to the station's marker's snippet
     */
    func getStationMarkerSnippet(station: Station) -> String {
        
        let markerSnippet = "Personas esperando una crafter: " + String(station.waiting_people) + "\nSiguiente crafter en: " + String(station.next_crafter_arrival_time) + " min."
        return markerSnippet
    }
    
    /**
     *  Function to create the Google Maps map
     */
    private func createMap(){
        
        //This call to bringSubview() was key!
        
        //VWM Fin coords
        let lat = 19.1190942
        let lng = -98.2535574
        let zoomLevel = 15.0
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let myCamera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: Float(zoomLevel))
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.9), camera: myCamera)
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        mapView?.center = self.view.center
        
        self.view.addSubview(mapView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create a popup from a view
    private func createReviewPopup()
    {
        //Create popup for new trip data
        let reviewVC = UIStoryboard (name: "Main" /*same story board, different view/scene */, bundle: nil).instantiateViewController(withIdentifier: "ReviewView") as! ReviewViewController
        
        self.addChildViewController(reviewVC)
        reviewVC.view.frame = self.view.frame
        self.view.addSubview(reviewVC.view)
        reviewVC.didMove(toParentViewController: self)
    }
}
