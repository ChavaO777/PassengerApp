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
    
    let URL = "10.50.65.22:8000/api"
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMap()
        updateCrafterLocations()
    }
    
    private func updateCrafterLocations() {
        
        //creating a NSURL
        let LIST_CRAFTERS_ROUTE = URL + "/crafters"
        
//        if dataTask != nil {
//            
//            dataTask?.cancel()
//        }
    }
    
    /**
     *  Function to create the Google Maps map
     */
    private func createMap() {
        
        //This call to bringSubview() was key!
        self.view.bringSubview(toFront: self.mapView)
        
        //VWM Fin coords
        let lat = 19.1190942
        let lng = -98.2535574
        let zoomLevel = 17.0
        
        let myCamera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: Float(zoomLevel))
        
        //Get the dimensions of the map's view
        let mapViewHeight = mapView.frame.height
        let mapViewWidth = mapView.frame.width
        
        //Create an instance of a map
        let mapViewGoogleMaps = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: mapViewWidth, height: mapViewHeight), camera: myCamera)
        
        //Set the map type
        mapViewGoogleMaps.mapType = GMSMapViewType.satellite
        
        //Set the camera
        mapView.camera = myCamera
        
        //Set the map to its corresponding view
        self.mapView = mapViewGoogleMaps
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
