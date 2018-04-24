//
//  ReviewViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/23/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var rating: RatingControl!
    @IBOutlet weak var driverPicker: UIPickerView!
    @IBOutlet weak var crafterPicker: UIPickerView!
	
    static let BACKEND_URL = "http:"
    static let CRAFTERS_API_URL = "crafters/"
    static let DRIVERS_API_URL = "drivers/"
    static let REVIEWS_API_URL = "reviews/"
    
    private var drivers = [Driver]()
    private var crafters = [Crafter]()
    
    private var review: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
		
		driverPicker.dataSource = self
		driverPicker.delegate = self
		
		crafterPicker.dataSource = self
		crafterPicker.delegate = self
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
    
    
    @IBAction func sendReview(_ sender: Any) {
		
		//Save indices for the currently selected driver and crafter
		let selectedDriverIndex = driverPicker.selectedRow(inComponent: 0)
		let selectedCrafterIndex = crafterPicker.selectedRow(inComponent: 0)
    }
    
    // MARK: - Private Methods
    
    private func getAvailableCrafters()
    {
		let defaultSession = URLSession (configuration: .default)
		var dataTask: URLSessionDataTask?
		
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.CRAFTERS_API_URL)
		
		let request = URLRequest(url: url! as URL)
		
		dataTask = defaultSession.dataTask(with: request) {
			data, response, error in
			
			if error != nil {
				print (error!.localizedDescription)
			}
			else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
						
						do {
							let craftersDecodedData = try JSONDecoder().decode([Crafter].self, from: data!)
							
							self.crafters = craftersDecodedData
						} catch let jsonError{
							print (jsonError)
						}
					}
				}
			}
			
		}
		dataTask?.resume()
    }
	
	// MARK: - UIPickerView Methods

	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView.tag == 0
		{
			return drivers.count
		}
		else if (pickerView.tag == 1)
		{
			return crafters.count
		}
		else {
			fatalError("Unidentified picker view")
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView.tag == 0
		{
			return ((drivers[row].first_name) + " " + (drivers[row].last_name) )
		}
		else if (pickerView.tag == 1)
		{
			return (crafters[row].name)
		}
		else {
			fatalError("Unidentified picker view")
		}
	}
    
    // MARK: - Internal Structs for data
    private struct Crafter : Decodable
    {
        let id: String
        let name: String
    }
    
    private struct Driver : Codable
    {
        let id: Int
        let first_name: String
        let last_name: String
        let review_count: Int
        let review_avg: Int
        let kindness_prize_count: Int
        let cleanliness_prize_count: Int
        let driving_skills_prize_count: Int
    }
    
    private struct Review : Codable
    {
        let driver_id: Int
        let passenger_id: String
        let crafter_id: String
        let comment: String
        let score: Double
        let kindness_prize: Bool
        let cleanliness_prize: Bool
        let driving_skills_prize: Bool
    }
}
