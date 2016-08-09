//
//  ViewController.swift
//  ClousKit
//
//  Created by Klaus Rodewig on 09.08.16.
//  Copyright © 2016 Appnö UG (haftungsbeschränkt). All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        cloudStuff()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cloudStuff() {
        // definitions
        let kRecipeRecordTypeTitle = "Recipes"
        
        // create object
        let theObject = CKRecord(recordType: kRecipeRecordTypeTitle)
        theObject["title"] = "Cheesecake"
        theObject["comment"] = "disgusting"
        
        // write record
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(theObject) {
            (record, error) -> Void in
        }
        
        // build predicate for search operation
        var thePredicate = NSPredicate(value: true)
        let theSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let theQuery = CKQuery(recordType:kRecipeRecordTypeTitle, predicate: thePredicate)
        theQuery.sortDescriptors = [theSortDescriptor]
        
        // perform search
        let theQueryOperation = CKQueryOperation(query: theQuery)
        theQueryOperation.desiredKeys = ["title"]
        theQueryOperation.resultsLimit = 20
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(theQueryOperation)
        
        // push
        
        thePredicate = NSPredicate(format:"title = %@", "Cheesecake")
        let theSubscription = CKSubscription(recordType: kRecipeRecordTypeTitle, predicate:thePredicate, options: .FiresOnRecordCreation)
        let theNotification = CKNotificationInfo()
        theNotification.alertBody = "Ein neues Rezept ist da!"
        theNotification.soundName = UILocalNotificationDefaultSoundName
        theSubscription.notificationInfo = theNotification
        CKContainer.defaultContainer().publicCloudDatabase.saveSubscription(theSubscription) { (result, error) -> Void in
            if error != nil { print(error!.localizedDescription)
            } }
    }
}

