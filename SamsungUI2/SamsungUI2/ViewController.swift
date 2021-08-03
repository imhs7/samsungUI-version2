//
//  ViewController.swift
//  SamsungUI2
//
//  Created by Hemant Sharma on 04/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var tableView : UITableView = {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        return myTableView
    }()
    
    var productDetail = [Products]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        styleView()
        fetchProductDetails { result in
        }
    }
    
    func fetchProductDetails(completion: @escaping (ProductModel?) -> Void) {
        
        let urlString = "https://www.blibli.com/backend/search/products?searchTerm=Samsung"
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
             do {
                let result = try JSONDecoder().decode(ProductModel.self, from: data!)
                
                if let productArray = result.data?.products {

                    DispatchQueue.main.async {
                        self.productDetail = productArray
                        self.tableView.reloadData()
                    }
                }
                completion(nil)
            }
            catch {
                completion(nil)
            }
            
        }
        task.resume()
    }
}

extension ViewController {
    private func setUpTableView() {
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func styleView() {

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self)) as! ProductTableViewCell
        
        let productImage = productDetail[indexPath.row].images?[0]
        let productName = productDetail[indexPath.row].name
        let productPrice = productDetail[indexPath.row].price?.priceDisplay
        let productOfferPrice = productDetail[indexPath.row].price?.offerPriceDisplay
        let productStrikeThroughDisplay = productDetail[indexPath.row].price?.strikeThroughPriceDisplay
        
        cell.configure(images: productImage, name: productName, priceDisplay: productPrice, offerPriceDisplay: productOfferPrice, strikeThroughPriceDisplay: productStrikeThroughDisplay)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
