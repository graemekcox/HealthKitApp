//
//  ViewController.swift
//  HealthKitApp
//
//  Created by Graeme Cox on 2019-05-04.
//  Copyright © 2019 Graeme Cox. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI


class DailyViewController: UIViewController {

    @IBOutlet weak var energyBurned_label: UILabel!
    @IBOutlet weak var energyBurnedGoal_label: UILabel!
    @IBOutlet weak var excer_label: UILabel!
    @IBOutlet weak var excerGoal_label: UILabel!
    @IBOutlet weak var stand_label: UILabel!
    @IBOutlet weak var standGoal_label: UILabel!
    @IBOutlet weak var date_label: UILabel!

    
    
    
    var healthStore: HKHealthStore!
    @IBOutlet var ringView: HKActivityRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let sum:HKActivitySummary = HKActivitySummary.init()
//        print(sum.activeEnergyBurned)
//        print(sum.activeEnergyBurnedGoal)
//        var temp = self.ringView.activitySummary
//
//        self.ringView.setActivitySummary(temp, animated: true)
////        self.ringView.setActivitySummary(sum, animated: true)
        
        // No idea why these lines are needed, but get errors without them
        let frame    = CGRect(x: 0, y: 0, width: 200, height: 200)
        let ringView2 = HKActivityRingView(frame: frame)

        
        getPermissions()
        getDates()

    }
    
    func getPermissions(){
        self.healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable(){
            print("Health data available")
            
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.activitySummaryType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            
            self.healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
                if !success {
                    print("Failed to get authorization")
                    // Handle the error here.
                }
            }
            
            //            print(healthStore.biologicalSex())
            
        } else {
            print("Health store not available")
        }
    }
    
    func getWeek(){
        let calendar = Calendar.autoupdatingCurrent

        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!

        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: lastWeekDate
        )

        // This line is required to make the whole thing work
        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in

            guard let summaries = summaries, summaries.count > 0
                else {
                    return
            }
            for summary in summaries {
                print(summary.activeEnergyBurned)
                let standUnit = HKUnit.count()
                let standHours = summary.appleStandHours.doubleValue(for: standUnit)
                print("Stand hours = \(standHours)")
                self.ringView.setActivitySummary(summaries.first, animated: true)
//                self.ringView.setActivitySummary(summary, animated: true)
//                self.ringView.setActivitySummary(summary, animated: true)
//                self.ringView.setActivitySummary(summary, animated: true)
            }
            self.healthStore.execute(query)
            // Handle data
        }
    }
    
    func getDates(){
//        let calendar = Calendar.autoupdatingCurrent
//
//        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
//
//        var dateComponents = calendar.dateComponents(
//            [ .year, .month, .day ],
//            from: lastWeekDate
//        )
//
//        // This line is required to make the whole thing work
//        dateComponents.calendar = calendar
//
//        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
//        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
//
//            guard let summaries = summaries, summaries.count > 0
//                else {
//                    return
//            }
//            for summary in summaries {
//                print(summary.activeEnergyBurned)
//                let standUnit = HKUnit.count()
//                let standHours = summary.appleStandHours.doubleValue(for: standUnit)
//                print("Stand hours = \(standHours)")
//                self.ringView.setActivitySummary(summaries.first, animated: true)
////                self.ringView.setActivitySummary(summary, animated: true)
////                self.ringView.setActivitySummary(summary, animated: true)
////                self.ringView.setActivitySummary(summary, animated: true)
//            }
//
//            // Handle data
//        }


        
        let componentFlags: Set<Calendar.Component> = [.day, .month, .year, .era]
        var components = Calendar.current.dateComponents(componentFlags, from: Date())
//        let date = Date().description
//        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        ////                summary.activeEnergyBurned
        //                let date = dateComp.date
        //                print("Date: \(dateFormatter.string(from:date!)),
        
        self.date_label.text = dateFormatter.string(from:Date())
        // Set the calendar used to calculate the components on the result.
        components.calendar = Calendar.current
        
        // Restrict query to activity summaries whose date corresponds to today.
        let predicate = NSPredicate(format: "%K = %@", argumentArray: [HKPredicateKeyPathDateComponents, components])
        
        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            // There can only be one `HKActivitySummary` for a given day.
            guard let summary = summaries?.first else { return }

            // Update our rings with the retrieved data on the main queue.
            DispatchQueue.main.async {
                self.ringView.setActivitySummary(summary, animated: true)
                
                let standUnit = HKUnit.count()
                let excerUnit = HKUnit.minute()
                let energyUnit = HKUnit.largeCalorie()
                self.energyBurned_label.text = String(Int(summary.activeEnergyBurned.doubleValue(for: energyUnit)))
                self.energyBurnedGoal_label.text = String(summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit))
                self.excer_label.text = String(summary.appleExerciseTime.doubleValue(for: excerUnit))
                self.excerGoal_label.text = String(summary.appleExerciseTimeGoal.doubleValue(for:excerUnit))
                self.stand_label.text = String(summary.appleStandHours.doubleValue(for:standUnit))
                self.standGoal_label.text = String(summary.appleStandHoursGoal.doubleValue(for:standUnit))
            }
        }
        

        self.healthStore.execute(query)

        
    }
    


}

