//
//  ClusterPlacemark.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 10.06.22.
//

import Foundation
import YandexMapsMobile

protocol ClusterPlacemark: AnyObject{

}

extension YMKPlacemarkMapObject: ClusterPlacemark {}
