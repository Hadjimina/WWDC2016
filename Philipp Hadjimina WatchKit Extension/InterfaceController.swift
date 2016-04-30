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
import WatchConnectivity

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
	
	@IBOutlet var heading: WKInterfaceLabel!
	@IBOutlet var mapView: WKInterfaceMap!
	@IBOutlet var descLabel: WKInterfaceLabel!
	var locationManager: CLLocationManager = CLLocationManager()
	let defaults = NSUserDefaults.standardUserDefaults()
    var noneFound = false
	var person:NSString!
    var dummy:NSString!
    var currentLocations:[CLLocation]!
	var currentEvents:[String]!
	var currentYears:[String]!
	var currentHeading:[String]!
    
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
        
		}
	
	override func willActivate() {
		super.willActivate()
        entireSetup()
	}
	
    func entireSetup()  {
        
        if initialExist() && userAlreadyExist(){
            print(NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched")![0]["toBeWatched"])
            person = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched")![0]["toBeWatched"] as? String
            print(person)
        }
        else{
            person = "NoOne"
           // defaults.setObject(["toBeWatched":"NoOne","dummy":"false"], forKey: "toBeWatched")
        }
        
        if initialExist()&&dummyAlreadyExist(){
            dummy = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched")![0]["dummy"] as? String
        }else{
            dummy = "false"
        }
        
        if  person == "NoOne" {
            mapView.setHidden(true)
            heading.setText("No tracker found")
            descLabel.setText("Please add someone to your watchlist in the App")
            
        }else{
            setupDataForCorrectPerson()
            
            if dummy == "true" {
                dummyLocationSetup()
            }else{
                mapView.setHidden(true)
                heading.setText("Loading")
                descLabel.setText("Your current location is being loaded")
                locationManager.requestAlwaysAuthorization()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestLocation()
            }
        }

    }
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        dummyLocationSetup()
	}
	
	func setupViewForIndex(index : Int)   {
		
		self.descLabel.setText(currentEvents[index])
		self.heading.setText(currentHeading[index])
		let location = currentLocations[index]
		let reg = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.1, 0.1))
		self.mapView.setRegion(reg)
		descLabel.sizeToFitHeight()
        
        if person == "Martin Luther King" {
           mapView.addAnnotation(location.coordinate, withPinColor: .Green)
        }else if person == "Mahatma Gandhi"{
            self.mapView.addAnnotation(location.coordinate, withPinColor: .Purple)
        }else{
            self.mapView.addAnnotation(location.coordinate, withPinColor: .Red)
        }
		
		mapView.setHidden(false)
	}
	
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}
	
	
	func dummyLocationSetup()  {
        if currentLocations?.count > 0 {
            let dummyIndex = Int(arc4random_uniform(UInt32(currentLocations.count)))
            setupViewForIndex(dummyIndex)

        } else {
            print("No objects")
        }
        
            
        
		
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
            mapView.setHidden(true)
            heading.setText("No tracker found")
            descLabel.setText("Please add someone to your watchlist in the App")

		}else{
			currentYears =  getYearsForPersonWithIndex(personIndex)
			currentEvents = getEventsForPersonWithIndex(personIndex)
			currentHeading = getAnnotationDescForPersonWithIndex(personIndex)
			currentLocations = getLocationForPersonWithIndex(personIndex)
		}
	}
    //Data Setup
    func getLocationForPersonWithIndex(index: Int) -> [CLLocation] {
        
        switch index {
        case 0:
            return [CLLocation(latitude: 48.401082, longitude: 9.987608),CLLocation(latitude: 51.227741, longitude: 6.773456),CLLocation(latitude: 45.465422, longitude: 9.185924),CLLocation(latitude: 47.390434, longitude: 8.045701),CLLocation(latitude: 47.376536, longitude: 8.548093),CLLocation(latitude: 51.165691, longitude: 10.451526),CLLocation(latitude: 47.376278, longitude: 8.547374),CLLocation(latitude: 47.498820, longitude: 8.723689),CLLocation(latitude: 46.966327, longitude: 7.455565),CLLocation(latitude: 46.947248, longitude: 7.451586),CLLocation(latitude: 46.947974, longitude: 7.447447),CLLocation(latitude: 47.358830, longitude: 8.559589),CLLocation(latitude: 46.950408, longitude: 7.438146),CLLocation(latitude: 50.075538, longitude: 14.437800),CLLocation(latitude: 47.369779, longitude: 8.557668),CLLocation(latitude: 49.412635, longitude: 8.675332),CLLocation(latitude: 52.349894, longitude: 13.014204),CLLocation(latitude: 51.165025, longitude: 10.452901),CLLocation(latitude: 59.329323, longitude: 18.068581),CLLocation(latitude: 40.006054, longitude: -101.436768),CLLocation(latitude: 40.343121, longitude: -74.666744),CLLocation(latitude: 38.897676, longitude: -77.036530),CLLocation(latitude: 40.357298, longitude: -74.667223),CLLocation(latitude: 40.339819, longitude: -74.624008)]
            
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
                CLLocation(latitude: 52.3555, longitude:1.1743),
                CLLocation(latitude: 33.778175, longitude:76.5761714),
                CLLocation(latitude: 28.7040592, longitude:77.1024902),
                CLLocation(latitude: 28.60177, longitude:77.2143393)]
            
        case 2:
            return [CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 38.664512, longitude: -90.333027),CLLocation(latitude: 33.9462125, longitude: -84.3346473),CLLocation(latitude: 39.849557, longitude: -75.355746),CLLocation(latitude: 42.360082, longitude: -71.058880),CLLocation(latitude: 32.634580, longitude: -87.319511),CLLocation(latitude: 36.016829, longitude: -78.901486),CLLocation(latitude: 36.057757, longitude: -78.905451),CLLocation(latitude: 33.756318, longitude: -84.373451),CLLocation(latitude: 33.7556795, longitude: -84.3771254),CLLocation(latitude: 40.712784, longitude: -74.005941),CLLocation(latitude: 20.593684, longitude: 79.1),CLLocation(latitude: 33.7563179, longitude: -84.3734515),CLLocation(latitude: 38.907192, longitude: -77.036871),CLLocation(latitude: 31.870242, longitude: -116.638977),CLLocation(latitude: 32.407359, longitude: -87.021101),CLLocation(latitude: 41.878114, longitude: -87.629798),CLLocation(latitude: 38.907191, longitude: -77.036870),CLLocation(latitude: 35.149534, longitude: -90.048980)]
            
        default:
            return []
        }
        
    }
    func getEventsForPersonWithIndex(index: Int) -> [String] {
        
        
        switch index {
        case 0:
            return ["Albert Einstein is born in Ulm, Germany, the son of Hermann Einstein, a German-Jewish featherbed salesman, and his wife Pauline.","Einstein enrolls in the second grade of a Catholic elementary school called the Petersschule. He receives Jewish religious instruction at home and also begins taking violin lessons.","Struggling financially, the Einstein family moves from Germany to Italy in search of better work. Albert, aged fifteen, stays behind in Munich to finish his schooling, but soon either quits or is kicked out of his high school and follows his parents to Italy.","Albert Einstein attempts to get out of his last year of high school by taking an entrance exam to ETH, the Swiss Polytechnic University in Zurich. He fails the test, forcing him to attend one final year of high school in the small town of Aarau, Switzerland, instead.","Albert Einstein graduates from high school and begins attending ETH, the prestigious Swiss Polytechnic University in Zurich.","At the age of 17, Albert Einstein renounces his German citizenship to avoid mandatory military service in the German army. For the next four years, he will not be a legal citizen of any nation.","Albert Einstein graduates from ETH with a degree in physics. He tries to find a teaching job, but is unable to obtain work.","Albert Einstein obtains Swiss citizenship and works as a temporary teacher at the Technical College in Winterthur, Switzerland.","Milena Maric gives birth to Leiserl Einstein, Albert's first child. The unwed couple, unable to care for the girl and perhaps ashamed of her illegitimate status, put her up for adoption. Unable to find any work as a teacher or academic, Albert Einstein takes a job as a clerk at the Swiss Patent Office.","Albert Einstein marries his longtime girlfriend, Milena Maric in Bern.","A year after marrying Albert, his wife Milena gives birth to the Einsteins' first son, Hans Albert.","Einstein completes his paper on quantum theory and his paper on Brownian motion is accepted by the Annalen der Physik. His paper on the special theory of relativity is also published in the Annalen der Physik.","Einstein becomes a privatdozentat Bern University.","The Einsteins move to Prague, where Albert assumes his first full professorship after many years working at the Swiss Patent Office or teaching in part-time positions in Switzerland.","After just a year in Prague, the Einsteins move back to Switzerland, to where Albert takes professorship at his alma mater, the Swiss Federal Institute of Technology in Zurich.","Albert Einstein moves from Zurich to Berlin to become the director of the prestigious Kaiser Wilhelm Institute. His marriage to Milena begins to unravel, and his wife and children decide to stay behind in Zurich. They will never live together as a family again.","Einstein completes his General Theory of Relativity.","After several years of estrangement, Albert divorces his first wife Milena Maric and immediately remarries. Einstein's second wife, Elsa Lowenthal, is a cousin with whom he fell in love when she nursed him back to health following a serious illness in 1917. At the close of World War I, Albert Einstein regains his German citizenship in a gesture of solidarity with liberal new government of the Weimar Republic. On May 29th a solar eclipse provides dramatic observable evidence that Einstein's General Theory of Relativity is correct. Einstein suddenly becomes a worldwide celebrity.","Albert Einstein wins the Nobel Prize in Physics for his work on the photoelectric effect, first published in 1905. Being to remote he could however not attend the ceremony.","Albert Einstein and his family, fearing anti-Semitic persecution, flee from Nazi Germany to resettle in the United States. Einstein takes a post at Institute of Advanced Study at Princeton, where he will remain until his death in 1955.","Albert Einstein's second wife Elsa dies of sudden illness.","Fearing that Nazi scientists might win the race to develop the world's first atomic bombs, Albert Einstein writes a letter to President Franklin D. Roosevelt, urging him to launch an American program of nuclear research.","For the third time in his life, Albert Einstein changes his nationality, becoming a United States citizen while also retaining his Swiss citizenship.","Albert Einstein dies of heart failure at the age of 76."]
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
        case 0:
            return ["1879","1884","1894","1895","1896","1896","1900","1901","1902","1903","1904","1905","1908","1911","1912","1914","1915","1919","1921","1933","1936","1939","1940","1955"]
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
        case 0:
            return ["Albert Einstein is born","Petersschule","Move to Italy","Boarding School in Aarau","Einstein at ETH","Einstein Renounces German Citizenship","College Graduation","Swiss Citizenship","Daughter Born, Put Up for Adoption and Unemployment","Marries Milena Maric","Birth of Hans Albert Einstein","Annus Mirabilis and the University of Zurich","Privatdozent at Bern University","Move to Prague","Move Back to Zurich","Director of Kaiser Wilhelm Institute","General Theory of Relativity","Divorce,Restoration of German Citizenship Proof of Theory of Relativity","Nobel Banquet at Grand Hôtel, Stockholm","Escape from Nazi Germany","Death of Elsa Einstein in their home","Letter to President Roosevelt","US Citizenship","Death of Albert Einstein"]
        case 1:
            return ["Gandhis Brithplace","Graduation from Inner Temple Law School","Thrown off of train due to discrimination","Natal Indian Congress is founded","Attack by angry mob","Mass meetings outside the Hamidia Mosque","Burning of registration cards as protest","Jallianwala Bagh massacre","Boycott of british goods","Gandhi arrested for producing salt","Gandhis Quit India speech","Beginning 21 day hunger strike in Delhi","Release of prisoners","UK Cabinet Mission","War over Kashmir and Jammu","Start of another hunger strike (probably in Delhi) in order to achieve peace","Assassination at Birla House (now Gandhi Smriti)"]
        case 2:
            return ["Martin Luther King is born","Beginning of Studies at Morehouse","HQ of The Atlanta Journal-Constitution","Becomes Pastor and receivs bechelors degree","Beginning of Studies in Boston","Marriage","Beginning of Pastorate","Becomes President of the MIA","Bombing of Kings home","Nationonal Office of the SCLC","Stride Toward Freedom","Visit to India","Co-pastor in Ebenzer","March on Washington","Receives Nobel Peace Prize","Voting-rights march","Opens chicago office","Planing of Poor People's Campaign","Assassination"]
        default:
            return []
        }
    }
    
	
	override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        
         let adsf = localNotification.alertBody
        if adsf!.rangeOfString("Gandhi") != nil{
            person = "Mahatma Gandhi"
            setupDataForCorrectPerson()
            dummyLocationSetup()
        }else if adsf!.rangeOfString("King") != nil {
            person = "Martin Luther King"
            setupDataForCorrectPerson()
            dummyLocationSetup()
        }else if adsf!.rangeOfString("Einstein") != nil{
            person = "Albert Einstein"
            setupDataForCorrectPerson()
            dummyLocationSetup()
        }
        else{
            entireSetup()
        }
        
        

		
	}
	
	func userAlreadyExist() -> Bool {
        if (defaults.objectForKey("toBeWatched")![0]["toBeWatched"] != nil) {
		return true
		}
		return false
	}
    
    func initialExist() -> Bool {
        print(defaults)
        if (defaults.objectForKey("toBeWatched") != nil) {
            return true
        }
        return false
    }
    func dummyAlreadyExist() -> Bool {
        if (defaults.objectForKey("toBeWatched")![0]["dummy"] != nil) {
            return true
        }
        return false
    }
}


