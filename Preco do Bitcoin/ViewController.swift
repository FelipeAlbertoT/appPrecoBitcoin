//
//  ViewController.swift
//  Preco do Bitcoin
//
//  Created by 5A Nucleo Desenvolvimento on 20/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.consultarPreco()
        
    }

    @IBAction func atualizar(_ sender: Any) {
        self.consultarPreco()
    }
    
    func formatar(preco: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        if let precoFormatado = nf.string(from: preco) {
            return precoFormatado
        }
        return "0,00"
    }
    
    func consultarPreco() {
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            if let url = URL(string: "https://blockchain.info/pt/ticker") {
                let tarefa = URLSession.shared.dataTask(with: url) { (dataResult, response, error) in
                    if error == nil {
                        
                        if let dados = dataResult {
                            do {
                                if let objetoJson = try JSONSerialization.jsonObject(with: dados, options: []) as? [String:Any] {
                                    if let brl = objetoJson["BRL"] as? [String:Any]{
                                        if let preco = brl["last"] as? Double {
                                            let precoFormatado = self.formatar(preco: NSNumber(value: preco))
                                            
                                            DispatchQueue.main.async {
                                                self.labelPreco.text = "R$ " + precoFormatado
                                                self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                            }
                                        }
                                    }
                                }
                            } catch {
                                print("Erro ao formatar retorno")
                            }
                        }
                        
                    } else {
                        print("Erro")
                    }
                }
                tarefa.resume()
            }
        }
    }
    
    
}

