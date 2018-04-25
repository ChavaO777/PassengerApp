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

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This call to bringSubview() was key!
        self.view.bringSubview(toFront: self.mapView)

        //VWM Fin coords
        let lat = 19.1190942
        let lng = -98.2535574
        let zoomLevel = 17.0
        
        let myCamera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: lng,
                                              zoom: Float(zoomLevel))
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
