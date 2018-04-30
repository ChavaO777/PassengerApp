//
//  ReviewViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/23/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    
    @IBOutlet weak var rating: RatingControl!
    @IBOutlet weak var driverPicker: UIPickerView!
    @IBOutlet weak var crafterPicker: UIPickerView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var drivingPrizeButton: UIButton!
    @IBOutlet weak var cleanlinessPrizeButton: UIButton!
    @IBOutlet weak var kindnessPrizeButton: UIButton!
    
    static let BACKEND_URL = "http://192.168.5.228:8000/api/"
    static let CRAFTERS_API_URL = "crafters/"
    static let DRIVERS_API_URL = "drivers/"
    static let REVIEWS_API_URL = "reviews/"
    
    private var crafters = [Crafter]()
    private var drivers = [Driver]()
    
	
    override func viewDidLoad() {
        super.viewDidLoad()

        getAvailableDrivers()
        
        driverPicker.dataSource = self
        driverPicker.delegate = self
        
        getAvailableCrafters()
        
        crafterPicker.dataSource = self
        crafterPicker.delegate = self
        
        commentTextField.layer.borderWidth = 0.5
        commentTextField.layer.borderColor = UIColor.black.cgColor
        commentTextField.layer.cornerRadius = 0.5
        commentTextField.delegate = self
        commentTextField.text = "Deja un comentario (opcional)"
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		
		drivingPrizeButton.setImage (#imageLiteral(resourceName: "driving_Selected"), for: .selected)
		drivingPrizeButton.setImage (#imageLiteral(resourceName: "driving"), for: .normal)
		cleanlinessPrizeButton.setImage (#imageLiteral(resourceName: "cleanliness_selected"), for: .selected)
		cleanlinessPrizeButton.setImage (#imageLiteral(resourceName: "cleanliness"), for: .normal)
		kindnessPrizeButton.setImage (#imageLiteral(resourceName: "kindness_Selected"), for: .selected)
		kindnessPrizeButton.setImage (#imageLiteral(resourceName: "kindness"), for: .normal)
	
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
	
    
    @IBAction func getReviewData(_ sender: Any) {
		
		//Save indices for the currently selected driver and crafter
		let selectedDriverIndex = driverPicker.selectedRow(inComponent: 0)
		let selectedCrafterIndex = crafterPicker.selectedRow(inComponent: 0)
	
        		//Prepare new review object
		let driver_id = drivers[selectedDriverIndex].id
		let passenger_id = "passenger1"
		let crafter_id = crafters[selectedCrafterIndex].id
        let comment = commentTextField.text == "Deja un comentario (opcional)" ? "" : commentTextField.text
		let score = rating.rating
		let kindness_prize = kindnessPrizeButton.isSelected
		let cleanliness_prize = cleanlinessPrizeButton.isSelected
		let driving_skills_prize = drivingPrizeButton.isSelected

		
		let review = Review.init(driver_id: driver_id, passenger_id: passenger_id, crafter_id: crafter_id, comment: comment!, score: score, kindness_prize: kindness_prize, cleanliness_prize: cleanliness_prize, driving_skills_prize: driving_skills_prize)
        
		sendReview(review)
        
		updateDriver(selectedDriverIndex)
		
		closePopup()
	}
		
    // MARK: - Private Methods
	
	//CLOSE POP-UP View
	@IBAction func closePopup()
	{
		removeAnimate()
	}
	
    //Does the  post request to the server where the review is to be saved
    private func sendReview(_ review: Review)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.REVIEWS_API_URL)
        
        var dataTask: URLSessionDataTask?
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url! as URL)
        request.encodeParameters(parameters: ["driver_id": String(review.driver_id), "passenger_id": review.passenger_id,
                                              "crafter_id": review.crafter_id, "comment": review.comment,
                                              "score": String(review.score), "kindness_prize": String(review.kindness_prize),
                                              "cleanliness_prize": String(review.cleanliness_prize), "driving_skills_prize": String(review.driving_skills_prize)])
        
        dataTask = session.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print (error!.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 200{
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        print ("Review sent succesfully")
                    }
                }
                else {
                    print ("Response: " + String(httpResponse.statusCode))
                }
            }
        }
        dataTask?.resume()
    }
    
    private func getAvailableCrafters()
    {
        //Remove everything before
        self.crafters.removeAll()
        
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
                            
							self.crafters += craftersDecodedData
                            self.crafterPicker.reloadAllComponents()
                            print ("\nDECODED CRAFTERS: \(self.crafters.count)\n")

                            
						} catch let jsonError{
							print (jsonError)
						}
					}
				}
                else {
                    print ("Response: " + String(httpResponse.statusCode))
                }
			}
			
		}
		dataTask?.resume()
    }
	
	private func getAvailableDrivers()
	{
        //Remove everything before
        self.drivers.removeAll()
        
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
                            
							self.drivers += decodedData
                            self.driverPicker.reloadAllComponents()
                            print ("\nDECODED DRIVERS: \(self.drivers.count)\n")
						} catch let jsonError{
							print (jsonError)
						}
					}
				}
                else {
                    print ("Response: " + String(httpResponse.statusCode))
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
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
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
                        print ("Driver values updated")
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
	
    //MARK: - UITextView Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Deja un comentario (opcional)"
        {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == ""
        {
            textView.text = "Deja un comentario (opcional)"
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
}
