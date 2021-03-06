//
//  AirQualityViewModel.swift
//  AirQualityMonitor
//
//  Created by Karol on 10.01.2018.
//  Copyright © 2018 KarolPiatek. All rights reserved.
//

import RxSwift

class AirQualityViewModel: BaseTabViewModel {
    
    var stationName = Variable<String>("")
    var lowestMeasurement = PublishSubject<Measurement>()
    var lastupDate: Observable<String> {
        return lowestMeasurement.map { $0.date ?? "" }
    }
    var airStatus: Observable<IndexNameEnum> {
        return lowestMeasurement.map { $0.indexLevelEnum ?? IndexNameEnum.noValue }
    }
    
    override init(flowDelegate: CoordinatorProtocol, station: Station) {
        super.init(flowDelegate: flowDelegate, station: station)
        self.stationName.value = station.stationName ?? ""
        subscribeLowestMeasurement()
    }
    
    func subscribeLowestMeasurement() {
        measurementsSection.subscribe(onNext: { item in
            guard let measurements = super.measurements else { return }
            let lowest = self.getLowestMeasurement(measurements: measurements)
            self.lowestMeasurement.onNext(lowest)
        }).disposed(by: bag)
    }
    
    func getLowestMeasurement(measurements: [Measurement]) -> Measurement {
        let newMeasurements = measurements.filter { $0.indexLevelEnum?.rawValue != nil }
        guard var lowest = newMeasurements.first else { return Measurement() }
        for measurement in newMeasurements {
            guard let lowestValue = lowest.indexLevelEnum?.rawValue,
                let current = measurement.indexLevelEnum?.rawValue else { return Measurement() }
            if lowestValue > current {
                lowest = measurement
            }
        }
        return lowest
    }
}
