//
//  MainViewController.swift
//  Umbba-iOS
//
//  Created by 고아라 on 2023/07/14.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare
import FirebaseDynamicLinks

protocol PopUpDelegate: AnyObject {
    func showInvitePopUP(inviteCode: String)
    func showDisconnectPopUP()
}

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var caseEntity: CaseEntity? {
        didSet {
            fetchData()
        }
    }
    
    private var mainEntity: MainEntity? {
        didSet {
            fetchData()
        }
    }
    var inviteCode: String = ""
    var inviteUserName: String = ""
    
    weak var delegate: PopUpDelegate?
    
    // MARK: - UI Components
    
    private let mainView = MainView()
    //    private let tabBar = TabBarController()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMainAPI()
        getCaseAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        getCaseAPI()
        getMainAPI()
    }
}

private extension MainViewController {
    func setDelegate() {
        mainView.mainDelegate = self
    }
    
    func fetchData() {
        guard let mainEntity = mainEntity else { return }
        mainView.setDataBind(model: mainEntity)
        if SizeLiterals.Screen.deviceRatio > 0.5 {
            mainView.setSEImageBind(model: mainEntity)
        } else {
            mainView.setImageBind(model: mainEntity)
        }
        
        if mainEntity.index > 7 {
            getEndingPage()
        } else {
            return
        }
    }
    
    func setNextController() {
        switch caseEntity?.responseCase {
        case 1:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first else {
                return
            }
            let answerDetailController = AnswerDetailViewController()
            answerDetailController.isHome = true
            keyWindow.rootViewController = UINavigationController(rootViewController: answerDetailController)
            if let navigationController = keyWindow.rootViewController as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        case 2:
            guard let inviteCode = caseEntity?.inviteCode  else { return }
            guard let inviteUsername = caseEntity?.inviteUsername else { return }
            guard let installURL = caseEntity?.installURL else { return }
            NotificationCenter.default.post(name: Notification.Name("share"), object: nil, userInfo: ["inviteCode": inviteCode, "inviteUserName": inviteUsername, "installURL": installURL])
        case 3:
            NotificationCenter.default.post(name: Notification.Name("disconnect"), object: nil, userInfo: nil)
        default:
            break
        }
    }
}

extension MainViewController: MainDelegate {
    func questionButtonTapped() {
        getCaseAPI()
        setNextController()
    }
}

// MARK: - Network

private extension MainViewController {
    func getMainAPI() {
        HomeService.shared.getHomeAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<MainEntity> {
                    if let mainData = data.data {
                        self.mainEntity = mainData
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
}

extension MainViewController {
    func getCaseAPI() {
        HomeService.shared.getCaseAPI { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<CaseEntity> {
                    if let caseData = data.data {
                        self.caseEntity = caseData
                        self.inviteUserName = caseData.inviteUsername ?? ""
                        self.inviteCode = caseData.inviteCode ?? ""
                    }
                }
            case .requestErr, .serverErr:
                self.makeAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            default:
                break
            }
        }
    }
}

extension MainViewController {
    func getEndingPage() {
        let nav = EndingViewController()
        nav.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nav, animated: false)
    }
}
