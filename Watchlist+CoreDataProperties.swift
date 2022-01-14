//
//  Watchlist+CoreDataProperties.swift
//  Cryptomate
//
//  Created by Gregorius Albert on 14/01/22.
//
//

import Foundation
import CoreData


extension Watchlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watchlist> {
        return NSFetchRequest<Watchlist>(entityName: "Watchlist")
    }

    @NSManaged public var coinId: String?

}

extension Watchlist : Identifiable {

}
