//
//  Person+CoreDataProperties.swift
//  PersonList
//
//  Created by Mazharul Huq on 2/14/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var employed: Bool
    @NSManaged public var favColor: NSObject?
    @NSManaged public var favImage: NSData?
    @NSManaged public var name: String?
    @NSManaged public var popularity: Double

}
