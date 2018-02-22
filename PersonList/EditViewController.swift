//
//  EditViewController.swift
//  SubclassingSingleEntityModel
//
//  Created by Mazharul Huq on 1/18/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var employedFlag: UISwitch!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var popularityChoice: UISegmentedControl!
    @IBOutlet weak var imageChoice: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var managedContext:NSManagedObjectContext!
    var person:Person?
    
    var dob:Date!
    var ageValue:Int!
    var image:UIImage!
    var dateFormatter:DateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let person = self.person{
            enterPersonInfo(person)
        }
        else{
            imageChoice.selectedSegmentIndex = 0
            let imageFile = "image1"
            image = UIImage(named: imageFile)
            imageView.image = image
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameField{
            let text = textField.text
            if text?.trimmingCharacters(in: .whitespaces) == ""{
                return false
            }
        }
        guard let date = dateFormatter.date(from: textField.text!) else{
            return false
        }
        ageValue = getAge(date)
        age.text = "age: \(ageValue!)"
        return true
    }
    
    func enterPersonInfo(_ person:Person){
    
        if let name = person.name{
            self.nameField.text = name
        }
        if let dob = person.dateOfBirth{
            self.dobField.text = dateFormatter.string(from: dob as Date)
        }
        
        if let age = getAge(person.dateOfBirth as Date?) {
            self.age.text = "age: \(age)"
        }
        
        employedFlag.isOn = person.employed
        
        popularityChoice.selectedSegmentIndex = Int(person.popularity*5)
        
        imageView.image = UIImage(data: person.favImage! as Data)
        
        getColorComponents(person.favColor as! UIColor)
        colorView.backgroundColor = person.favColor as? UIColor
    }

    func getAge (_ date:Date?)->Int?{
        let CurrentDate = Date()
        guard let date = date else{
            return nil
        }
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: CurrentDate, options: [])
        let age = components.year
        return age
    }
    
    //Extracts RGB color components from UIColor
    func getColorComponents(_ color:UIColor){
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            redSlider.value = Float(r)
            greenSlider.value = Float(g)
            blueSlider.value = Float(b)
        }
    }
    
    //Creates color from RGB
    func colorFromRGB()-> UIColor{
        let red = redSlider.value
        let green = greenSlider.value
        let blue = blueSlider.value
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
        return color
    }
    
    
    @IBAction func imageSelected(_ sender: AnyObject) {
        let seg = sender as! UISegmentedControl
        let imageFile = "image\(seg.selectedSegmentIndex + 1)"
        image = UIImage(named: imageFile)
        imageView.image = image
    }
    
    @IBAction func redChanged(_ sender: AnyObject) {
        colorView.backgroundColor = colorFromRGB()
    }
    
    @IBAction func greenChanged(_ sender: AnyObject) {
        colorView.backgroundColor = colorFromRGB()
    }
    
    @IBAction func blueChanged(_ sender: AnyObject) {
        colorView.backgroundColor = colorFromRGB()
    }
    @IBAction func saveTapped(_ sender: AnyObject) {
        var personToSave:Person
        if let person = person{
            personToSave = person
        }
        else
        {
            
            //Uses initializer to create an instance of Person
            personToSave = Person(context: self.managedContext)
        }
        //Set the attributes of the entity
        personToSave.name = nameField.text
        
        personToSave.dateOfBirth = dateFormatter.date(from: dobField.text!) as NSDate?
        if let age = ageValue{
            personToSave.age = Int16(age)
        }
        
        personToSave.employed = employedFlag.isOn
        
        personToSave.popularity = Double(popularityChoice.selectedSegmentIndex)/5.0
        
        personToSave.favColor = colorFromRGB()
        if let im = image{
            personToSave.favImage = UIImagePNGRepresentation(im)! as NSData
        }
        //Save context
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            }
            catch {
                let nserror = error as NSError
                print("Could not save \(nserror),(nserror.userInfo)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    

}
