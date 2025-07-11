//
//  ViewController.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // 커스텀 하단 탭바 (가운데가 파인 곡선 형태)
    private let customTabBar = CustomTabBar()
    
    // 중앙 플로팅 버튼 (탭바 위에 살짝 떠 있음)
    private let floatingButton = UIButton(type: .custom)

    // 탭바 내부 왼쪽 버튼 (예: 차트)
    private let leftButton = UIButton(type: .custom)

    // 탭바 내부 오른쪽 버튼 (예: 프로필)
    private let rightButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLabel()    // 중앙 라벨
        setupTabBar()   // 하단 커스텀 탭바
        setupButtons()  // 좌/우/중앙 버튼 배치
    }

    // 중앙에 설명 텍스트 표시
    private func setupLabel() {
        let label = UILabel()
        label.text = "UIKit 기반 프로젝트입니다!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // 커스텀 탭바 하단에 고정
    private func setupTabBar() {
        view.addSubview(customTabBar)
        customTabBar.backgroundColor = .clear
        customTabBar.clipsToBounds = false // 그림자 표시 허용

        customTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(90)
        }
    }

    // 좌/우 버튼은 탭바 내부에, 중앙 플로팅 버튼은 탭바 위에
    private func setupButtons() {
        // 중앙 플로팅 버튼 설정
        let homeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "house.fill", withConfiguration: homeConfig)?
            .withRenderingMode(.alwaysTemplate)

        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = .gray
        floatingButton.backgroundColor = .white
        floatingButton.layer.cornerRadius = 31.5
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingButton.layer.shadowRadius = 5

        // 탭바 바깥 view에 올려서 위로 띄움
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(customTabBar.snp.top).offset(28)
            $0.width.height.equalTo(65)
        }

        // 왼쪽 버튼 설정 (탭바 내부에 추가)
        let leftconfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let leftImage = UIImage(systemName: "chart.bar.fill", withConfiguration: leftconfig)
        leftButton.setImage(leftImage, for: .normal)
        leftButton.tintColor = .gray
        customTabBar.addSubview(leftButton)

        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(65)
            $0.width.height.equalTo(50)
        }
        
        // 오른쪽 버튼 설정 (탭바 내부에 추가)
        let rightconfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let rightImage = UIImage(systemName: "person.fill", withConfiguration: rightconfig)
        rightButton.setImage(rightImage, for: .normal)
        rightButton.tintColor = .gray
        customTabBar.addSubview(rightButton)

        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-5)
            $0.trailing.equalToSuperview().offset(-65)
            $0.width.height.equalTo(50)
        }
    }
}
