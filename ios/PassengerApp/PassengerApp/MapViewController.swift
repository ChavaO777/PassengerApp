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
        let zoomLevel = 16.0
        
        let myCamera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: lng,
                                              zoom: Float(zoomLevel))
        
        let mapViewHeight = mapView.frame.height
        let mapViewWidth = mapView.frame.width
        
        let mapViewGoogleMaps = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: mapViewWidth, height: mapViewHeight), camera: myCamera)
        
        mapViewGoogleMaps.mapType = GMSMapViewType.satellite
        
        mapView.camera = myCamera
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = "M"
        marker.snippet = "Mexico"
        marker.map = mapViewGoogleMaps
        
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
