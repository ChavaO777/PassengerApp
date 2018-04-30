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
    
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Create the map once
        createMap()
        
        //Get the stations' locations once
        //The httpBody is nil because there is no body to send to this request
        HTTPHandler.makeHTTPRequest(route: Station.ROUTE, httpMethod: "GET", httpBody: nil, callbackFunction: self.placeStationsOnMap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(false)
        
        //Update the crafters' locations every time the view appears
        //The httpBody is nil because there is no body to send to this request
        HTTPHandler.makeHTTPRequest(route: Crafter.ROUTE, httpMethod: "GET", httpBody: nil, callbackFunction: self.placeCraftersOnMap)
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
                
                //If the crafter is not active, then skip it, i.e. don't place it on the map
                if !crafter.isActive {
                    
                    continue
                }
                
                //Create a marker
                let marker = GMSMarker()
                
                //Add the marker's coordinates
                marker.position = CLLocationCoordinate2DMake(Double(crafter.lat), Double(crafter.lng))
                
                marker.title = String(crafter.name)
                marker.snippet = crafter.getMarkerSnippet()
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
                
                //Set the marker's custom image
                marker.icon = UIImage(named: crafter.ICON_NAME_STRING)
                
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
                marker.snippet = station.getMarkerSnippet()
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
                
                //Set the marker's custom image
                marker.icon = UIImage(named: station.ICON_NAME_STRING)
                
                //Set the marker's view
                marker.map = self.mapView
            }
            
        } catch let jsonError{
            
            print(jsonError)
        }
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
