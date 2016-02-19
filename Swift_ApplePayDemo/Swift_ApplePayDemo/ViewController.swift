//
//  ViewController.swift
//  Swift_ApplePayDemo
//
//  Created by Will Wang on 16/2/19.
//  Copyright © 2016年 WEL. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let isSupportPay: Bool = PKPaymentAuthorizationViewController.canMakePayments()
        if !isSupportPay {
            return;
        }else{
            //do something
        }
        
        let netWork: Array = [PKPaymentNetworkPrivateLabel,PKPaymentNetworkVisa,PKPaymentNetworkMasterCard]
        
        let canPay: Bool = PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(netWork)
        
        if !canPay {
            
            //setup
            let setupButton = PKPaymentButton(type: PKPaymentButtonType.SetUp, style: PKPaymentButtonStyle.Black)
            setupButton.addTarget(self, action: "applePaySetupButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(setupButton)
            setupButton.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, 150)
            
        } else {
            
            //PKPaymentRequest
            let paymentRequest = PKPaymentRequest()
            
            paymentRequest.currencyCode = "CNY"
            paymentRequest.countryCode = "CN"
            
            // merchantIdentifier
            paymentRequest.merchantIdentifier = "merchant.com.hunk.assistants"
            paymentRequest.merchantCapabilities = [PKMerchantCapability.Capability3DS,PKMerchantCapability.CapabilityEMV]
            paymentRequest.requiredShippingAddressFields = PKAddressField.All
            //support Networks
            paymentRequest.supportedNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]

            //subtotal
            let subTotal = PKPaymentSummaryItem(label: "Subtotal", amount: NSDecimalNumber(string: "101.00"))
            //discount
            let dicount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: "100.00"))
            //tax
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "2.00"))

            paymentRequest.paymentSummaryItems = [subTotal,dicount,tax]
            
            //show the apple pay controller
            let payAuth = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            payAuth.delegate = self
            self.presentViewController(payAuth, animated: true, completion: nil)
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PKPaymentAuthorizationViewControllerDelegate

    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        NSLog("%@", NSString(data:payment.token.paymentData, encoding:NSUTF8StringEncoding)!)
        
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applePaySetupButtonPressed(sender: PKPaymentButton) {
        PKPassLibrary.init().openPaymentSetup()
    }
}

