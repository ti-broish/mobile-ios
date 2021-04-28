//
//  LocalizedStrings.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

struct LocalizedStrings {
    
    static let menu: String = "Меню"
    static let back: String = "Назад"
    
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
    
    struct Registration {
        
        static let firstName: String = "Име:"
        static let firstNamePlaceholder: String = "Въведете вашето име"
        
        static let lastName: String = "Фамилия:"
        static let lastNamePlaceholder: String = "Въведете вашата фамилия"
        
        static let email: String = "Имейл:"
        static let emailPlaceholder: String = "Въведете вашия имейл"
        
        static let phone: String = "Телефон:"
        static let phonePlaceholder: String = "Въведете вашия телефон"
        
        static let pin: String = "Последни четири цифри на ЕГН:"
        static let pinPlaceholder: String = "Въведете последни четири цифри"
        
        static let organization: String = "Организация:"
        
        static let password: String = "Парола:"
        static let passwordPlaceholder: String = "Въведете вашата парола"
        
        static let confirmPassword: String = "Потвърди парола:"
        static let confirmPasswordPlaceholder: String = "Потвърдете вашата парола"
        
        static let hasAgreedToKeepData: String = """
        Съгласен съм да съхранявате данните ми и за целите на застъпнически кампании за следващите избори (след 04.04.2021).
        Данните ви се съхраняват по подразбиране до 30 дни след изборния ден на база на легитимния интерес на администратора и изискванията на Изборния кодекс.
        """
        
        static let hasAdulthood: String = "Имам навършени 18 години."
    }
}
