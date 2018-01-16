//
//  TelaSettingsViewController.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 26/09/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit

class SettingsControllerView : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var uiScrollViewForm: UIScrollView?
    @IBOutlet var uiTextFieldsSettings: [UITextField]?
    
    @IBOutlet weak var uiFieldName: UITextField?
    @IBOutlet weak var uiFieldEmailAccount: UITextField?
    @IBOutlet weak var uiFieldPassword: UITextField?
    @IBOutlet weak var uiFieldPhoneNumber: UITextField?
    @IBOutlet weak var uiUserPhoto: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let fields = self.uiTextFieldsSettings else {
            return
        }
        
        for field in fields {
          guard let identifierField = field.restorationIdentifier else {
              return
          }
            
          let imageField = UIImageView(frame: CGRect(x:10, y:0, width:20, height:20))
              imageField.image = UIImage(named:"field\(identifierField)")
            
          let view   = UIView()
              view.frame = CGRect(x:0, y:0, width:60, height:20)
              view.layer.borderColor = UIColor.clear.cgColor
              view.layer.borderWidth = 10
            
          view.addSubview(imageField)
          field.leftView     = view
          field.leftViewMode = .always
          field.textAlignment = .justified
        }
    
        App.shared.getUserLogged { (user) in
            guard let u = user else {
                return
            }
            
            self.uiFieldName?.text = "\(u.first_name) \(u.last_name)"
            self.uiFieldEmailAccount?.text = "\(u.email_account)"
            self.uiFieldPassword?.text    = "12345678"
            self.uiFieldPhoneNumber?.text = "\(u.number_phone)"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let fieldName  = self.uiFieldName,
              let fieldEmail = self.uiFieldEmailAccount,
              let fieldPassword    = self.uiFieldPassword,
              let fieldPhoneNumber = self.uiFieldPhoneNumber
            else {
            return true
        }
        
        let mapFieldsContinue:[UITextField:UITextField?] = [
            fieldName : fieldEmail,
            fieldEmail : fieldPassword,
            fieldPassword : fieldPhoneNumber,
            fieldPhoneNumber : nil
        ]
        
        if let nextField = mapFieldsContinue[textField],
           let destiny   = nextField {
               destiny.becomeFirstResponder()
        }else{
           textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func tapSaveInformationUser(_ sender: UIButton) {
        guard let fieldName = self.uiFieldName,
              let fieldEmailAccount = self.uiFieldEmailAccount,
              let fieldPassword    = self.uiFieldPassword,
              let fieldPhoneNumber = self.uiFieldPhoneNumber
            else {
            return
        }
        
        App.shared.getUserLogged { (user) in
            guard let u = user else {
                return
            }
            let worlds = fieldName.text?.components(separatedBy: " ")
            
            var user:[String:Any] = [:]
            user["id_user"] = u.user_id
            user["nome"]    = worlds?.first
            user["sobrenome"]  = worlds?.last
            user["localidade"] = u.locality
            user["uf"]      = u.uf
            user["numero_telefone"] = fieldPhoneNumber.text
            user["email"]    = fieldEmailAccount.text
            user["pontos"]   = u.points
            user["keypass"]  = fieldPassword.text
           
            App.shared.setUserLogged(information: user, { (save) in
               if save {
                  let sucessAlert = UIAlertController(title: "Atualizar informações", message: "Informações atualizadas com Sucesso!", preferredStyle: .alert)
                  let sucessAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                  sucessAlert.addAction(sucessAlertAction)
                  self.present(sucessAlert, animated: true, completion: nil)
               }
            })
        }
    }
    
    @IBAction func tapAbrirMenuPrincipal(_ sender: UIButton) {
        ControllerSideMenu.controller.createMainMenu(self)
    }
}

extension SettingsControllerView : UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate {
    
    @IBAction func uiChosePhotoUser(_ sender: UIButton) {
        let baseAlert = UIAlertController(title: "Carregar Foto", message: "Escolha uma das opções para carregar\n uma imagem ao perfil", preferredStyle: .actionSheet)
        
        let actionBaseAlertGalery = UIAlertAction(title: "Escolher foto", style: .default)
            { (_) in
            self.choseGalery()
        }
        
        let actionBaseAlertCamera = UIAlertAction(title: "Tirar foto", style: .default)
            { (_) in
            self.choseCamera()
        }
        
        let actionBaseAlertCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        baseAlert.addAction(actionBaseAlertGalery)
        baseAlert.addAction(actionBaseAlertCamera)
        baseAlert.addAction(actionBaseAlertCancel)
        self.present(baseAlert, animated: true, completion: nil)
    }
    
    func choseGalery() -> Void {
        let galeryPickerView = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(
           UIImagePickerControllerSourceType.photoLibrary) {
            galeryPickerView.sourceType    = .photoLibrary
            galeryPickerView.allowsEditing = true
        }
        galeryPickerView.delegate   = self
        self.present(galeryPickerView, animated: true, completion: nil)
    }
    
    func choseCamera() -> Void {
        let cameraPickerView = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(
           UIImagePickerControllerSourceType.camera) {
           cameraPickerView.sourceType = .camera
           cameraPickerView.delegate   = self
           cameraPickerView.allowsEditing   = true
           cameraPickerView.cameraFlashMode = .auto
        }
        self.present(cameraPickerView, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
         [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage ?? (info[UIImagePickerControllerEditedImage] as? UIImage) else {
            return
        }
        
        self.uiUserPhoto?.contentMode = .scaleAspectFill
        self.uiUserPhoto?.setBackgroundImage(originalImage, for: .normal)
    }
}

extension SettingsControllerView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let photo = self.uiUserPhoto else {
            return
        }
        
        let photoWidth = photo.frame.size.width
        
        photo.center.x   = self.view.center.x
        photo.frame.size = CGSize(width: 140.0, height: 140.0)
        photo.layer.cornerRadius = photoWidth * 0.5
        
        if scrollView.contentOffset.y < 1.0 {
           let photoWidthOriginal = photo.frame.size.width
           var yValueScroll = scrollView.contentOffset.y
        
           UIView.animate(withDuration: 0.4, animations: {
              photo.alpha = 1.0
           }, completion: { (_) in
              yValueScroll     = CGFloat(Int(yValueScroll) * -1)
              yValueScroll     = min(yValueScroll + photoWidthOriginal,280)
              photo.frame.size = CGSize(width: yValueScroll, height: yValueScroll)
              photo.center.x   = self.view.center.x
           })
        }else{
            UIView.animate(withDuration: 0.4, animations: {
               photo.alpha = 1.0
            }, completion: { (_) in
               photo.center.x   = self.view.center.x
               photo.frame.size = CGSize(width: 140.0, height: 140.0)
            })
        }
    }
}

