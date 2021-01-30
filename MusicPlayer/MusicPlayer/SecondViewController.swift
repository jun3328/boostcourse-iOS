//
//  SecondViewController.swift
//  MusicPlayer
//
//  Created by lee on 2021/01/29.
//

import UIKit

class SecondViewController: UIViewController {
    
    lazy var myTableView = { () -> UITableView in
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        // 코드로 제약조건을 추가할 시에는, 뷰 자체적으로 수행하는 오토리사이징을 꺼야 함(사용자 지정 제약조건과 충돌)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let items = ["Objective-c", "Swift", "iOS", "Java", "Kotlin", "Android", "Dart", "Flutter"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            myTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        // Do any additional setup after loading the view.
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        var alert = UIAlertController(title: "아이템 정보", message: "선택된 아이템은 \(item) 입니다.", preferredStyle: .alert)
        
        if indexPath.row % 2 == 0 {
            alert = UIAlertController(title: "아이템 정보", message: "선택된 아이템은 \(item) 입니다.", preferredStyle: .actionSheet)
        }
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "destructive", style: .destructive))
        
        present(alert, animated: true)
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}


#if DEBUG
import SwiftUI

struct SecondViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // no-op
    }
    
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        return SecondViewController()
    }
}

struct MainViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        SecondViewControllerRepresentable()
            .previewDisplayName("아이폰 12")
    }
}

#endif
