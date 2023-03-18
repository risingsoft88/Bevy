//
//  TermsViewController.swift
//  Bevy
//
//  Created by macOS on 7/10/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TermsViewController: BaseSubViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtContent: UITextView!

    var type: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if (type == 1) { //Copyright Policy
            lblTitle.text = "Copyright\nPolicy"
            txtContent.text = """
            Bevy Mobile App
            (c)2019, Bevy LLC
            All rights reserved
            """
        } else if (type == 2) { //Privacy Policy
            lblTitle.text = "Privacy\nPolicy"
            txtContent.text = """
            Protecting your private information is our priority. This Statement of Privacy applies to www.getbevy.app, the Bevy Mobile Application and Bevy LLC and governs data collection and usage. For the purposes of this Privacy Policy, unless otherwise noted, all references to Bevy LLC include www.getbevy.app, the Bevy Mobile Application and Bevy. The Bevy Mobile Application is a Lifestyle Mobile Application. By using the Bevy Mobile Application, you consent to the data practices described in this statement.
             
            Collection of your Personal Information
            In order to better provide you with products and services offered on our App, Bevy may collect personally identifiable information, such as your:
             
                  - First and Last Name
             
                  - Mailing Address
             
                  - E-mail Address
             
                  - Phone Number
             
                  - Social media account credentials
             
            If you purchase Bevy’s products and services, we collect billing and credit card information. This information is used to complete the purchase transaction.
             
            Bevy may also collect anonymous demographic information, which is not unique to you, such as your:
             
                  - Age
             
                  - Gender
             
                  - Race
             
                  - Political Affiliation
             
                  - Household Income
             
            Please keep in mind that if you directly disclose personally identifiable information or personally sensitive data through Bevy's public message boards, this information may be collected and used by others.

            We do not collect any personal information about you unless you voluntarily provide it to us. However, you may be required to provide certain personal information to us when you elect to use certain products or services available on the App. These may include: (a) registering for an account on our Site; (b) entering a sweepstakes or contest sponsored by us or one of our partners; (c) signing up for special offers from selected third parties; (d) sending us an email message; (e) submitting your credit card or other payment information when ordering and purchasing products and services on our Site. To wit, we will use your information for, but not limited to, communicating with you in relation to services and/or products you have requested from us. We also may gather additional personal or non-personal information in the future.
             
            Use of your Personal Information
            Bevy collects and uses your personal information to operate its App(s) and deliver the services you have requested.
             
            Bevy may also use your personally identifiable information to inform you of other products or services available from Bevy and its affiliates.
             
            Sharing Information with Third Parties
            Bevy does not sell, rent or lease its customer lists to third parties.
             
            Bevy may share data with trusted partners to help perform statistical analysis, send you email or postal mail, provide customer support, or arrange for deliveries. All such third parties are prohibited from using your personal information except to provide these services to Bevy, and they are required to maintain the confidentiality of your information.
             
            Bevy may disclose your personal information, without notice, if required to do so by law or in the good faith belief that such action is necessary to: (a) conform to the edicts of the law or comply with legal process served on Bevy or the App; (b) protect and defend the rights or property of Bevy; and/or (c) act under exigent circumstances to protect the personal safety of users of Bevy, or the public.
             
            Tracking User Behavior
            Bevy may keep track of the areas and pages our users visit within the Bevy Mobile Application, in order to determine what Bevy services are the most popular. This data is used to deliver customized content and advertising within the Bevy Mobile Application to customers whose behavior indicates that they are interested in a particular subject area.
             
            The Bevy App tracks user preferences in an effort to funnel relevant information, news, and other targeted media based on these preferences provided by users.
             
            Automatically Collected Information
            Information about your computer hardware and software and/ or smartphone may be automatically collected by Bevy. This information can include: your IP address, browser type, domain names, access times and referring website addresses. This information is used for the operation of the service, to maintain quality of the service, and to provide general statistics regarding use of the Bevy website and Mobile Application.
             
            Use of Cookies
            The Bevy website may use "cookies" to help you personalize your online experience. A cookie is a text file that is placed on your hard disk by a web page server. Cookies cannot be used to run programs or deliver viruses to your computer. Cookies are uniquely assigned to you, and can only be read by a web server in the domain that issued the cookie to you.
             
            One of the primary purposes of cookies is to provide a convenience feature to save you time. The purpose of a cookie is to tell the Web server that you have returned to a specific page. For example, if you personalize Bevy pages, or register with Bevy site or services, a cookie helps Bevy to recall your specific information on subsequent visits. This simplifies the process of recording your personal information, such as billing addresses, shipping addresses, and so on. When you return to the same Bevy website, the information you previously provided can be retrieved, so you can easily use the Bevy features that you customized.
             
            You have the ability to accept or decline cookies. Most Web browsers automatically accept cookies, but you can usually modify your browser setting to decline cookies if you prefer. If you choose to decline cookies, you may not be able to fully experience the interactive features of the Bevy services or websites you visit.
             
            Security of your Personal Information
            Bevy secures your personal information from unauthorized access, use, or disclosure. Bevy uses the following methods for this purpose:
             
                  - SSL Protocol
             
            When personal information (such as a credit card number) is transmitted to other websites, it is protected through the use of encryption, such as the Secure Sockets Layer (SSL) protocol.

            We strive to take appropriate security measures to protect against unauthorized access to or alteration of your personal information. Unfortunately, no data transmission over the Internet or any wireless network can be guaranteed to be 100% secure. As a result, while we strive to protect your personal information, you acknowledge that: (a) there are security and privacy limitations inherent to the Internet which are beyond our control; and (b) security, integrity, and privacy of any and all information and data exchanged between you and us through this Site cannot be guaranteed.
             
            Right to Deletion
            Subject to certain exceptions set out below, on receipt of a verifiable request from you, we will:
             
              • Delete your personal information from our records; and
             
              • Direct any service providers to delete your personal information from their records.
             
            Please note that we may not be able to comply with requests to delete your personal information if it is necessary to:
             
              • Complete the transaction for which the personal information was collected, fulfill the terms of a written warranty or product recall conducted in accordance with federal law, provide a good or service requested by you, or reasonably anticipated within the context of our ongoing business relationship with you, or otherwise perform a contract between you and us;
             
              • Detect security incidents, protect against malicious, deceptive, fraudulent, or illegal activity; or prosecute those responsible for that activity;
             
              • Debug to identify and repair errors that impair existing intended functionality;
             
              • Exercise free speech, ensure the right of another consumer to exercise his or her right of free speech, or exercise another right provided for by law;
             
              • Comply with the California Electronic Communications Privacy Act;
             
              • Engage in public or peer-reviewed scientific, historical, or statistical research in the public interest that adheres to all other applicable ethics and privacy laws, when our deletion of the information is likely to render impossible or seriously impair the achievement of such research, provided we have obtained your informed consent;
             
              • Enable solely internal uses that are reasonably aligned with your expectations based on your relationship with us;
             
              • Comply with an existing legal obligation; or
             
              • Otherwise use your personal information, internally, in a lawful manner that is compatible with the context in which you provided the information.
             
            Children Under Thirteen
            Bevy does not knowingly collect personally identifiable information from children under the age of thirteen. If you are under the age of thirteen, you must ask your parent or guardian for permission to use this website and Mobile Application.
             
            Disconnecting your Bevy Account from Third Party Websites
            You will be able to connect your Bevy account to third party accounts. BY CONNECTING YOUR BEVY ACCOUNT TO YOUR THIRD PARTY ACCOUNT, YOU ACKNOWLEDGE AND AGREE THAT YOU ARE CONSENTING TO THE CONTINUOUS RELEASE OF INFORMATION ABOUT YOU TO OTHERS (IN ACCORDANCE WITH YOUR PRIVACY SETTINGS ON THOSE THIRD PARTY SITES). IF YOU DO NOT WANT INFORMATION ABOUT YOU, INCLUDING PERSONALLY IDENTIFYING INFORMATION, TO BE SHARED IN THIS MANNER, DO NOT USE THIS FEATURE. You may disconnect your account from a third party account at any time. Users can sign out of or disconnect their social and banking account credentials from the Bevy app at any time.

            E-mail Communications
            From time to time, Bevy may contact you via email for the purpose of providing announcements, promotional offers, alerts, confirmations, surveys, and/or other general communication. In order to improve our Services, we may receive a notification when you open an email from Bevy or click on a link therein.
             
            If you would like to stop receiving marketing or promotional communications via email from Bevy, you may opt out of such communications by Customers may unsubscribe from emails by “replying STOP” or “clicking on the UNSUBSCRIBE button..
             
            External Data Storage Sites
            We may store your data on servers provided by third party hosting vendors with whom we have contracted.
             
            Changes to this Statement
            Bevy reserves the right to change this Privacy Policy from time to time. We will notify you about significant changes in the way we treat personal information by sending a notice to the primary email address specified in your account, by placing a prominent notice on our site, Mobile Application, and/or by updating any privacy information on this page. Your continued use of the Site, Mobile Application and/or Services available through this App after such modifications will constitute your: (a) acknowledgment of the modified Privacy Policy; and (b) agreement to abide and be bound by that Policy.
             
            Contact Information
            Bevy welcomes your questions or comments regarding this Statement of Privacy. If you believe that Bevy has not adhered to this Statement, please contact Bevy at:
             
            Bevy LLC
            908 Madison Ave
            Covington, Kentucky 41011
             
            Email Address:
            info@getbevy.app
             
            Effective as of July 25, 2020
            """
        } else if (type == 3) { //About the Bevy App
            lblTitle.text = "About\nthe Bevy App"
        } else { // Terms and conditions
            lblTitle.text = "Terms &\nConditions"
            txtContent.text = """
            Agreement between User and Bevy LLC.

            Welcome to Bevy. The Bevy Mobile Application (the “App”) is comprised of various pages operated by Bevy LLC (“Bevy”). The Bevy Mobile Application is offered to you conditioned on your acceptance without modification of the terms, conditions, and notices contained herein (the “Terms”). Your use of The Bevy Mobile Application constitutes your agreement to all such Terms. Please read these terms carefully, and keep a copy of them for your reference.
             
            Bevy is a Lifestyle management Mobile Application.
             
            Bevy allows users to manage their social presence, money, travel and more.
             
            Privacy
            Your use of The Bevy Mobile Application is subject to Bevy’s Privacy Policy. Please review our Privacy Policy, which also governs the App and informs users of our data collection practices.
             
            Electronic Communications
            Using The Bevy Mobile Application, visiting www.getbevy.app or sending emails to Bevy constitutes electronic communications. You consent to receive electronic communications and you agree that all agreements, notices, disclosures and other communications that we provide to you electronically, via email and on the Site, satisfy any legal requirement that such communications be in writing.
             
            Your Account
            If you use this App, you are responsible for maintaining the confidentiality of your account and password and for restricting access to your smartphone, and you agree to accept responsibility for all activities that occur under your account or password. You may not assign or otherwise transfer your account to any other person or entity. You acknowledge that Bevy is not responsible for third party access to your account that results from theft or misappropriation of your account. Bevy and its associates reserve the right to refuse or cancel service, terminate accounts, or remove or edit content in our sole discretion.

            Children Under Thirteen
            Bevy does not knowingly collect, either online or offline, personal information from persons under the age of thirteen. If you are under 18, you may use www.getbevy.app and The Bevy Mobile Application only with permission of a parent or guardian.
             
            Links to Third Party Sites/Third Party Services
            The Bevy Mobile Application and www.getbevy.app may contain links to other websites (“Linked Sites”). The Linked Sites are not under the control of Bevy and Bevy is not responsible for the contents of any Linked Site, including without limitation any link contained in a Linked Site, or any changes or updates to a Linked Site. Bevy is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement by Bevy of the site of the Mobile App or any association with its operators.
             
            Certain services made available via The Bevy Mobile Application and www.getbevy.app are delivered by third party sites and organizations. By using any product, service or functionality originating from The Bevy Mobile Application or the www.getbevy.app domain, you hereby acknowledge and consent that Bevy may share such information and data with any third party with whom Bevy has a contractual relationship to provide the requested product, service or functionality on behalf of The Bevy Mobile Application or www.getbevy.app users and customers.
             
            No Unlawful or Prohibited Use/Intellectual Property
            You are granted a non-exclusive, non-transferable, revocable license to access and use www.getbevy.app strictly in accordance with these terms of use. As a condition of your use of the Site, you warrant to Bevy that you will not use the Site or Mobile App for any purpose that is unlawful or prohibited by these Terms. You may not use the Site or Mobile App in any manner which could damage, disable, overburden, or impair the Site or Mobile App or interfere with any other party’s use and enjoyment of the Site or Mobile App. You may not obtain or attempt to obtain any materials or information through any means not intentionally made available or provided for through the Site or Mobile App.
             
            All content included as part of the Service, such as text, graphics, logos, images, as well as the compilation thereof, and any software used on the Site or Mobile App, is the property of Bevy or its suppliers and protected by copyright and other laws that protect intellectual property and proprietary rights. You agree to observe and abide by all copyright and other proprietary notices, legends or other restrictions contained in any such content and will not make any changes thereto.
             
            You will not modify, publish, transmit, reverse engineer, participate in the transfer or sale, create derivative works, or in any way exploit any of the content, in whole or in part, found on the Site or Mobile App. Bevy content is not for resale. Your use of the Site and/ or Mobile App does not entitle you to make any unauthorized use of any protected content, and in particular you will not delete or alter any proprietary rights or attribution notices in any content. You will use protected content solely for your personal use, and will make no other use of the content without the express written permission of Bevy and the copyright owner. You agree that you do not acquire any ownership rights in any protected content. We do not grant you any licenses, express or implied, to the intellectual property of Bevy or our licensors except as expressly authorized by these Terms.
             
            Use of Communication Services
            The Site and Mobile App may contain bulletin board services, chat areas, news groups, forums, communities, personal web pages, calendars, and/or other message or communication facilities designed to enable you to communicate with the public at large or with a group (collectively, "Communication Services"). You agree to use the Communication Services only to post, send and receive messages and material that are proper and related to the particular Communication Service.

            By way of example, and not as a limitation, you agree that when using a Communication Service, you will not: defame, abuse, harass, stalk, threaten or otherwise violate the legal rights (such as rights of privacy and publicity) of others; publish, post, upload, distribute or disseminate any inappropriate, profane, defamatory, infringing, obscene, indecent or unlawful topic, name, material or information; upload files that contain software or other material protected by intellectual property laws (or by rights of privacy of publicity) unless you own or control the rights thereto or have received all necessary consents; upload files that contain viruses, corrupted files, or any other similar software or programs that may damage the operation of another’s computer; advertise or offer to sell or buy any goods or services for any business purpose, unless such Communication Service specifically allows such messages; conduct or forward surveys, contests, pyramid schemes or chain letters; download any file posted by another user of a Communication Service that you know, or reasonably should know, cannot be legally distributed in such manner; falsify or delete any author attributions, legal or other proper notices or proprietary designations or labels of the origin or source of software or other material contained in a file that is uploaded; restrict or inhibit any other user from using and enjoying the Communication Services; violate any code of conduct or other guidelines which may be applicable for any particular Communication Service; harvest or otherwise collect information about others, including e-mail addresses, without their consent; violate any applicable laws or regulations.
             
            Bevy has no obligation to monitor the Communication Services. However, Bevy reserves the right to review materials posted to a Communication Service and to remove any materials in its sole discretion. Bevy reserves the right to terminate your access to any or all of the Communication Services at any time without notice for any reason whatsoever.
             
            Bevy reserves the right at all times to disclose any information as necessary to satisfy any applicable law, regulation, legal process or governmental request, or to edit, refuse to post or to remove any information or materials, in whole or in part, in Bevy’s sole discretion.
             
            Always use caution when giving out any personally identifying information about yourself or your children in any Communication Service. Bevy does not control or endorse the content, messages or information found in any Communication Service and, therefore, Bevy specifically disclaims any liability with regard to the Communication Services and any actions resulting from your participation in any Communication Service. Managers and hosts are not authorized Bevy spokespersons, and their views do not necessarily reflect those of Bevy.
             
            Materials uploaded to a Communication Service may be subject to posted limitations on usage, reproduction and/or dissemination. You are responsible for adhering to such limitations if you upload the materials.
             
            Materials Provided to www.getbevy.app or Posted on Any Bevy Web Page And/ Or Mobile Application
            Bevy does not claim ownership of the materials you provide to The Bevy Mobile Application, www.getbevy.app (including feedback and suggestions) or post, upload, input or submit to any Bevy Site or our associated services (collectively “Submissions”). However, by posting, uploading, inputting, providing or submitting your Submission you are granting Bevy, our affiliated companies and necessary sublicensees permission to use your Submission in connection with the operation of their Internet businesses including, without limitation, the rights to: copy, distribute, transmit, publicly display, publicly perform, reproduce, edit, translate and reformat your Submission; and to publish your name in connection with your Submission.
             
            No compensation will be paid with respect to the use of your Submission, as provided herein. Bevy is under no obligation to post or use any Submission you may provide and may remove any Submission at any time in Bevy's sole discretion.
             
            By posting, uploading, inputting, providing or submitting your Submission you warrant and represent that you own or otherwise control all of the rights to your Submission as described in this section including, without limitation, all the rights necessary for you to provide, post, upload, input or submit the Submissions.
             
            Third Party Accounts
            You will be able to connect your Bevy account to third party accounts. By connecting your Bevy account to your third party account, you acknowledge and agree that you are consenting to the continuous release of information about you to others (in accordance with your privacy settings on those third party sites). If you do not want information about you to be shared in this manner, do not use this feature.

            International Users
            The Service is controlled, operated and administered by Bevy from our offices within the USA. If you access the Service from a location outside the USA, you are responsible for compliance with all local laws. You agree that you will not use the Bevy Content accessed through The Bevy Mobile Application, www.getbevy.app in any country or in any manner prohibited by any applicable laws, restrictions or regulations.
             
            Indemnification
            You agree to indemnify, defend and hold harmless Bevy, its officers, directors, employees, agents and third parties, for any losses, costs, liabilities and expenses (including reasonable attorney’s fees) relating to or arising out of your use of or inability to use the Site or Mobile App or services, any user postings made by you, your violation of any terms of this Agreement or your violation of any rights of a third party, or your violation of any applicable laws, rules or regulations. Bevy reserves the right, at its own cost, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you, in which event you will fully cooperate with Bevy in asserting any available defenses.
             
            Arbitration
            In the event the parties are not able to resolve any dispute between them arising out of or concerning these Terms and Conditions, or any provisions hereof, whether in contract, tort, or otherwise at law or in equity for damages or any other relief, then such dispute shall be resolved only by final and binding arbitration pursuant to the Federal Arbitration Act, conducted by a single neutral arbitrator and administered by the American Arbitration Association, or a similar arbitration service selected by the parties, in a location mutually agreed upon by the parties. The arbitrator’s award shall be final, and judgment may be entered upon it in any court having jurisdiction. In the event that any legal or equitable action, proceeding or arbitration arises out of or concerns these Terms and Conditions, the prevailing party shall be entitled to recover its costs and reasonable attorney’s fees. The parties agree to arbitrate all disputes and claims in regards to these Terms and Conditions or any disputes arising as a result of these Terms and Conditions, whether directly or indirectly, including Tort claims that are a result of these Terms and Conditions. The parties agree that the Federal Arbitration Act governs the interpretation and enforcement of this provision. The entire dispute, including the scope and enforceability of this arbitration provision shall be determined by the Arbitrator. This arbitration provision shall survive the termination of these Terms and Conditions.
             
            Class Action Waiver
            Any arbitration under these Terms and Conditions will take place on an individual basis; class arbitrations and class/representative/collective actions are not permitted. THE PARTIES AGREE THAT A PARTY MAY BRING CLAIMS AGAINST THE OTHER ONLY IN EACH’S INDIVIDUAL CAPACITY, AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PUTATIVE CLASS, COLLECTIVE AND/ OR REPRESENTATIVE PROCEEDING, SUCH AS IN THE FORM OF A PRIVATE ATTORNEY GENERAL ACTION AGAINST THE OTHER. Further, unless both you and Bevy agree otherwise, the arbitrator may not consolidate more than one person’s claims, and may not otherwise preside over any form of a representative or class proceeding.
             
            Liability Disclaimer
            THE INFORMATION, SOFTWARE, PRODUCTS, AND SERVICES INCLUDED IN OR AVAILABLE THROUGH THE SITE MAY INCLUDE INACCURACIES OR TYPOGRAPHICAL ERRORS. CHANGES ARE PERIODICALLY ADDED TO THE INFORMATION HEREIN. BEVY LLC AND/OR ITS SUPPLIERS MAY MAKE IMPROVEMENTS AND/OR CHANGES IN THE SITE OR MOBILE APPLICATION AT ANY TIME.
             
            BEVY LLC AND/OR ITS SUPPLIERS MAKE NO REPRESENTATIONS ABOUT THE SUITABILITY, RELIABILITY, AVAILABILITY, TIMELINESS, AND ACCURACY OF THE INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS CONTAINED ON THE SITE OR MOBILE APP FOR ANY PURPOSE. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, ALL SUCH INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS ARE PROVIDED "AS IS" WITHOUT WARRANTY OR CONDITION OF ANY KIND. BEVY LLC AND/OR ITS SUPPLIERS HEREBY DISCLAIM ALL WARRANTIES AND CONDITIONS WITH REGARD TO THIS INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS, INCLUDING ALL IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT.
             
            TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL BEVY LLC AND/OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, PUNITIVE, INCIDENTAL, SPECIAL, CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF USE, DATA OR PROFITS, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OR PERFORMANCE OF THE SITE OR MOBILE APP, WITH THE DELAY OR INABILITY TO USE THE SITE OR RELATED SERVICES, THE PROVISION OF OR FAILURE TO PROVIDE SERVICES, OR FOR ANY INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS OBTAINED THROUGH THE SITE OR MOBILE APP, OR OTHERWISE ARISING OUT OF THE USE OF THE SITE OR MOBILE APP, WHETHER BASED ON CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE, EVEN IF BEVY LLC OR ANY OF ITS SUPPLIERS HAS BEEN ADVISED OF THE POSSIBILITY OF DAMAGES. BECAUSE SOME STATES/JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU. IF YOU ARE DISSATISFIED WITH ANY PORTION OF THE SITE, OR WITH ANY OF THESE TERMS OF USE, YOUR SOLE AND EXCLUSIVE REMEDY IS TO DISCONTINUE USING THE SITE.

            Termination/Access Restriction
            Bevy reserves the right, in its sole discretion, to terminate your access to the Site and the related services or any portion thereof at any time, without notice. To the maximum extent permitted by law, this agreement is governed by the laws of the State of Ohio and you hereby consent to the exclusive jurisdiction and venue of courts in Ohio in all disputes arising out of or relating to the use of the Site. Use of the Site and/or Mobile App is unauthorized in any jurisdiction that does not give effect to all provisions of these Terms, including, without limitation, this section.
             
            You agree that no joint venture, partnership, employment, or agency relationship exists between you and Bevy as a result of this agreement or use of the Site and/or Mobile App. Bevy’s performance of this agreement is subject to existing laws and legal process, and nothing contained in this agreement is in derogation of Bevy’s right to comply with governmental, court and law enforcement requests or requirements relating to your use of the Site and/or Mobile App or information provided to or gathered by Bevy with respect to such use. If any part of this agreement is determined to be invalid or unenforceable pursuant to applicable law including, but not limited to, the warranty disclaimers and liability limitations set forth above, then the invalid or unenforceable provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and the remainder of the agreement shall continue in effect.
             
            Unless otherwise specified herein, this agreement constitutes the entire agreement between the user and Bevy with respect to the Siteand/or Mobile App and it supersedes all prior or contemporaneous communications and proposals, whether electronic, oral or written, between the user and Bevy with respect to the Site and Mobile App. A printed version of this agreement and of any notice given in electronic form shall be admissible in judicial or administrative proceedings based upon or relating to this agreement to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form. It is the express wish to the parties that this agreement and all related documents be written in English.
             
            Changes to Terms
            Bevy reserves the right, in its sole discretion, to change the Terms under which The Bevy Mobile Application, www.getbevy.app is offered. The most current version of the Terms will supersede all previous versions. Bevy encourages you to periodically review the Terms to stay informed of our updates.
             
            Contact Us
            Bevy welcomes your questions or comments regarding these Terms:

            Bevy LLC
            908 Madison Ave
            Covington, Kentucky 41011
             
            Email Address:
            info@getbevy.app
             
            Effective as of July 26, 2020
            """
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
