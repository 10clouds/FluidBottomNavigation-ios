//
//  TimingFunctions.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 17/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import QuartzCore

internal struct TimingFunctions {
    static let values: [CAMediaTimingFunction] = [
        CAMediaTimingFunction(controlPoints: 0.25, 0, 0.00, 1),
        CAMediaTimingFunction(controlPoints: 0.20, 0, 0.80, 1),
        CAMediaTimingFunction(controlPoints: 0.42, 0, 0.58, 1),
        CAMediaTimingFunction(controlPoints: 0.27, 0, 0.00, 1),
        CAMediaTimingFunction(controlPoints: 0.50, 0, 0.50, 1),
    ]
}
