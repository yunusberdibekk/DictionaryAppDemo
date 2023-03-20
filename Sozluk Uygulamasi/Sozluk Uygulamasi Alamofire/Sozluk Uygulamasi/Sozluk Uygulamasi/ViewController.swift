//
//  ViewController.swift
//  Sozluk Uygulamasi
//
//  Created by Yunus Emre Berdibek on 26.02.2023.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var kelimeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var kelimeListesi = [Kelimeler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        kelimeTableView.delegate = self
        kelimeTableView.dataSource = self
        
        searchBar.delegate = self
        
        tumKelimelerAl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        let k = kelimeListesi[indeks!]
        
        let gidilecekVC = segue.destination as! KelimeDetayViewController
        gidilecekVC.kelime = k
    }
    
    func tumKelimelerAl(){
        
        AF.request("http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php", method: .get).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data)
                    
                    if let gelenKelimeListesi = cevap.kelimeler {
                        self.kelimeListesi = gelenKelimeListesi
                    }
                    
                    DispatchQueue.main.async {
                        self.kelimeTableView.reloadData()
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func aramaYap (arananKelime:String) {
        
        let params: Parameters = ["ingilizce":arananKelime] //arama yapılacak kelime
        
        AF.request("http://kasimadalan.pe.hu/sozluk/kelime_ara.php", method: .post, parameters: params).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data)
                    
                    if let gelenKelimeListe = cevap.kelimeler {
                        
                        self.kelimeListesi = gelenKelimeListe
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.kelimeTableView.reloadData() //arayüzü güncelleme
                        
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelimeHucre", for: indexPath) as! KelimeHucreTableViewCell
        
        cell.ingilizceLabel.text = kelime.ingilizce
        cell.turkceLabel.text = kelime.turkce
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toKelimeDetay", sender: indexPath.row)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        aramaYap(arananKelime: searchText)
    }
}

