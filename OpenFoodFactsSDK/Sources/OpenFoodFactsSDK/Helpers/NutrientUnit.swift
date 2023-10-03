//
//  Nutrient.swift
//
//
//  Created by Henadzi Rabkin on 03/10/2023.
//

import Foundation

enum Unit: String {
    case g, kcal, kj, milliG = "mg", microG = "µg", percent = "%", unknown
}

let nutrientToUnit: [String: Unit] = [
    "salt": .g,
    "sodium": .g,
    "fiber": .g,
    "sugars": .g,
    "fat": .g,
    "saturated-fat": .g,
    "proteins": .g,
    "energy-kcal": .kcal,
    "energy-kj": .kj,
    "carbohydrates": .g,
    "caffeine": .g,
    "calcium": .milliG,
    "iron": .milliG,
    "vitamin-c": .milliG,
    "magnesium": .milliG,
    "phosphorus": .milliG,
    "potassium": .milliG,
    "zinc": .milliG,
    "copper": .milliG,
    "selenium": .microG,
    "vitamin-a": .microG,
    "vitamin-e": .milliG,
    "vitamin-d": .microG,
    "vitamin-b1": .milliG,
    "vitamin-b2": .milliG,
    "vitamin-pp": .milliG,
    "vitamin-b6": .milliG,
    "vitamin-b12": .microG,
    "vitamin-b9": .microG,
    "vitamin-k": .microG,
    "cholesterol": .milliG,
    "butyric-acid": .g,
    "caproic-acid": .g,
    "caprylic-acid": .g,
    "capric-acid": .g,
    "lauric-acid": .g,
    "myristic-acid": .g,
    "palmitic-acid": .g,
    "stearic-acid": .g,
    "oleic-acid": .g,
    "linoleic-acid": .g,
    "docosahexaenoic-acid": .g,
    "eicosapentaenoic-acid": .g,
    "erucic-acid": .g,
    "monounsaturated-fat": .g,
    "polyunsaturated-fat": .g,
    "alcohol": .percent,
    "pantothenic-acid": .milliG,
    "biotin": .microG,
    "chloride": .milliG,
    "chromium": .microG,
    "fluoride": .milliG,
    "iodine": .microG,
    "manganese": .milliG,
    "molybdenum": .microG,
    "omega-3-fat": .milliG,
    "omega-6-fat": .milliG,
    "trans-fat": .g
]
