//
//  ViewController.swift
//  TableViewDifferentiable
//
//  Created by Alcivanio on 2021-02-06.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var dataSource = makeDataSource()
    
    let cellIdentifier = "PERSON_CELL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = dataSource
        
        updatePeople(people: generatePersons())
    }
    
    
    func generatePersons() ->[Person] {
        var list = [Person]()
        
        list.append(Person(name: "Samara", lastName: "Lois", country: .brazil))
        list.append(Person(name: "Hei", lastName: "231", country: .brazil))
        list.append(Person(name: "Louis", lastName: "rwqwwqw", country: .unitedStates))
        list.append(Person(name: "lucas", lastName: "00000", country: .canada))
        list.append(Person(name: "Samanta", lastName: "86666", country: .brazil))
        list.append(Person(name: "Karol", lastName: "3453452", country: .canada))
        list.append(Person(name: "Jenniger", lastName: "456456", country: .unitedStates))
        list.append(Person(name: "Sam", lastName: "0390", country: .brazil))
        list.append(Person(name: "Dois", lastName: "12333", country: .canada))
        
        
        return list
        
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = NSDiffableDataSourceSnapshot<PersonCountry, Person>()
        
        snapshot.appendSections(PersonCountry.allCases)
        snapshot.appendItems(people.filter({ $0.country == .brazil }), toSection: .brazil)
        snapshot.appendItems(people.filter({ $0.country == .unitedStates }), toSection: .unitedStates)
        snapshot.appendItems(people.filter({ $0.country == .canada }), toSection: .canada)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        
    }
    
    
    
    
    

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let person = dataSource.itemIdentifier(for: indexPath) else { return }
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems([person])
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.updatePeople(people: self.generatePersons())
        }
        
    }
    
}

extension ViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<PersonCountry, Person> {
        return UITableViewDiffableDataSource(tableView: tableView) { (tb, index, person) -> UITableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! PersonCell
            cell.name.text = person.name
            cell.lastName.text = person.lastName
            return cell
        }
    }
}

