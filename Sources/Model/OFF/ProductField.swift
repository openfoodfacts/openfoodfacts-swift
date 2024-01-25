//
//  File.swift
//  
//
//  Created by Henadzi Rabkin on 17/10/2023.
//

import Foundation

enum ProductField: String {
    case barcode = "code"
    case name = "product_name"
    case nameInLanguages = "product_name_"
    case nameAllLanguages = "product_name_languages"
    case genericName = "generic_name"
    case brands = "brands"
    case brandsTags = "brands_tags"
    case countries = "countries"
    case countriesTags = "countries_tags"
    case countriesTagsInLanguages = "countries_tags_"
    case language = "lang"
    case quantity = "quantity"
    case servingSize = "serving_size"
    case servingQuantity = "serving_quantity"
    case packagingQuantity = "product_quantity"
    case frontImage = "image_small_url"
    case selectedImage = "selected_images"
    case imageFrontUrl = "image_front_url"
    case imageFrontSmallUrl = "image_front_small_url"
    case imageIngredientsUrl = "image_ingredients_url"
    case imageIngredientsSmallUrl = "image_ingredients_small_url"
    case imageNutritionUrl = "image_nutrition_url"
    case imageNutritionSmallUrl = "image_nutrition_small_url"
    case imagePackagingUrl = "image_packaging_url"
    case imagePackagingSmallUrl = "image_packaging_small_url"
    case images = "images"
    case ingredients = "ingredients"
    case ingredientsTags = "ingredients_tags"
    case ingredientsTagsInLanguages = "ingredients_tags_"
    case imagesFreshnessInLanguages = "images_to_update_"
    case noNutritionData = "no_nutrition_data"
    case nutriments = "nutriments"
    case additives = "additives_tags"
    case nutrientLevels = "nutrient_levels"
    case ingredientsText = "ingredients_text"
    case ingredientsTextInLanguages = "ingredients_text_"
    case ingredientsTextAllLanguages = "ingredients_text_languages"
    case nutrimentEnergyUnit = "nutriment_energy_unit"
    case nutrimentDataPer = "nutrition_data_per"
    case nutritionData = "nutrition_data"
    case nutriscore = "nutrition_grade_fr"
    case comparedToCategory = "compared_to_category"
    case categories = "categories"
    case categoriesTags = "categories_tags"
    case categoriesTagsInLanguages = "categories_tags_"
    case labels = "labels"
    case labelsTags = "labels_tags"
    case labelsTagsInLanguages = "labels_tags_"
    case packagings = "packagings"
    case packagingsComplete = "packagings_complete"
    case packagingTags = "packaging_tags"
    case packagingTextInLanguages = "packaging_text_"
    case packagingTextAllLanguages = "packaging_text_languages"
    case miscTags = "misc"
    case statesTags = "states_tags"
    case tracesTags = "traces_tags"
    case storesTags = "stores_tags"
    case stores = "stores"
    case ingredientsAnalysisTags = "ingredients_analysis_tags"
    case allergens = "allergens_tags"
    case attributeGroups = "attribute_groups"
    case lastModified = "last_modified_t"
    case lastModifier = "last_modified_by"
    case lastChecked = "last_checked_t"
    case lastChecker = "last_checker"
    case lastEditor = "last_editor"
    case lastImage = "last_image_t"
    case entryDates = "entry_dates_tags"
    case lastCheckDates = "last_check_dates_tags"
    case lastEditDates = "last_edit_dates_tags"
    case lastImageDates = "last_image_dates_tags"
    case created = "created_t"
    case creator = "creator"
    case editors = "editors_tags"
    case ecoscoreGrade = "ecoscore_grade"
    case ecoscoreScore = "ecoscore_score"
    case ecoscoreData = "ecoscore_data"
    case knowledgePanels = "knowledge_panels"
    case embCodes = "emb_codes"
    case manufacturingPlaces = "manufacturing_places"
    case origins = "origins"
    case novaGroup = "nova_group"
    case website = "link"
    case raw = "raw"
    case all = ""
}
