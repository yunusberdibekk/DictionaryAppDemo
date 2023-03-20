//
//  ViewController.swift
//  Sozluk Uygulamasi
//
//  Created by Yunus Emre Berdibek on 26.02.2023.
//

import UIKit

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
    
    func tumKelimelerAl () { //GET İşlemi yapılıyor.
        let url = URL(string: "http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php")!
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            
            if error != nil || data == nil {
                print("Hata")
                return
            } else{
                
                do {
                    let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data!)
                    
                    if let gelenKelimeListesi = cevap.kelimeler {
                        self.kelimeListesi = gelenKelimeListesi
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.kelimeTableView.reloadData()
                        
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
    }
    
    func aramaYap (aramaKelimesi:String) {
        
        var request = URLRequest(url: URL(string:"http://kasimadalan.pe.hu/sozluk/kelime_ara.php")!)
        
        request.httpMethod = "POST" //Türü belirlendi
        
        let postString = "ingilizce=\(aramaKelimesi)"//gönderilecek olan veri
        
        request.httpBody = postString.data(using: .utf8) //request'e eklendi
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
            if error != nil || data == nil {
                print("Hata")
                return
            } else{
                
                do {
                    let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data!)
                    
                    if let gelenKelimeListesi = cevap.kelimeler {
                        self.kelimeListesi = gelenKelimeListesi
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.kelimeTableView.reloadData() //arayüzü güncelleme
                        
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
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
        
        aramaYap(aramaKelimesi: searchText)
    }
}

