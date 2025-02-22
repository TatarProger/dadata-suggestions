//
//  ViewController.swift
//  Dadata-demo
//
//  Created by Rishat Zakirov on 05.02.2025.
//
import UIKit
import SnapKit

class SearchAddressViewController: UIViewController {
    
    let addressService = AddressService()
    var addresses:[SuggestAddress] = []
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес доставки"
        return label
    }()
    
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0);
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressCell.self, forCellReuseIdentifier: AddressCell.reuseId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        observe()
        
    }
    
    @objc func fetchAddressSuggestions() {
        guard let searchText = searchTextField.text else { return }
        addressService.loadSuggestions(query: searchText) { result in
            switch result {
            case .success(let suggestAdresses):
                self.addresses = suggestAdresses
                self.tableView.reloadData()
                print(suggestAdresses)
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func observe() {
        searchTextField.addTarget(nil, action: #selector(addressTextFieldChanged(_:)), for: .editingChanged)
    }
    
    var timer: Timer?
    var delayValue: Double = 1.5
    
    
    @objc func addressTextFieldChanged(_ sender: UITextField) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: delayValue, target: self, selector: #selector(fetchAddressSuggestions), userInfo: nil, repeats: false)
    }
}

extension SearchAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.reuseId, for: indexPath) as? AddressCell else {return UITableViewCell()}
        cell.update(address: addresses[indexPath.row])
        
        return cell
    }
}

extension SearchAddressViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
    }
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(view)
        }
    }
}
