//
//  Bowtie+CoreDataProperties.swift
//  BowTies
//
//  Created by User on 9/3/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import Foundation
import CoreData

extension Bowtie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bowtie> {
        return NSFetchRequest<Bowtie>(entityName: "Bowtie");
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastWorn: NSDate?
    @NSManaged public var rating: Double
    @NSManaged public var searchKey: String?
    @NSManaged public var timesWorn: Int32
    @NSManaged public var photoData: NSData?
    @NSManaged public var tintColor: NSObject?

}
