//
//  HostAppartementMapper.swift
//  
//
//  Created by Kostya Tsyvilko on 23.04.24.
//

import Foundation
import FHRepository

enum HostAppartementMapper {
    static func mapToAppartementAvailabilityDTO(
        from: HostAppartement
    ) -> AppartementAvailabilityDTO {
        AppartementAvailabilityDTO(
            id: from.id,
            isAvailable: !from.isAvailableForBook
        )
    }
}
