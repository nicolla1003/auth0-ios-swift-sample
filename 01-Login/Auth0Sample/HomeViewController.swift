// HomeViewController.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Lock

class HomeViewController: UIViewController {
    
    // MARK: - IBAction
    
    @IBAction func showLoginController(sender: UIButton) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.onAuthenticationBlock = { profile, token in
            guard let userProfile = profile else {
                self.showMissingProfileAlert()
                return
            }
            self.retrievedProfile = userProfile
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("ShowProfile", sender: nil)
        }
        controller.onUserDismissBlock = {
            //The user dismisses the Login screen
        }
        A0Lock.sharedLock().presentLockController(controller, fromController: self)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let profileController = segue.destinationViewController as? ProfileViewController else {
            return
        }
        profileController.profile = self.retrievedProfile
    }
    
    // MARK: - Private
    
    private var retrievedProfile: A0UserProfile!
    
    private func showMissingProfileAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
