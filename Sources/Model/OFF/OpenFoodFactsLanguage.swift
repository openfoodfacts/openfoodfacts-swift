//
//  OpenFoodFactsLanguage.swift
//  Taxonomy is broken https://github.com/openfoodfacts/openfoodfacts-server/blob/main/taxonomies/languages.txt
//  13k lines
//  Created by Henadzi Rabkin on 02/10/2023.
//

import Foundation

public enum OpenFoodFactsLanguage: String, CaseIterable, Identifiable, Equatable {
    public var id: Self { self }
    
    case AFAR
    case AFRIKAANS
    case AKAN
    case AMHARIC
    case ARABIC
    case ARAGONESE
    case ASSAMESE
    case AVAR
    case AVESTAN
    case AYMARA
    case AZERBAIJANI
    case BELARUSIAN
    case BULGARIAN
    case BAMBARA
    case BASHKIR
    case BENGALI
    case BIHARI_LANGUAGES
    case BISLAMA
    case TIBETAN_LANGUAGE
    case BRETON
    case BOSNIAN
    case CATALAN
    case CHECHEN
    case CHEWA
    case CHAMORRO
    case CHURCH_SLAVONIC
    case CORSICAN
    case CREE
    case CZECH
    case CHUVASH
    case WELSH
    case DANISH
    case DZONGKHA_LANGUAGE
    case GERMAN
    case MODERN_GREEK
    case ENGLISH
    case ESPERANTO
    case SPANISH
    case ESTONIAN
    case EWE
    case BASQUE
    case PERSIAN
    case FINNISH
    case FAROESE
    case FRENCH
    case FIJIAN_LANGUAGE
    case FULA_LANGUAGE
    case IRISH
    case SCOTTISH_GAELIC
    case GALICIAN
    case GREENLANDIC
    case GIKUYU
    case GUARANI
    case GUJARATI
    case HAUSA
    case HEBREW
    case HERERO
    case HINDI
    case HIRI_MOTU
    case CROATIAN
    case HAITIAN_CREOLE
    case HUNGARIAN
    case ARMENIAN
    case INDONESIAN
    case NUOSU_LANGUAGE
    case ICELANDIC
    case IDO
    case ITALIAN
    case INUKTITUT
    case INTERLINGUA
    case INUPIAT_LANGUAGE
    case INTERLINGUE
    case IGBO_LANGUAGE
    case JAPANESE
    case JAVANESE
    case GEORGIAN
    case KANURI
    case KASHMIRI
    case KAZAKH
    case KANNADA
    case KINYARWANDA
    case KOREAN
    case KOMI
    case KONGO_LANGUAGE
    case KURDISH
    case KWANYAMA
    case CORNISH
    case KIRUNDI
    case KYRGYZ
    case LATIN
    case LUXEMBOURGISH
    case LAO
    case LATVIAN
    case LITHUANIAN
    case LINGALA_LANGUAGE
    case LIMBURGISH_LANGUAGE
    case LUBA_KATANGA_LANGUAGE
    case LUGANDA
    case MALAGASY
    case MACEDONIAN
    case MAORI
    case MARSHALLESE
    case MONGOLIAN
    case MANX
    case MARATHI
    case MALAY
    case MALAYALAM
    case MALDIVIAN_LANGUAGE
    case MALTESE
    case MOLDOVAN
    case BURMESE
    case BOKMAL
    case NAVAJO
    case NEPALI
    case NAURUAN
    case NDONGA_DIALECT
    case DUTCH
    case NYNORSK
    case NORWEGIAN
    case NORTHERN_NDEBELE_LANGUAGE
    case NORTHERN_SAMI
    case SAMOAN
    case SOUTHERN_NDEBELE
    case OCCITAN
    case OLD_CHURCH_SLAVONIC
    case OSSETIAN
    case OROMO
    case ODIA
    case OJIBWE
    case PALI
    case PASHTO
    case PUNJABI
    case POLISH
    case PORTUGUESE
    case QUECHUA_LANGUAGES
    case ROMANSH
    case ROMANIAN
    case RUSSIAN
    case SANSKRIT
    case SARDINIAN_LANGUAGE
    case SINDHI
    case SANGO
    case SINHALA
    case SLOVAK
    case SLOVENE
    case SHONA
    case SOMALI
    case ALBANIAN
    case SERBIAN
    case SWAZI
    case SOTHO
    case SUNDANESE_LANGUAGE
    case SWEDISH
    case SWAHILI
    case TAMIL
    case TELUGU
    case TAJIK
    case THAI
    case TIGRINYA
    case TAGALOG
    case TSWANA
    case TURKISH
    case TURKMEN
    case TSONGA
    case TATAR
    case TONGAN_LANGUAGE
    case TWI
    case TAHITIAN
    case UYGHUR
    case UKRAINIAN
    case URDU
    case UZBEK
    case VENDA
    case VIETNAMESE
    case VOLAPUK
    case WEST_FRISIAN
    case WOLOF
    case XHOSA
    case YIDDISH
    case YORUBA
    case CHINESE
    case ZHUANG_LANGUAGES
    case ZULU
    case UNDEFINED
    
