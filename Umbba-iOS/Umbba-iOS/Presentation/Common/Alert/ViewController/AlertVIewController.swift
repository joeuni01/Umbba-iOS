//
//  WriteCancelAlertVIewController.swift
//  Umbba-iOS
//
//  Created by 최영린 on 2023/07/11.
//

import UIKit

enum AlertType {
    case writeCancelAlert
    case writeSaveAlert
    case withdrawalAlert
    case inviteAlert
    case disconnectAlert
}

final class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var alertType: AlertType?
    var okAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let writeCancelAlertView: WriteCancelAlertView = {
        let view = WriteCancelAlertView()
        return view
    }()
    
    private let writeSaveAlertView: WriteSaveAlertView = {
        let view = WriteSaveAlertView()
        return view
    }()
    
    private let withdrawalAlertView: WithdrawalAlertView = {
        let view = WithdrawalAlertView()
        return view
    }()
    
    private let inviteAlertView: InviteAlertView = {
        let view = InviteAlertView()
        return view
    }()
    
    private let disconnectAlertView: DisconnectAlertView = {
        let view = DisconnectAlertView()
        return view
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setUI()
        setAlertType()
        setLayout()
    }
}

// MARK: - Extensions

extension AlertViewController {
    
    func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    func setAlertType() {
        switch alertType {
        case .writeCancelAlert:
            setAlertView(writeCancel: true, writeSave: false, withdrawal: false, invite: false, disconnect: false)
        case .writeSaveAlert:
            setAlertView(writeCancel: false, writeSave: true, withdrawal: false, invite: false, disconnect: false)
        case .withdrawalAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: true, invite: false, disconnect: false)
        case .inviteAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: true, disconnect: false)
        case .disconnectAlert:
            setAlertView(writeCancel: false, writeSave: false, withdrawal: false, invite: true, disconnect: true)
        default:
            break
        }
    }
    
    func setAlertView(writeCancel: Bool, writeSave: Bool, withdrawal: Bool, invite: Bool, disconnect: Bool) {
        writeCancelAlertView.isHidden = !writeCancel
        writeSaveAlertView.isHidden = !writeSave
        withdrawalAlertView.isHidden = !withdrawal
        inviteAlertView.isHidden = !invite
        disconnectAlertView.isHidden = !disconnect
    }
    
    func setLayout() {
        view.addSubviews(writeCancelAlertView,
                         writeSaveAlertView,
                         withdrawalAlertView,
                         inviteAlertView,
                         disconnectAlertView)
        
        writeCancelAlertView.snp.makeConstraints {
            let writeCancelWidth = SizeLiterals.Screen.screenWidth * 343 / 375
            $0.center.equalToSuperview()
            $0.width.equalTo(writeCancelWidth)
            $0.height.equalTo(writeCancelWidth * 164 / 343)
        }
        
        writeSaveAlertView.snp.makeConstraints {
            let writeSaveAlertWidth = SizeLiterals.Screen.screenWidth * 343 / 375
            $0.center.equalToSuperview()
            $0.width.equalTo(writeSaveAlertWidth)
        }
        
        withdrawalAlertView.snp.makeConstraints {
            let withdrawalWidth = SizeLiterals.Screen.screenWidth * 343 / 375
            $0.center.equalToSuperview()
            $0.width.equalTo(withdrawalWidth)
            $0.height.equalTo(withdrawalWidth * 164 / 343)
        }
        
        inviteAlertView.snp.makeConstraints {
            let inviteWidth = SizeLiterals.Screen.screenWidth * 343 / 375
            $0.center.equalToSuperview()
            $0.width.equalTo(inviteWidth)
//            $0.height.equalTo(inviteWidth * 472 / 343)
        }
        
        disconnectAlertView.snp.makeConstraints {
            let disconnectWidth = SizeLiterals.Screen.screenWidth * 343 / 375
            $0.center.equalToSuperview()
            $0.width.equalTo(disconnectWidth)
            $0.height.equalTo(disconnectWidth * 472 / 343)
        }
    }
    
    func setDelegate() {
        writeCancelAlertView.delegate = self
        writeSaveAlertView.delegate = self
        withdrawalAlertView.delegate = self
        inviteAlertView.delegate = self
        disconnectAlertView.delegate = self
    }
    
    func emptyActions() {
        
    }
    
    func setAlertType(_ type: AlertType) {
        self.alertType = type
    }
    
    func setDataBind(wirtePopUp: WritePopUp) {
        if alertType == .writeSaveAlert {
            writeSaveAlertView.cafe24TitleLabel.text = wirtePopUp.section
            writeSaveAlertView.numberLabel.text = wirtePopUp.number
            writeSaveAlertView.themeLabel.text = wirtePopUp.topic
            writeSaveAlertView.questionLabel.text = wirtePopUp.question
            writeSaveAlertView.answerLabel.text = wirtePopUp.answer
        }
    }
    
    func setInviteDataBind(inviteCode: String, inviteUsername: String, installURL: String) {
        if alertType == .inviteAlert {
            inviteAlertView.inviteCode.text = inviteCode
        }
    }
}

// MARK: - AlertDelegate

extension AlertViewController: AlertDelegate {
    func copyButtonTapped(inviteCode: String) {
        UIPasteboard.general.string = inviteCode
        self.showToast(message: "초대코드가 복사되었습니다")
    }
    
    func colorButtonTapped() {
        dismiss(animated: false) {
            (self.okAction ?? self.emptyActions)()
        }
    }
    
    func alertDismissTapped() {
        dismiss(animated: true)
    }
}
