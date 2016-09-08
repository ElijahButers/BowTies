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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            print("Erros is \(error)")
        }
        
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dict: Any in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managedContext)
            let bowtie = Bowtie(entity: entity!, insertInto: managedContext)
            
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = btDict["rating"] as? NSNumber as! Double
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFromDict(dict: tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named:imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData as NSData?
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = ((btDict["isFavorite"] as? NSNumber) != nil)
            
        }
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        return color
    }

    @IBAction func segmentedControl(_ sender: AnyObject) {
    }

    @IBAction func rate(_ sender: AnyObject) {
    }
}

