// model.swift
// Project: MapDemo 
//
// Created by ksd/Kaj Schermer Didriksen on 22/10/2026 at 09.25.
	

import Foundation
import MapKit

struct RanadomUserData: Decodable {
    let results: [User]
}

struct User: Decodable, Identifiable {
    let name: Name

    struct Name: Decodable {
        let first: String
        let last: String
    }
    var fullname: String {
        return "\(self.name.first) \(self.name.last)"
    }

    var id: String {
        self.login.uuid
    }

    var MKLocation: CLLocationCoordinate2D {
        guard let latitude = Double(self.location.coordinates.latitude),
              let longitude = Double(self.location.coordinates.longitude) else {
            // Fall back to (0, 0) if the API returns coordinates that can't be parsed
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    let location: Location

    struct Location: Decodable {
        let country: String
        let coordinates: Coordinates

        struct Coordinates: Decodable {
            let latitude: String
            let longitude: String
        }
    }

    let login: Login

    struct Login: Decodable {
        let uuid: String
    }

    let picture: Picture

    struct Picture: Decodable {
        let large: URL
        let thumbnail: URL
    }
}