    public var info: (code: String, description: String) {
        switch self {
        case .ENGLISH:
            return ("en", "English")
        case .CHURCH_SLAVONIC:
            return ("cu", "Old Church Slavonic")
        case .OLD_CHURCH_SLAVONIC:
            return ("cu", "Old Church Slavonic")
        case .DZONGKHA_LANGUAGE:
            return ("dz", "Dzongkha")
        case .JAPANESE:
            return ("ja", "日本語")
        case .MALAY:
            return ("ms", "Melayu")
        case .TAGALOG:
            return ("tl", "Tagalog")
        case .MOLDOVAN:
            return ("mo", "Moldovenească")
        case .MONGOLIAN:
            return ("mn", "Монгол")
        case .KOREAN:
            return ("ko", "한국인")
        case .LUBA_KATANGA_LANGUAGE:
            return ("lu", "Luba Katanga")
        case .KAZAKH:
            return ("kk", "қазақ")
        case .QUECHUA_LANGUAGES:
            return ("qu", "Runasimi")
        case .UKRAINIAN:
            return ("uk", "Українська")
        case .OCCITAN:
            return ("oc", "Occitan")
        case .BIHARI_LANGUAGES:
            return ("bh", "Bihari Languages")
        case .SOUTHERN_NDEBELE:
            return ("nr", "SouthNdebele")
        case .BOKMAL:
            return ("nb", "Norskbokmål")
        case .KOMI:
            return ("kv", "коми кыв")
        case .MODERN_GREEK:
            return ("el", "Ελληνικά")
        case .FIJIAN_LANGUAGE:
            return ("fj", "Fijian")
        case .ZULU:
            return ("zu", "ខ្មែរ")
        case .IDO:
            return ("io", "Ido")
        case .SANSKRIT:
            return ("sa", "संस्कृत")
        case .MACEDONIAN:
            return ("mk", "македонски")
        case .SOTHO:
            return ("st", "SouthernSotho")
        case .SCOTTISH_GAELIC:
            return ("gd", "ScottishGaelic")
        case .MARATHI:
            return ("mr", "मराठी")
        case .NAURUAN:
            return ("na", "Nauru")
        case .OROMO:
            return ("om", "Oromoo")
        case .WELSH:
            return ("cy", "Cymraeg")
        case .VIETNAMESE:
            return ("vi", "TiếngViệt")
        case .BISLAMA:
            return ("bi", "Bislama")
        case .SOMALI:
            return ("so", "Soomaali")
        case .LITHUANIAN:
            return ("lt", "lietuvių")
        case .HAITIAN_CREOLE:
            return ("ht", "ayisyen")
        case .MALAGASY:
            return ("mg", "Malagasy")
        case .SPANISH:
            return ("es", "Español")
        case .DANISH:
            return ("da", "dansk")
        case .SLOVENE:
            return ("sl", "Slovenščina")
        case .ICELANDIC:
            return ("is", "íslenskur")
        case .ESTONIAN:
            return ("et", "eestikeel")
        case .WOLOF:
            return ("wo", "Wolof")
        case .HIRI_MOTU:
            return ("ho", "HiriMotu")
        case .TAMIL:
            return ("ta", "தமிழ்")
        case .SLOVAK:
            return ("sk", "Slovenčina")
        case .HERERO:
            return ("hz", "Herero")
        case .ITALIAN:
            return ("it", "Italiano")
        case .IRISH:
            return ("ga", "Gaeilge")
        case .SHONA:
            return ("sn", "Shona")
        case .MARSHALLESE:
            return ("mh", "Ebon")
        case .FRENCH:
            return ("fr", "Français")
        case .AYMARA:
            return ("ay", "Aymar aru")
        case .HEBREW:
            return ("he", "עִברִית")
        case .NORTHERN_SAMI:
            return ("se", "Sámegiella")
        case .BENGALI:
            return ("bn", "বাংলা")
        case .ODIA:
            return ("or", "ଓଡ଼ିଆ")
        case .MALAYALAM:
            return ("ml", "മലയാളം")
        case .DUTCH:
            return ("nl", "Nederlands")
        case .UYGHUR:
            return ("ug", "ئۇيغۇر")
        case .SERBIAN:
            return ("sr", "Српски")
        case .TIBETAN_LANGUAGE:
            return ("bo", "Tibetan")
        case .BELARUSIAN:
            return ("be", "беларускi")
        case .SAMOAN:
            return ("sm", "Gagana Sāmoa")
        case .PUNJABI:
            return ("pa", "Panjabi")
        case .RUSSIAN:
            return ("ru", "Русский")
        case .TAHITIAN:
            return ("ty", "Tahitian")
        case .INTERLINGUA:
            return ("ia", "Interlingua")
        case .AFAR:
            return ("aa", "Afar")
        case .GREENLANDIC:
            return ("kl", "Greenlandic")
        case .LATIN:
            return ("la", "latīnum")
        case .CHINESE:
            return ("zh", "中文")
        case .TURKMEN:
            return ("tk", "Türkmen")
        case .WEST_FRISIAN:
            return ("fy", "West Frisian")
        case .TSONGA:
            return ("ts", "Tsonga")
        case .ROMANSH:
            return ("rm", "Romansh")
        case .INUPIAT_LANGUAGE:
            return ("ik", "Inupiaq")
        case .TAJIK:
            return ("tg", "тоҷикӣ")
        case .BURMESE:
            return ("my", "မြန်မာဘာသာ")
        case .JAVANESE:
            return ("jv", "basajawa")
        case .CHECHEN:
            return ("ce", "Chechen")
        case .ASSAMESE:
            return ("as", "অসমীয়া")
        case .ARABIC:
            return ("ar", "عربى")
        case .KINYARWANDA:
            return ("rw", "Kinyarwanda")
        case .TONGAN_LANGUAGE:
            return ("to", "Tongan")
        case .SINHALA:
            return ("si", "සිංහල")
        case .ARMENIAN:
            return ("hy", "հայերեն")
        case .KURDISH:
            return ("ku", "Kurdî")
        case .THAI:
            return ("th", "ไทย")
        case .CREE:
            return ("cr", "ᐃᓄᒃᑎᑐᑦ")
        case .SWAHILI:
            return ("sw", "kiswahili")
        case .GUJARATI:
            return ("gu", "ગુજરાતી")
        case .PERSIAN:
            return ("fa", "فارسی")
        case .BOSNIAN:
            return ("bs", "bosanski")
        case .AMHARIC:
            return ("am", "አማርኛ")
        case .ARAGONESE:
            return ("an", "Aragonés")
        case .CROATIAN:
            return ("hr", "Hrvatski")
        case .CHEWA:
            return ("ny", "Chewa")
        case .ZHUANG_LANGUAGES:
            return ("za", "Zhuang")
        case .LINGALA_LANGUAGE:
            return ("ln", "Lingala")
        case .BAMBARA:
            return ("bm", "Bamanankan")
        case .LIMBURGISH_LANGUAGE:
            return ("li", "Limburgish")
        case .NUOSU_LANGUAGE:
            return ("ii", "SichuanYi")
        case .KWANYAMA:
            return ("kj", "Kwanyama")
        case .KIRUNDI:
            return ("rn", "Kirundi")
        case .EWE:
            return ("ee", "Eʋegbe")
        case .FAROESE:
            return ("fo", "Faroese")
        case .SINDHI:
            return ("sd", "سنڌي")
        case .CORSICAN:
            return ("co", "Corsu")
        case .KANNADA:
            return ("kn", "ಕನ್ನಡ")
        case .NORWEGIAN:
            return ("no", "norsk")
        case .SUNDANESE_LANGUAGE:
            return ("su", "Basa Sunda")
        case .GEORGIAN:
            return ("ka", "ქართული")
        case .HAUSA:
            return ("ha", "હૌસા")
        case .TSWANA:
            return ("tn", "Setswana")
        case .CATALAN:
            return ("ca", "català")
        case .NDONGA_DIALECT:
            return ("ng", "Ndonga")
        case .IGBO_LANGUAGE:
            return ("ig", "Igbo")
        case .AFRIKAANS:
            return ("af", "Afrikaans")
        case .POLISH:
            return ("pl", "Polski")
        case .KASHMIRI:
            return ("ks", "कश्मीरी")
        case .MAORI:
            return ("mi", "മലയാളം")
        case .HUNGARIAN:
            return ("hu", "Magyar")
        case .BRETON:
            return ("br", "Breton")
        case .PORTUGUESE:
            return ("pt", "Português")
        case .BULGARIAN:
            return ("bg", "български")
        case .AVESTAN:
            return ("ae", "Avesta")
        case .NEPALI:
            return ("ne", "नेपाली")
        case .TWI:
            return ("tw", "Twi")
        case .UZBEK:
            return ("uz", "ozbek")
        case .CHAMORRO:
            return ("ch", "Chamoru")
        case .GUARANI:
            return ("gn", "Guaraní")
        case .NYNORSK:
            return ("nn", "Norsknynorsk")
        case .AZERBAIJANI:
            return ("az", "Azərbaycan")
        case .CZECH:
            return ("cs", "čeština")
        case .NAVAJO:
            return ("nv", "Diné bizaad")
        case .FINNISH:
            return ("fi", "Suomalainen")
        case .LUXEMBOURGISH:
            return ("lb", "lëtzebuergesch")
        case .SWEDISH:
            return ("sv", "svenska")
        case .YIDDISH:
            return ("yi", "יידיש")
        case .INUKTITUT:
            return ("iu", "Inuktitut")
        case .LAO:
            return ("lo", "ພາສາລາວ")
        case .CHUVASH:
            return ("cv", "Chuvash")
        case .MALTESE:
            return ("mt", "Malti")
        case .MALDIVIAN_LANGUAGE:
            return ("dv", "Maldivian")
        case .INTERLINGUE:
            return ("ie", "Interlingue")
        case .OSSETIAN:
            return ("os", "Ossetian")
        case .BASHKIR:
            return ("ba", "башҡорт тілі")
        case .OJIBWE:
            return ("oj", "ᐊᓂᔑᓈᐯᒧᐎᓐ")
        case .KANURI:
            return ("kr", "Kanuri")
        case .INDONESIAN:
            return ("id", "bahasaIndonesia")
        case .SARDINIAN_LANGUAGE:
            return ("sc", "Sardinian")
        case .AKAN:
            return ("ak", "Akan")
        case .MANX:
            return ("gv", "Gaelg")
        case .TURKISH:
            return ("tr", "Türk")
        case .ESPERANTO:
            return ("eo", "Esperanto")
        case .PASHTO:
            return ("ps", "پښتو")
        case .KYRGYZ:
            return ("ky", "Кыргызча")
        case .VOLAPUK:
            return ("vo", "Volapuk")
        case .AVAR:
            return ("av", "Авар")
        case .SANGO:
            return ("sg", "Sango")
        case .VENDA:
            return ("ve", "Venda")
        case .ALBANIAN:
            return ("sq", "shqiptare")
        case .BASQUE:
            return ("eu", "euskara")
        case .FULA_LANGUAGE:
            return ("ff", "Fula")
        case .GERMAN:
            return ("de", "Deutsch")
        case .LATVIAN:
            return ("lv", "latviski")
        case .CORNISH:
            return ("kw", "Cornish")
        case .PALI:
            return ("pi", "Pali")
        case .TATAR:
            return ("tt", "Татар")
        case .ROMANIAN:
            return ("ro", "Română")
        case .GIKUYU:
            return ("ki", "Gikuyu")
        case .TIGRINYA:
            return ("ti", "ትግሪኛ")
        case .GALICIAN:
            return ("gl", "galego")
        case .TELUGU:
            return ("te", "తెలుగు")
        case .HINDI:
            return ("hi", "हिन्दी")
        case .KONGO_LANGUAGE:
            return ("kg", "Kongo")
        case .XHOSA:
            return ("xh", "isiXhosa")
        case .SWAZI:
            return ("ss", "Swati")
        case .LUGANDA:
            return ("lg", "Luganda")
        case .URDU:
            return ("ur", "اردو")
        case .NORTHERN_NDEBELE_LANGUAGE:
            return ("nd", "Northern Ndebele")
        case .YORUBA:
            return ("yo", "Yoruba")
        case .UNDEFINED:
            return ("-", "Undefined")
        }
    }
}
