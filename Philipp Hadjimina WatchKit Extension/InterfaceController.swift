//
//  InterfaceController.swift
//  Philipp Hadjimina WatchKit Extension
//
//  Created by Philipp Hadjimina on 24/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
	
	@IBOutlet var heading: WKInterfaceLabel!
	@IBOutlet var mapView: WKInterfaceMap!
	@IBOutlet var descLabel: WKInterfaceLabel!
	var locationManager: CLLocationManager = CLLocationManager()
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var person:NSString!
	
	var currentLocations:[CLLocation]!
	var currentEvents:[String]!
	var currentYears:[String]!
	var currentHeading:[String]!
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		
		
		mapView.setHidden(true)
		heading.setText("Loading")
		descLabel.setText("Please be patient while your location is being loaded")
		
		if  userAlreadyExist(){
			//let newItems = defaults.objectForKey("toBeWatched")![0]
			//person = newItems.objectForKey("toBeWatched") as! String
			person =  "Martin Luther King"
			setupDataForCorrectPerson()
			
			print(CLLocationManager.locationServicesEnabled())
			
			if CLLocationManager.locationServicesEnabled() {
				switch (CLLocationManager.authorizationStatus()) {
					
				case .NotDetermined, .Restricted, .Denied:
					dummyLocationSetup()
					
				case .AuthorizedAlways, .AuthorizedWhenInUse:
					locationManager.requestAlwaysAuthorization()
					locationManager.desiredAccuracy = kCLLocationAccuracyBest
					locationManager.delegate = self
					locationManager.requestLocation()
				}
			}
			
			print(CLLocationManager.locationServicesEnabled())
			
		}
		else{
			mapView.setHidden(true)
			heading.setText("No tracker found")
			descLabel.setText("Please add someone to your watchlist in the App")
		}
	}
	
	override func willActivate() {
		super.willActivate()
	}
	
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("asdf")
		let currentLocation = locations[0]
		print(currentLocation)
		
		var minDistanceIndex = 0
		if currentLocations.count != 0 {
			
			var minDistance = currentLocation.distanceFromLocation(currentLocations[0])
			
			for i in 1..<currentLocations.count {
				let distance = currentLocation.distanceFromLocation(currentLocations[i])
				if distance < minDistance {
					minDistance = distance
					minDistanceIndex = i
				}
			}
			
			setupViewForIndex(minDistanceIndex)
			
		}
		else{
			self.mapView.setHidden(true)
			self.descLabel.setText("You're currently not watching anyone. Add someone to your watchlist in the App on your phone.")
		}
		
		
		
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		
		print(error.description)
	}
	
	func setupViewForIndex(index : Int)   {
		
		self.descLabel.setText(currentEvents[index])
		self.heading.setText(currentHeading[index])
		let location = currentLocations[index]
		let reg = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.1, 0.1))
		self.mapView.setRegion(reg)
		descLabel.sizeToFitHeight()
		mapView.addAnnotation(location.coordinate, withPinColor: .Red)
		mapView.setHidden(false)
	}
	
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}
	
	
	func dummyLocationSetup()  {
		let dummyIndex = Int(arc4random())
		setupViewForIndex(dummyIndex)
		
	}
	//Data Setup
	func  setupDataForCorrectPerson() {
		var personIndex = 50
		//Setup current location
		if person == "Albert Einstein" {
			personIndex = 0
		}else if person == "Mahatma Gandhi"{
			personIndex = 1
		}else if person == "Martin Luther King"{
			personIndex = 2
		}
		
		if personIndex == 50 {
			print("Error")
		}else{
			currentYears =  getYearsForPersonWithIndex(personIndex)
			currentEvents = getEventsForPersonWithIndex(personIndex)
			currentHeading = getAnnotationDescForPersonWithIndex(personIndex)
			currentLocations = getLocationForPersonWithIndex(personIndex)
		}
	}
	func getLocationForPersonWithIndex(index: Int) -> [CLLocation] {
		
		switch index {
			//        case 0:
			
		case 1:
			return [CLLocation(latitude: 21.6417069, longitude: 69.6292654),
			        CLLocation(latitude: 51.512681, longitude: -0.109903),
			        CLLocation(latitude: -29.61083, longitude: 30.36972),
			        CLLocation(latitude: 0, longitude:0),
			        CLLocation(latitude: -29.8753504, longitude: 31.0045807),
			        CLLocation(latitude: -26.2031134, longitude: 28.0270712),
			        CLLocation(latitude: 31.6206437, longitude: 74.8801088),
			        CLLocation(latitude: 37.5334698, longitude:-121.9984011),
			        CLLocation(latitude: 19.0759837, longitude:72.8776559),//switch 2
				CLLocation(latitude: 21.33111458, longitude:72.62580872),//1
				CLLocation(latitude: 28.7040592, longitude:77.1024902),
				CLLocation(latitude: 18.5523254, longitude:73.9015002),
				CLLocation(latitude: 20.593684, longitude:78.96288),
				CLLocation(latitude: 33.778175, longitude:76.5761714),
				CLLocation(latitude: 33.778175, longitude:76.5761714),
				CLLocation(latitude: 28.7040592, longitude:77.1024902),
				CLLocation(latitude: 28.60177, longitude:77.2143393)]
			
		case 2:
			return [CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 38.664512, longitude: -90.333027),CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 39.849557, longitude: -75.355746),CLLocation(latitude: 42.360082, longitude: -71.058880),CLLocation(latitude: 32.634580, longitude: -87.319511),CLLocation(latitude: 36.016829, longitude: -78.901486),CLLocation(latitude: 36.057757, longitude: -78.905451),CLLocation(latitude: 33.756318, longitude: -84.373451),CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 40.712784, longitude: -74.005941),CLLocation(latitude: 20.593684, longitude: 78.962880),CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 38.907192, longitude: -77.036871),CLLocation(latitude: 31.870242, longitude: -116.638977),CLLocation(latitude: 32.407359, longitude: -87.021101),CLLocation(latitude: 41.878114, longitude: -87.629798),CLLocation(latitude: 38.907191, longitude: -77.036870),CLLocation(latitude: 35.149534, longitude: -90.048980)]
			
		default:
			return []
		}
		
	}
	func getEventsForPersonWithIndex(index: Int) -> [String] {
		
		
		switch index {
			/*case 0:
			*/
		case 1:
			return ["Mohandas Karamchand Gandhi was born in Porbandar in West Bengal, India","After attending Inner Temple Law School in the United Kingdom, Gandhi passes the bar exam and becomes a lawyer. Unknown to him at the time, his mother has passed away while he is at school.","Gandhi is thrown off of a train in South Africa for refusing to move from his First Class seat to Third Class (even though he held a valid First Class ticket). Such discrimination against Indians was common practice and this personal experience gives Gandhi resolve to fight racial discrimination.","Gandhi founds the Natal Indian Congress to oppose a bill denying Indians the right to vote in South Africa. Although the bill passes, Gandhi successfully focuses a broad range of public attention on injustices against Indians even as far away as India and the UK.","Landing in Durban Harbor, South Africa, Gandhi is beaten up by a mob of white settlers. His life is saved when the wife of the Durban Police Chief stands between Gandhi and his attackers. Because of media attention to the event, the colonial government is forced to arrest members of the mob but Gandhi refuses to press charges. Gandhi gains increased public admiration and support. His attackers offer a public apology.","The South African colonial government enacts the “Asian Population Registration Act” where all residents of Asian countries, including India, had to register their name, age, address, job, and other personal information and carry a card with their finger prints. Gandhi develops his principals of non-violent protest “satyagraha” (devotion to the truth or “soul force”).","Gandhi and 2,000 fellow Indians in Johannesburg burn their registration cards in protest. Even as Gandhi and other leaders are repeatedly arrested over 6 years of protest, non-violent rallies continue to grow in size.","The British Government passes the Rowlatt Act which gives authority and power to arrest people and keep them in prisons without any trial if they are suspected with the charge of terrorism. It was also the time of the Jallianwala Bagh massacre where a crowd of nonviolent protesters, was fired upon by British troops. The Bagh-space had only five entrances. British troops fired on the crowd for ten minutes, directing their bullets towards the few open gates through which people were trying to flee 379 were killed and 1200 wounded.","Gandhi gets people to more intently boycott British products and encourages people to start making their own clothes rather than buying British clothing. Similar to Gandhi the All-India Congress held a special session at Calcutta on September 4 and agreed to the non-cooperation campaign for independence.","The British retaliate by passing the Salt Act which makes it illegal for Indians to make their own salt, punishable by at least three years in jail. On March 12th, Gandhi (now 61 years old) travels 320 km (200 miles) on foot for 24 days to Dandi to make his own salt. Others follow. Gandhi is again imprisoned.","Gandhi launches the Quit India campaign declaring India’s independence from British rule. Gandhi is imprisoned.","Still in prison the 73 year old Gandhi starts a hunger strike that lasts for 21 days.","Fearful that Gandhi would die in prison due to failing health and become a martyr, he and other leaders are released.","The United Kingdom Cabinet Mission of 1946 to India is created. Its goal was to discuss and plan the transfer of power from the British government to Indian leadership to provide India with independence.","Tensions between Hindu and Muslim factions resurface and escalate into violence. India is divided into Pakistan and India. The lasting effects of the Indo-Pakistani War of 1947 still affects the geopolitics of this region.","Attempting to promote peace and asking that homes be restored to Muslims, payment to Pakistan be made (per an agreement made before the Indo-Pakistani War of 1947), and fighting cease, Gandhi (now 77 years old) starts another fast. Five days into the fast, India makes payment to Pakistan and Hindu, Muslim and Sikh community leaders agree to renounce violence and call for peace.","Mohandas Karamchand Gandhi is killed by a member of a Hindu organization angered by Gandhi’s peacemaking efforts. Gandhi was shot on his way to evening prayers. His memory and teachings live  on in the non-violent peace movements of today."]
			
		case 2:
			return ["Michael King, later known as Martin Luther King, Jr., is born at 501 Auburn Ave. in Atlanta, Georgia.","King begins his freshman year at Morehouse College in Atlanta.","The Atlanta Constitution publishes King’s letter to the editor stating that black people \"are entitled to the basic rights and opportunities of American citizens.\"","King is ordained and appointed assistant pastor at Ebenezer Baptist Church in Atlanta receives his bachelor of arts degree in sociology from Morehouse College and begins his at Crozer Theological Seminary in Chester, Pennsylvania.","Marries New England Conservatory music student Coretta Scott; they eventually have four children.","King and Coretta Scott are married at the Scott home near Marion, Alabama.","King begins his pastorate at Dexter Avenue Baptist Church in Montgomery, Alabama.","King is awarded his doctorate in systematic theology from Boston University and his first child is born. Rosa Parks is arrested for refusing to vacate her seat and move to the rear of a city bus in Montgomery to make way for a white passenger. Jo Ann Robinson and other Women’s Political Council members mimeograph thousands of leaflets calling for a one-day boycott of the city’s buses on Monday, 5 December. At a mass meeting at Holt Street Baptist Church, the Montgomery Improvement Association(MIA) is formed. King becomes its president.","While King speaks at a mass meeting, his home is bombed. His wife and daughter are not injured. Later King addresses an angry crowd that gathers outside the house, pleading for nonviolence. Montgomery City Lines resumes full service on all routes. King is among the first passengers to ride the buses in an integrated fashion.","King helps found Southern Christian Leadership Conference (SCLC).","Writes Stride Toward Freedom, about the bus boycott. It gets published by Harper & Brothers, whose headquarters are located in","Visits India to study nonviolence and civil disobedience.","Joins his father as co-pastor of Ebenezer Baptist Church in Atlanta.","King is arrested and jailed during anti-segregation protests in Birmingham; writes Letter From Birmingham City Jail, arguing that individuals have the moral duty to disobey unjust laws. Delivers \"I Have a Dream\" speech during the March on Washington attended by 200,000 protesters, creates powerful image, builds momentum for civil rights legislation.","Publishes Why We Can't Wait. Congress passes Civil Rights Act of 1964, outlawing segregation in public accommodations and discrimination in education and employment. King receives Nobel Peace Prize the  in auditorium of the University of Oslo.","King and SCLC join voting-rights march from Selma to Montgomery; police beat and tear gas marchers; King addresses rally before state capitol, builds support for voting rights. Congress passes Voting Rights Act of 1965, which suspends literacy tests and other restrictions to prevent blacks from voting.","Growing popularity of the black power movement, blacks stressing self-reliance and self-defense, indicates King's influence was declining, especially among young blacks. King turns toward economic issues; SCLC moves civil rights struggle to the North; opens Chicago office to organize protests against housing and employment discrimination.","King plans Poor People's Campaign which later took place in Washington DC advocates redistribution of wealth to eradicate black poverty. Publishes Where Do We Go from Here: Chaos or Community?","King is assassinated in Memphis, during visit to support striking black garbage collectors; violent riots erupt in more than 100 U.S. cities."]
			
		default:
			return []
		}
		
	}
	
	func getYearsForPersonWithIndex(index: Int) -> [String]{
		
		switch index {
			/*case 0:
			*/
		case 1:
			return ["1869","1891","1893","1894","1897","1906","1908","1919","1920","1930","1942","1943","1944","1946","1947","1948","1948"]
			
		case 2:
			return ["1929","1944","1946","1948","1951","1953","1954","1955","1956","1957","1958","1959","1960","1963","1964","1965","1966","1967","1968"]
			
		default:
			return []
		}
	}
	
	func getAnnotationDescForPersonWithIndex(index: Int) -> [String] {
		switch index {
		case 1:
			return ["Gandhis Brithplace","Graduation from Inner Temple Law School","Thrown off of train due to discrimination","Natal Indian Congress is founded","Attack by angry mob","Mass meetings outside the Hamidia Mosque","Burning of registration cards as protest","Jallianwala Bagh massacre","Boycott of british goods","Gandhi arrested for producing salt","Gandhis Quit India speech","Beginning 21 day hunger strike in Delhi","Release of prisoners","First steps to Indian Indepen independence","War over Kashmir and Jammu","Start of another hunger strike (probably in Delhi) in order to achieve peace","Assassination at Birla House (now Gandhi Smriti)"]
		case 2:
			return ["Martin Luther King is born","Beginning of Studies at Morehouse","Publication of Kings letter","Becomes Pastor and receivs bechelors degree","Beginning of Studies in Boston","Marriage","Beginning of Pastorate","Becomes President of the MIA","Bombing of Kings home","Foundation of SCLC","Stride Toward Freedom","Visit to India","Co-pastor in Ebenzer","March on Washington","Receives Nobel Peace Prize","Voting-rights march","Opens chicago office","Planing of Poor People's Campaign","Assassination"]
		default:
			return []
		}
	}
	
	override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
		print("YOY")
	}
	
	func userAlreadyExist() -> Bool {
		/* if (defaults.stringForKey("toBeWatched") != nil) {
		return true
		}
		return false*/
		return true
	}
	
	
}
