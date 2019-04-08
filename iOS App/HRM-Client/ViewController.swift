//
//  ViewController.swift
//  HRM-Webserver
//
//  Created by Bruno Robert on 09/03/2019.
//  Copyright © 2019 Bruno Robert. All rights reserved.
//

import UIKit
import HealthKit
import SocketIO

class ViewController: UIViewController {
    
    //MARK: Socket Variables
    var manager: SocketManager?
    var socket: SocketIOClient?

    
    //MARK: Global Variables
    
    let heartRateUnit:HKUnit = HKUnit(from: "count/min") // used to read results.
    let healthStore = HKHealthStore() // asks for permission and then is used to query health data
    
    
    var currentHR:Double! // stores the most recent heart rate
    
    //MARK: Outlets
    
    @IBOutlet public var HRDisplay: UILabel! // The label that displays the HR
    @IBOutlet public var serverIp: UITextField!
    
    //MARK: IBActions
    
    //When button is pressed, it will start a background task that automatically updates the HR
    @IBAction public func getHR() {
        // the permissions we are going to ask for
        let permissionTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: nil, read: permissionTypes) { (success, error) in
            if !success { // if there was an error
                print("there was an error :'( \(error.debugDescription)")
            }
        }
        
        // sample type for the HK query
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // building the query
        let query = HKSampleQuery(sampleType: sampleType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if error != nil { // if there was an error
                print("there was an error :'( \(error.debugDescription)")
            }
            
            // pass the results to the extractHR function
            self.extractHR(results: results)
            
        }
        healthStore.execute(query) // execute the query
        
    }
    
    // Starts a BG loop that checks for updates in HR values in HK. For each update, it calls getHR
    @IBAction public func bgAutoHRUpdateDetector() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        let query = HKObserverQuery(sampleType: sampleType!, predicate: nil) { (query, compileHandler, error) in
            if error != nil {
                // Perform Proper Error Handling Here...
                print("*** An error occured while setting up the stepCount observer. \(error!.localizedDescription) ***")
                abort()
            }
            self.getHR()
        }
        healthStore.execute(query)
    }
    
    // dismisses the keyboard whe nthe done key is pressed
    @IBAction func keyboardDone(_ sender: UITextField) {
        //Since the first responder is the keyboard, it closes it
        sender.resignFirstResponder()
    }
    
    //reads the value in the text field and attempts a socket connection
    @IBAction func connectSocket() {
        
        let ip = serverIp.text!
        print("Attempting connection to \(ip)")
        // TODO: connect to socket
        self.manager = SocketManager(socketURL: URL(string: ip)!, config: [.log(true), .compress])
        self.socket = manager?.defaultSocket
        self.addHandlers()
        self.socket?.connect()

        
    }
    
    //MARK: Helper Functions
    
    // add the handlers for the socket
    func addHandlers() {
        // TODO: add the even handlers
        self.socket?.on(clientEvent: .connect) {data, ack in
            print("addHandlers: socket connected")
        }
    }
    
    // MARK: Action Functions
    
    // updates the HR label using currentHR(var)
    func updateDisplay(){
        HRDisplay.text = String(currentHR)
        print("updating display")
        // TODO: send the data through the socket connection
        self.socket?.emit("HR", currentHR)
    }
    
    // extracts the most recent HR and sotres it in currentHR, it then calls updateDisaply asyncronousl from the main thread
    public func extractHR(results: [HKSample]?) {
        guard let currData:HKQuantitySample = results![(results?.count)!-1] as? HKQuantitySample else { return } // TODO: 0 is probably not the correct index
        print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
        
        self.currentHR = currData.quantity.doubleValue(for: heartRateUnit)
        DispatchQueue.main.async {
            //code that caused error goes here
            self.updateDisplay()
        }
    }
    
    //called when the app starts?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //dismisses the keyboard (not the only way to do it)
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
}

