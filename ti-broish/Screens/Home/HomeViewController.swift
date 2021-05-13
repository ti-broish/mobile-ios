//
//  HomeViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit
import Firebase

final class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        APIClient().getCountries(isAbroad: true) { response in
//            switch response {
//            case .success(let countries):
//                print("getCountries.success: \(countries)")
//            case .failure(let error):
//                print("getCountries.failure: \(error)")
//            }
//        }
        
//        APIClient().getUserDetails() { response in
//            switch response {
//            case .success(let details):
//                print(".success: \(details)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getElectionRegions(isAbroad: true) { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getTowns(
//            country: Country(code: "00", name: "", isAbroad: false),
//            electionRegion: ElectionRegion(code: "01", name: "", isAbroad: false, municipalities: []),
//            municipality: Municipality(code: "03", name: "")
//        ) {
//            response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getSections(town: Town(id: 17, name: "", cityRegions: [])) { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().sendViolation(
//            town: Town(id: 17, name: "", cityRegions: []),
//            pictures: [],
//            description: "some violation description",
//            section: nil
//        ) { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getViolations { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getViolation(id: "01F5KRQ131T2MJSK5KT4C14KA8") { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getProtocols { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }

//        APIClient().getProtocol(id: "01F201PFGJ2HN570EMNEA57W34")  { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }
        
//        APIClient().sendProtocol(
//            section: Section(id: "010300001", code: "001", place: "", name: ""),
//            pictures: ["01F201PEZP2TVP3NFV0Z5JPFMW"]
//        ) { response in
//            switch response {
//            case .success(let data):
//                print(".success: \(data)")
//            case .failure(let error):
//                print(".failure: \(error)")
//            }
//        }
    }

    override func applyTheme() {
        super.applyTheme()
    }
}
