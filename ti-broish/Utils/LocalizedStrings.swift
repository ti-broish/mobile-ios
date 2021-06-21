//
//  LocalizedStrings.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

struct LocalizedStrings {
    
    struct SendInputField {
        
        static let country: String = "Държава"
        static let electionRegion: String = "МИР"
        static let municipality: String = "Община"
        static let town: String = "Населено място"
        static let cityRegion: String = "Район"
        static let description: String = "Описание"
        static let section: String = "Секция"
        static let sectionNumber: String = "Номер на секция"
        static let sectionNumberPlaceholder = "Въведете номер на секция"
    }
    
    struct Buttons {
        
        static let menu: String = "Меню"
        static let back: String = "Назад"
        static let cancel: String = "Откажи"
        static let save: String = "Запази"
        static let send: String = "Изпрати"
        static let gallery: String = "Качи снимка"
        static let camera: String = "Снимай"
    }
    
    struct Photos {
        
        static let selected: String = "Избрани"
        static let message: String = "Моля добавете 4 снимки, съдържащи прървата страница на протокола, страниците с общ брой гласове и страниците с разпределение на гласовете по партии"
        
        struct Settings {
            
            static let title: String = "Достъпа е забранен"
            static let message: String = "За да използвате снимки и камера трябва да разрешите достъпа до тях в секцията Настройки"
            static let settings: String = "Настройки"
        }
    }
    
    struct Violations {
        
        static let title: String = "Сигнали"
        static let country: String = "България"
        static let abroad: String = "Чужбина"
        
        struct ViolationDetails {
            
            static let status: String = "Статус"
            static let violationId: String = "Сигнал"
            static let location: String = "Локация"
        }
    }
    
    struct Protocols {
        
        static let title: String = "Протоколи"
        
        struct ProtocolDetails {
            
            static let status: String = "Статус"
            static let protocolId: String = "Протокол"
            static let sectionNumber: String = "Номер на секция"
            static let location: String = "Локация"
        }
    }
    
    struct Home {
        
        static let sendProtocol: String = "Изпрати протокол"
        static let sendViolation: String = "Изпрати сигнал"
        static let terms: String = "Права и задължения"
    }
    
    struct Search {
        
        static let searchBarPlaceholder: String = "Избери"
        static let doneButton: String = "Затвори"
    }
    
    struct Errors {
        
        static let defaultError: String = "Възникна грешка. Моля опитайте отново."
        
        static let invalidEmail: String = "Невалиден имейл адрес"
        static let userDisabled: String = "Достъпа до акаунта е временно спрян. Моля опитайте по-късно."
        static let wrongPassword: String = "Невалидна парола. Паролата трябва да съдържа 6 или повече символа."
        static let userNotFound: String = "Не е открит регистриран потребител с въведения имейл адрес."
    }
    
    struct Menu {
        
        static let profile: String = "Профил"
        static let sendProtocol: String = "Изпрати протокол"
        static let sendViolation: String = "Изпрати сигнал"
        static let protocols: String = "Моите протоколи"
        static let violations: String = "Моите сигнали"
        static let terms: String = "Права и задължения"
        static let live: String = "Ти броиш Live"
        static let logout: String = "Изход"
    }
    
    struct Login {
        
        static let emailTitle: String = "Потребител:"
        static let emailPlaceholder: String = "Въведете имейл адрес"
        static let passwordTitle: String = "Парола:"
        static let passwordPlaceholder: String = "Въведете вашата парола"
        static let loginButton: String = "Вход"
        static let registrationButton: String = "Регистрация"
        static let resetPasswordButton: String = "Забравена парола"
    }
    
    struct CommonInputField {
        
        static let firstName: String = "Име:"
        static let firstNamePlaceholder: String = "Въведете вашето име"
        
        static let lastName: String = "Фамилия:"
        static let lastNamePlaceholder: String = "Въведете вашата фамилия"
        
        static let email: String = "Имейл:"
        static let emailPlaceholder: String = "Въведете вашия имейл"
        
        static let phone: String = "Телефон:"
        static let phonePlaceholder: String = "Въведете вашия телефон"
        
        static let organization: String = "Организация:"
        static let organizationPlaceholder: String = "Избери организация"
        
        static let hasAgreedToKeepData: String = """
        Съгласен съм да съхранявате данните ми и за целите на застъпнически кампании за следващите избори (след 04.04.2021).
        Данните ви се съхраняват по подразбиране до 30 дни след изборния ден на база на легитимния интерес на администратора и изискванията на Изборния кодекс.
        """
    }
    
    struct Registration {
        
        static let title: String = "РЕГИСТРАЦИЯ"
        
        static let pin: String = "Последни четири цифри на ЕГН:"
        static let pinPlaceholder: String = "Въведете последни четири цифри"
        
        static let password: String = "Парола:"
        static let passwordPlaceholder: String = "Въведете вашата парола"
        
        static let confirmPassword: String = "Потвърди парола:"
        static let confirmPasswordPlaceholder: String = "Потвърдете вашата парола"

        static let hasAdulthood: String = "Имам навършени 18 години."
        static let registerButton: String = "СЪЗДАЙ ПРОФИЛ"
    }
    
    struct ResetPassword {
        
        static let title: String = "Забравена парола"
        
        static let email: String = "Потребител:"
        static let emailPlaceholder: String = "Въведете вашия имейл"
        
        static let message: String = "За да промените паролата отворете връзката получена на Вашия имейл адрес."
    }
}
