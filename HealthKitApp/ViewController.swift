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


class ViewController: UIViewController {


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
        
        print(5)
        print(56)
        
        getDates()

    }
    
    func getDates(){
//        let calendar = Calendar.autoupdatingCurrent
//        var dateComp = calendar.dateComponents( [.year, .month, .day], from: Date())
//        dateComp.calendar = calendar
        
//        let predicate = HKQuery.predicateForActivitySummary(with: dateComp)
        print("Query Summary")
////
//        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summary, error) -> Void in
//            guard let activitySummaries = summary else {
//                guard let queryError = error else {
//                    fatalError("*** Dit not return a valid error object. ***")
//                }
//                print(summary)
//                return
//            }
//            print(summary)
//            print(
        let healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable(){
            print("Avialable")

            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.activitySummaryType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            
            healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
                if !success {
                    print("Failed to get authorization")
                    // Handle the error here.
                }
            }
            
//            print(healthStore.biologicalSex())
            
        } else {
            print("Health store not available")
        }
//        let calendar = Calendar.current
        // Create the predicate for the query

        
//        let predicate = HKQuery.predicateForWorkouts(with: .running)
//        HKQuery.predicateForWorkouts(with: .running))
        
//        let startDateSort =
//            NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
//
//        let workoutPredicate = HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)

//        let query = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: workoutPredicate,
//          limit: 0, sortDescriptors: [startDateSort]) { (query, summaries, error) in
//            for summary in summaries!{
//                print("Workout = \(summary.startDate)")
//                        }
//
//        }
//        let nextTriggerDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//        var comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
//        comps.calendar = calendar
//
//        let predicate = HKQuery.predicateForActivitySummary(with: comps)
////
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
            
            // Handle data
        }
        
//        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) -> Void in
//            guard let activitySummaries = summaries else {
//                guard let queryError = error else {
//                    fatalError("*** Did not return a valid error object. ***")
//                }
//
//                for summary in summaries! {
//                    print(summary.activeEnergyBurned)
//                }
//                // Handle the error here...
//
//                return
//            }
//
//            // Do something with the summaries here...
//        }
//
        // ...
        
//        let query = HKActivitySummaryQuery.init(predicate: predicate) { (query, summaries, error) in
//            print("Check summaries")
//            let calendar = Calendar.current
//            for summary in summaries! {
//                let dateComp = summary.dateComponents(for: calendar)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
////                summary.activeEnergyBurned
//                let date = dateComp.date
//                print("Date: \(dateFormatter.string(from:date!)), Active Energy Burned: \(summary.activeEnergyBurned)")
//            }
//        }

//        query.updateHandler = { query, summaries, error in
//            DispatchQueue.main.async { () -> Void in
//                print("Update handler")
//                self.ringView.setActivitySummary(summaries?.first, animated: true)
//            }
//        }
//////
        healthStore.execute(query)

//        let energyUnit   = HKUnit.jouleUnit(with: .kilo)
//        let standUnit    = HKUnit.count()
//        let exerciseUnit = HKUnit.second()
//
//        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
//
//            guard let summaries = summaries, summaries.count > 0
//                else {
//                    // No data returned. Perhaps check for error
//                    return
//            }
//            let summary = summaries[0]
//            let energy   = summary.activeEnergyBurned.doubleValue(for: energyUnit)
//            let stand    = summary.appleStandHours.doubleValue(for: standUnit)
//            let exercise = summary.appleExerciseTime.doubleValue(for: exerciseUnit)
//
//            let energyGoal   = summary.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
//            let standGoal    = summary.appleStandHoursGoal.doubleValue(for: standUnit)
//            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
//
//            let energyProgress   = energyGoal == 0 ? 0 : energy / energyGoal
//            let standProgress    = standGoal == 0 ? 0 : stand / standGoal
//            let exerciseProgress = exerciseGoal == 0 ? 0 : exercise / exerciseGoal
//            //            print(summaries[0].appleExerciseTime.doubleValue(for: exerciseUnit))
//            // Handle the activity rings data here
//        }
//        HKHealthStore.execute(query)
        

        
    }
    


}

