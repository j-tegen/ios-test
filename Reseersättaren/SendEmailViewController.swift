//
//  SendEmailViewController.swift
//  Reseersättaren
//
//  Created by Jonatan Tegen on 2018-09-06.
//  Copyright © 2018 Jonatan Tegen. All rights reserved.
//

import UIKit
import MessageUI

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var EmailTextInput: UITextView!
    
    var name: String?
    var socialSecurity: String?
    var fromStation: String?
    var toStation: String?
    var expectedArrival: String?
    var actualArrival: String?
    var bank: String?
    var clearingNumber: String?
    var account: String?
    var paymentType: String?
    
    var emailText: String?
    
    
    @IBAction func SendEmail(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
  
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let emailSubject: String! = "Reklamation av resa"
        let emailRecipient: [String]! = ["info@skanetrafiken.se"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setSubject(emailSubject)
        mc.setMessageBody(emailText!, isHTML: false)
        mc.setToRecipients(emailRecipient)

        return mc
    }
    
    //UIAlertView är deprecated sedan iOS 9. Denna bör vi byta/tabort
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailText = """
        Hej,
        
        Jag söker härmed ersättning för tåget mellan
        \(String(describing: fromStation!)) to \(String(describing: String(describing: toStation!)))
        som skulle ankommit \(String(describing: expectedArrival!)), men inte kom fram förrän \(String(describing: String(describing: actualArrival!))).
        Jag köpte biljetten via \(String(describing: String(describing: paymentType!))) och vill ha kontant ersättning insatt på min bank enligt nedan:
        Bank: \(String(describing: bank!))
        Clearingnummer: \(String(describing: clearingNumber!))
        Bank: \(String(describing: account!))
        Personnummer: \(socialSecurity!)
        
        Hälsningar
        \(String(describing: name!))
        """
        
        EmailTextInput.text = emailText
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
