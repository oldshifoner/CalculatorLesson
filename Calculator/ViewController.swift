//
//  ViewController.swift
//  Calculator
//
//  Created by Максим Игоревич on 12.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var currentExpression = CurrentExpression(displayResultOnView: { [weak self] text in
        self?.currentExpressionView.text = text
    })
    
    lazy var viewModel = ViewModel(currentExpression: currentExpression)
    
    override func viewDidLoad() {
        currentExpression.clean()
        super.viewDidLoad()
    }
    
    @IBAction func numberTap(_ sender: UIButton){
        viewModel.addNumber(number: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func operationTap(_ sender: UIButton) {
        viewModel.addOperation(operation: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func cleanTap(_ sender: UIButton) {
        currentExpression.clean()
    }
    @IBAction func equalsTap(_ sender: UIButton) {
        viewModel.culculate()
    }
    
    @IBOutlet weak var currentExpressionView: UILabel!
    
    
}

class CurrentExpression {
    
    private var localValue = ""
    private var displayResultOnView: (String)->()
   
    public var value: String {
        get{return localValue}
        set(value){
            localValue = value
            displayResultOnView(localValue)
        }
    }
    
    public init(displayResultOnView: @escaping (String)->()) {
        self.displayResultOnView = displayResultOnView
    }
    
    public func clean(){
        localValue = ""
        displayResultOnView("0")
    }
    
}

class ViewModel {
    
    private let currentExpression: CurrentExpression
    
    public init(currentExpression: CurrentExpression) {
        self.currentExpression = currentExpression
    }
    
    public func addNumber(number: String){
        currentExpression.value += number
    }
    
    public func addOperation(operation: String){
        currentExpression.value += operation
    }
    
    public func culculate(){
        
        if let result = NSExpression(format: currentExpression.value).expressionValue(with: nil, context: nil) as? Double {
            print(result)
            currentExpression.value = "\(result)"
            }
        else {currentExpression.value = "Error!#@"}
    }

}

