//
//  RunViewController.swift
//  HealthKitApp
//
//  Created by Graeme Cox on 2019-05-08.
//  Copyright © 2019 Graeme Cox. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI

class RunViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getRecentRun()
        // Do any additional setup after loading the view.
    }
    
    func getRecentRun() {
//        let runningObjectQuery = HKQuery.predicateForObjects(from: myWorkout)
//        
//        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
//            
//            guard error == nil else {
//                // Handle any errors here.
//                fatalError("The initial query failed.")
//            }
//            
//            // Process the initial route data here.
//        }
//        
//        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in
//            
//            guard error == nil else {
//                // Handle any errors here.
//                fatalError("The update failed.")
//            }
//            
//            // Process updates or additions here.
//        }
//        
//        store.execute(routeQuery)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
