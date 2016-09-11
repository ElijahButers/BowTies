//
//  ViewController.swift
//  BowTies
//
//  Created by User on 9/2/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    var currentBowtie: Bowtie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        insertSimpleData()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Bowtie")
        let firstTitle = segmentedControl.titleForSegment(at: 0)
        
        request.predicate = NSPredicate(format:"searchKey == %@", firstTitle!)
        
        do {
            let results = try managedContext.fetch(request) as! [Bowtie]
            currentBowtie = results.first
            populate(currentBowtie)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Insert sample data
    func insertSimpleData() {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bowtie")
        request.predicate = NSPredicate(format: "searchKey != nil")
        
        do {
            let count = try managedContext.count(for: request)
            if count > 0 { return }
        } catch let error as NSError {
            print("Error is \(error)")
        }
        
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dict: Any in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managedContext)
            let bowtie = Bowtie(entity: entity!, insertInto: managedContext)
            
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = btDict["rating"] as! NSNumber?
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFromDict(dict: tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named:imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData as NSData?
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = btDict["isFavorite"] as? NSNumber
            
        }
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        return color
    }
    
    func populate(_ bowtie: Bowtie) {
        
        imageView.image = UIImage(data: bowtie.photoData! as Data)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating!.doubleValue)/5"
        
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn!.intValue)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        lastWornLabel.text = "Last worn: " + dateFormatter.string(from: bowtie.lastWorn! as Date)
        favoriteLabel.isHidden = !bowtie.isFavorite!.boolValue
        view.tintColor = bowtie.tintColor as! UIColor
    }
    
    func updateRating(_ numericString: String) {
        
        currentBowtie.rating = (numericString as NSString).doubleValue as NSNumber?
        
        do {
            try managedContext.save()
            populate(currentBowtie)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                    rate(currentBowtie)
            }
        }
    }
    
    //MARK: - Actions

    @IBAction func segmentedControl(_ sender: AnyObject) {
        
        let times = currentBowtie.timesWorn!.intValue
        currentBowtie.timesWorn = NSNumber(integerLiteral: (times + 1))
        currentBowtie.lastWorn = NSDate()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    @IBAction func rate(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Rating", message: "Rate this bow tie", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            
            let textField = alert.textFields![0] as UITextField
            self.updateRating(textField.text!)
    })
        alert.addTextField(configurationHandler: {
            (textField: UITextField!) in
            textField.keyboardType = .numberPad
        })
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func wear(_ sender: AnyObject) {
        
        let times = currentBowtie.timesWorn!.intValue
        currentBowtie.timesWorn = NSNumber(integerLiteral: (times + 1))
        currentBowtie.lastWorn = NSDate()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
