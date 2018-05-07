//
//  MapViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    //VWM Fin coords
    let vwmLat = 19.1190942
    let vwmLng = -98.2535574
    let defaultUserLat = 19.120636
    let defaultUserLng = -98.254361
    let zoomLevel = 15.0
    var mapView:GMSMapView?
    
    //To get the user's current location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    //A default location in vwm
//    let defaultLocation = CLLocation(latitude: defaultUserLat, longitude: defaultUserLng)
    
    var stationsArray = [Station]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Create the map once
        createMap()
        
        //Get the stations' locations once
        //The httpBody is nil because there is no body to send to this request
        HTTPHandler.makeHTTPGetRequest(route: Station.ROUTE, httpBody: nil, callbackFunction: self.placeStationsOnMap)
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(false)
        
        //Update the crafters' locations every time the view appears
        //The httpBody is nil because there is no body to send to this request
        HTTPHandler.makeHTTPGetRequest(route: Crafter.ROUTE, httpBody: nil, callbackFunction: self.placeCraftersOnMap)
        
        drawCircuit()
    }
    
    /**
     *  Function that draws the circuit the crafters follow, using GMS polygon and
     *  the position of the stations
     */
    func drawCircuit()
    {
        print ("Drawing ciruit...")
        
        let path = GMSMutablePath()
        
        //Draw circuit
        for station in stationsArray
        {
            path.add(CLLocationCoordinate2D(latitude: station.getLat(), longitude: station.getLng()))
            print("Drawing point at (lat:\(station.getLat()), \(station.getLng()))")
        }
        
        //Close circuit
        let station = stationsArray[0]
        path.add(CLLocationCoordinate2D(latitude: station.getLat(), longitude: station.getLng()))

        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .yellow
        polyline.strokeWidth = 5.0
        polyline.map = mapView
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
                if !crafter.getIsActive() {
                    
                    continue
                }
                
                //Create a marker
                let marker = GMSMarker()
                
                //Add the marker's coordinates
                marker.position = CLLocationCoordinate2DMake(Double(crafter.getLat()), Double(crafter.getLng()))
                
                marker.title = String(crafter.getName())
                marker.snippet = crafter.getMarkerSnippet(total_seats: crafter.getTotalSeats(), occupied_seats: crafter.getOccupiedSeats())
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
            stationsArray += try JSONDecoder().decode([Station].self, from: data!)
            
            //Iterate on the Station struct array
            for station in stationsArray {
                
                //Create a marker
                let marker = GMSMarker()
                
                //Add the marker's coordinates
                marker.position = CLLocationCoordinate2DMake(Double(station.getLat()), Double(station.getLng()))
                
                marker.title = String(station.getName())
                marker.snippet = station.getMarkerSnippet(waiting_people: station.getWaitingPeople(), next_crafter_arrival_time: station.getNextCrafterArrivalTime())
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
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let myCamera = GMSCameraPosition.camera(withLatitude: vwmLat, longitude: vwmLng, zoom: Float(zoomLevel))
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.9), camera: myCamera)
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        mapView?.center = self.view.center
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true
        
        self.view.addSubview(mapView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
