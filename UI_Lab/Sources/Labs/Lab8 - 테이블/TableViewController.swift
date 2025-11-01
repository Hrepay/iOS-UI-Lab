//
//  TableViewController.swift
//  UI_Lab
//
//  Created by 황상환 on 11/1/25.
//

import UIKit

class TableViewController: UIViewController {
    
    // 첫 번째 테이블뷰
    private let firstTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // 두 번째 테이블뷰
    private let secondTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // 데이터
    private let firstTableData = [
        ("나주곰탕+도토리묵+미니밥+단무지", "5,000"),
        ("제육치즈덮밥+콩나물무침+가쓰오장국+깍두기", "5,000"),
        ("청양크림함박스테이크+김치볶음밥+가쓰오장국+단무지", "5,000"),
        ("순대국+깍두기+미니밥", "5,000"),
        ("돈까스+샐러드+미니밥", "5,000")
    ]
    
    private let secondTableData = [
        ("김치찌개+계란말이+밥", "5,000"),
        ("된장찌개+두부구이+밥", "5,000"),
        ("불고기+나물+밥", "5,000"),
        ("비빔밥+계란국", "5,000"),
        ("냉면+만두", "5,000")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupTableViews()
        setupConstraints()
    }
    
    private func setupTableViews() {
        // 첫 번째 테이블뷰 설정
        firstTableView.dataSource = self
        firstTableView.delegate = self
        firstTableView.tag = 0
        firstTableView.backgroundColor = .white
        
        // 두 번째 테이블뷰 설정
        secondTableView.dataSource = self
        secondTableView.delegate = self
        secondTableView.tag = 1
        secondTableView.backgroundColor = .white
        
        view.addSubview(firstTableView)
        view.addSubview(secondTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 첫 번째 테이블뷰
            firstTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            firstTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstTableView.heightAnchor.constraint(equalToConstant: 350),
            
            // 두 번째 테이블뷰
            secondTableView.topAnchor.constraint(equalTo: firstTableView.bottomAnchor, constant: 20),
            secondTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            secondTableView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }
        
        if tableView.tag == 0 {
            let data = firstTableData[indexPath.row]
            cell.configure(menu: data.0, price: data.1)
        } else {
            let data = secondTableData[indexPath.row]
            cell.configure(menu: data.0, price: data.1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MenuHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDelegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 0 {
            print("첫번째 테이블뷰 - \(indexPath.row + 1)번 셀 선택")
        } else {
            print("두번째 테이블뷰 - \(indexPath.row + 1)번 셀 선택")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - MenuCell
class MenuCell: UITableViewCell {
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(menuLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            menuLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 60),
            priceLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -16),
            
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 40),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(menu: String, price: String) {
        menuLabel.text = menu
        priceLabel.text = price
    }
}

// MARK: - MenuHeaderView
class MenuHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "오늘의 메뉴"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "가격"
        label.textAlignment = .right
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "평점"
        label.textAlignment = .center
        return label
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(ratingLabel)
        addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 60),
            priceLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -16),
            
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 40),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // 하단 언더바
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
