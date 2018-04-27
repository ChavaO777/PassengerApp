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
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var drivingPrizeButton: UIButton!
    @IBOutlet weak var cleanlinessPrizeButton: UIButton!
    @IBOutlet weak var kindnessPrizeButton: UIButton!
    
    static let BACKEND_URL = "http:"
    static let CRAFTERS_API_URL = "crafters/"
    static let DRIVERS_API_URL = "drivers/"
    static let REVIEWS_API_URL = "reviews/"
    
    private var drivers = [Driver]()
    private var crafters = [Crafter]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		
		getAvailableDrivers()
		getAvailableCrafters()
		
		driverPicker.dataSource = self
		driverPicker.delegate = self
		
		crafterPicker.dataSource = self
		crafterPicker.delegate = self
		
		drivingPrizeButton.setImage (UIImage.init(named: "driving_Selected"), for: .selected)
		drivingPrizeButton.setImage (UIImage.init(named: "driving"), for: .normal)
		cleanlinessPrizeButton.setImage (UIImage.init(named: "cleanliness_Selected"), for: .selected)
		cleanlinessPrizeButton.setImage (UIImage.init(named: "cleanliness"), for: .normal)
		kindnessPrizeButton.setImage (UIImage.init(named: "kindess_Selected"), for: .selected)
		kindnessPrizeButton.setImage (UIImage.init(named: "kindness"), for: .normal)
	
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
    @IBAction func onPrizeButtonTouch(_ sender: UIButton) {
		
		sender.isSelected = !sender.isSelected
    }
	
    
    @IBAction func sendReview(_ sender: Any) {
		
		//Save indices for the currently selected driver and crafter
		let selectedDriverIndex = driverPicker.selectedRow(inComponent: 0)
		let selectedCrafterIndex = crafterPicker.selectedRow(inComponent: 0)
	
		//Prepare new review object
		let driver_id = drivers[selectedDriverIndex].id
		let passenger_id = "passenger1"
		let crafter_id = crafters[selectedCrafterIndex].id
		let comment = commentTextField.text
		let score = rating.rating
		let kindness_prize = kindnessPrizeButton.isSelected
		let cleanliness_prize = cleanlinessPrizeButton.isSelected
		let driving_skills_prize = drivingPrizeButton.isSelected

		
		let review = Review.init(driver_id: driver_id, passenger_id: passenger_id, crafter_id: crafter_id, comment: comment!, score: score, kindness_prize: kindness_prize, cleanliness_prize: cleanliness_prize, driving_skills_prize: driving_skills_prize)
		
		//Send object to database
		let defaultSession = URLSession (configuration: .default)
		var dataTask: URLSessionDataTask?
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.REVIEWS_API_URL)
		
		var request = URLRequest(url: url! as URL)
		request.httpMethod = "POST"
		
		do {
			request.httpBody = try JSONEncoder().encode(review)
		} catch let jsonError{
			fatalError(String(describing: jsonError))
		}
		
		dataTask = defaultSession.dataTask(with: request) {
			data, response, error in
			
			if error != nil {
				print (error!.localizedDescription)
			}
			else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
					}
				}
			}
		}
		dataTask?.resume()
		
		updateDriver(selectedDriverIndex)
		
		closePopup()
	}
		
	
    
    // MARK: - Private Methods
	
	//CLOSE OP-UP View
	@IBAction func closePopup()
	{
		removeAnimate()
	}
	
    private func getAvailableCrafters()
    {
		let defaultSession = URLSession (configuration: .default)
		var dataTask: URLSessionDataTask?
		
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.CRAFTERS_API_URL)
		
		var request = URLRequest(url: url! as URL)
		request.httpMethod = "GET"
		
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
	
	private func getAvailableDrivers()
	{
		let defaultSession = URLSession (configuration: .default)
		var dataTask: URLSessionDataTask?
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.DRIVERS_API_URL)
		
		var request = URLRequest(url: url! as URL)
		request.httpMethod = "GET"
		
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
							let decodedData = try JSONDecoder().decode([Driver].self, from: data!)
							
							self.drivers = decodedData
						} catch let jsonError{
							print (jsonError)
						}
					}
				}
			}
		}
		dataTask?.resume()
	}
	
	func updateDriver(_ selectedDriverIndex: Int)
	{
		let defaultSession = URLSession (configuration: .default)
		var dataTask: URLSessionDataTask?
		
		//Update driver in database
		
		let id = drivers[selectedDriverIndex].id
		let first_name = drivers[selectedDriverIndex].first_name
		let last_name = drivers[selectedDriverIndex].last_name
		let review_count = drivers[selectedDriverIndex].review_count + 1
		let review_average = ((drivers[selectedDriverIndex].review_avg * Double(review_count - 1)) + rating.rating) / Double(review_count)
		let kindness_prize_count = drivers[selectedDriverIndex].kindness_prize_count + (kindnessPrizeButton.isSelected ? 1 : 0)
		let cleanliess_prize_count = drivers[selectedDriverIndex].cleanliness_prize_count + (cleanlinessPrizeButton.isSelected ? 1 : 0)
		let driving_skills_prize_count = drivers[selectedDriverIndex].driving_skills_prize_count + (drivingPrizeButton.isSelected ? 1 : 0)
		
		
		let driver = Driver.init(id: id, first_name: first_name, last_name: last_name, review_count: review_count, review_avg: review_average, kindness_prize_count: kindness_prize_count, cleanliness_prize_count: cleanliess_prize_count, driving_skills_prize_count: driving_skills_prize_count)
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.DRIVERS_API_URL + String(id))
		
		var request = URLRequest(url: url! as URL)
		request.httpMethod = "PUT"
		
		do {
			request.httpBody = try JSONEncoder().encode(driver)
		} catch let jsonError{
			fatalError(String(describing: jsonError))
		}
		
		dataTask = defaultSession.dataTask(with: request) {
			data, response, error in
			
			if error != nil {
				print (error!.localizedDescription)
			}
			else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
					}
				}
			}
		}
		dataTask?.resume()
		
	}
	
	//Pop up aimation
	func showAnimate()
	{
		self.view.transform = self.view.transform.scaledBy(x: 1.3, y: 1.3)
		self.view.alpha = 0.0
		UIView.animate(withDuration: 0.3, animations: {
			self.view.alpha = 1.0
			self.view.transform = self.view.transform.scaledBy(x: 1.0, y: 1.0)
		})
	}
	
	//Animate out and close popup
	func removeAnimate()
	{
		UIView.animate(withDuration: 0.25, animations: {
			self.view.alpha = 0.0
			self.view.transform = self.view.transform.scaledBy(x: 1.3, y: 1.3)
		}, completion: {(finished : Bool) in
			if (finished)
			{
				self.view.removeFromSuperview()
			}
		})
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
        let review_avg: Double
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
