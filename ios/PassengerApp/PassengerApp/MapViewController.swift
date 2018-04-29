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
    
    let URL = "http://10.50.65.22:8000/api"
    @IBOutlet weak var mapView: GMSMapView!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMap()
        updateCrafterLocations()
    }
    
    @objc func updateCrafterLocations() {

        let LIST_CRAFTERS_URL = URL + "/crafters"
        
        if dataTask != nil {

            dataTask?.cancel()
        }

        let url = NSURL(string: LIST_CRAFTERS_URL)

        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        dataTask = defaultSession.dataTask(with: request as URLRequest){

            data, response, error in
            
            if error != nil {
                
                print(error!.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        do{
                            
                            let craftersDecodedData = try JSONDecoder().decode([Crafter].self, from: data!)
                            
                            print(craftersDecodedData[0].id);
                        } catch let jsonError{
                            
                            print(jsonError)
                        }
                    }
                }
            }
            
        }

        dataTask?.resume()
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
