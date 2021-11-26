import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fuel_app/l10n/messages_all.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{

  const AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
  
  
}

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  String get splashLoadingText {
    return Intl.message(
      'Online Fuel Services',
      name: 'splashLoadingText',
      desc: 'the text of Splash Screen Loading'
    );
  }

  String get loginHeaderText {
    return Intl.message(
      'Login',
      name: 'loginHeaderText',
      desc: 'the text of Login Header'
    );
  }
  String get registerButton {
    return Intl.message(
      'Create Account',
      name: 'registerButton',
      desc: 'the text of Register Button'
    );
  }
  String get nextButton {
    return Intl.message(
      'Next',
      name: 'nextButton',
      desc: 'the text of Next Button'
    );
  }
  String get skipButton {
    return Intl.message(
      'Skip',
      name: 'skipButton',
      desc: 'the text of Skip Button'
    );
  }
  String get loginButtonText {
    return Intl.message(
      'Login',
      name: 'loginButtonText',
      desc: 'the text of Login Button'
    );
  }
  String get hintEmailText {
    return Intl.message(
      'Email',
      name: 'hintEmailText',
      desc: 'the text of hint Email Text'
    );
  }
  String get hintPassText {
    return Intl.message(
      'Password',
      name: 'hintPassText',
      desc: 'the text of hint Password Text'
    );
  }
  String get len3ErrorMessage {
    return Intl.message(
      'Please Enter at least 3 character',
      name: 'len3ErrorMessage',
      desc: 'the text of Email Error Message'
    );
  }
  String get emailValidErrorMessage {
    return Intl.message(
      'Please enter valid email',
      name: 'emailValidErrorMessage',
      desc: 'the text of Email Valid Error Message'
    );
  }
  String get len5ErrorMessage {
    return Intl.message(
      'Please Enter at least 5 character',
      name: 'len5ErrorMessage',
      desc: 'the text of Email Valid Error Message'
    );
  }
  String get nearTab {
    return Intl.message(
      'Near Stations',
      name: 'nearTab',
      desc: 'the text of near Stations Tab'
    );
  }
  String get companyTab {
    return Intl.message(
      'Company',
      name: 'companyTab',
      desc: 'the text of Company Tab'
    );
  }
  String get favTab {
    return Intl.message(
      'Favorites',
      name: 'favTab',
      desc: 'the text of Favorites Tab'
    );
  }
  String get logoutButton {
    return Intl.message(
      'Logout',
      name: 'logoutButton',
      desc: 'the text of Logout Button'
    );
  }
  String get addFavPopup {
    return Intl.message(
      'Add to favorite',
      name: 'addFavPopup',
      desc: 'the text of Add to Favorite Popup Option'
    );
  }
  String get removeFavPopup {
    return Intl.message(
      'Remove from favorite',
      name: 'removeFavPopup',
      desc: 'the text of Remove from Favorite Popup Option'
    );
  }
  String get showServices {
    return Intl.message(
      'Show Services',
      name: 'showServices',
      desc: 'the text of Show Services Popup Option'
    );
  }
  String get vehicQ {
    return Intl.message(
      'vehicles queue',
      name: 'vehicQ',
      desc: 'the text of list tile vehicle Queue'
    );
  }
  String get benzinText {
    return Intl.message(
      'Benzin',
      name: 'benzinText',
      desc: 'the text of list tile Benzin'
    );
  }
  String get gasText {
    return Intl.message(
      'Gas',
      name: 'gasText',
      desc: 'the text of list tile Gas'
    );
  }
  String get activeText {
    return Intl.message(
      'Active',
      name: 'activeText',
      desc: 'the text of list tile Active Text'
    );
  }
  String get inActiveText {
    return Intl.message(
      'Inactive',
      name: 'inActiveText',
      desc: 'the text of list tile Active Text'
    );
  }
  String get quant100 {
    return Intl.message(
      '-FULL-',
      name: 'quant100',
      desc: 'the text Maximum Limit of Fuel Quantity'
    );
  }
  String get quant0 {
    return Intl.message(
      '-EMPTY-',
      name: 'quant0',
      desc: 'the text Minimum Limit of Fuel Quantity'
    );
  }
  String get publicError {
    return Intl.message(
      'An Error Occured',
      name: 'publicError',
      desc: 'the text of Ananimous Errors'
    );
  }
  String get remFavMessage {
    return Intl.message(
      'Station removed from favorite',
      name: 'remFavMessage',
      desc: 'When a Station is Removed Form Favorite this Message will display'
    );
  }
  String get addedFavMessage {
    return Intl.message(
      'Station added to favorite',
      name: 'addedFavMessage',
      desc: 'When a Station is added to Favorite this Message will display'
    );
  }
  String get usernametxt {
    return Intl.message(
      'User Name',
      name: 'usernametxt',
      desc: 'Label Text Of Username'
    );
  }
  String get currentPasswordtxt {
    return Intl.message(
      'current Password',
      name: 'currentPasswordtxt',
      desc: 'Label Text Of current Password'
    );
  }
  String get requiredFieldsMessage {
    return Intl.message(
      'This field is required',
      name: 'requiredFieldsMessage',
      desc: 'When No Data Entered In Required Fields'
    );
  }
  String get wrongPass {
    return Intl.message(
      'Password is wrong',
      name: 'wrongPass',
      desc: 'When Password Does not matchs'
    );
  }
  String get newPasswordtxt {
    return Intl.message(
      'New Password',
      name: 'newPasswordtxt',
      desc: 'Label Text Of New Password'
    );
  }
  String get passIsAlreadyExist {
    return Intl.message(
      'You must change an Existing password',
      name: 'passIsAlreadyExist',
      desc: 'When User Enter An existing password'
    );
  }
  String get submittxt {
    return Intl.message(
      'Submit',
      name: 'submittxt',
      desc: 'To Submit Change Password Operation '
    );
  }
  String get tryText {
    return Intl.message(
      'Try Again',
      name: 'tryText',
      desc: 'When Connection Fail'
    );
  }
  String get connErrorMessage {
    return Intl.message(
      'Error: Check internet connection',
      name: 'connErrorMessage',
      desc: 'When Connection Fail this message will display'
    );
  }
  String get confirmQtxt {
    return Intl.message(
      'confirm Q',
      name: 'confirmQtxt',
      desc: 'Label Text of confirm Q'
    );
  }
  String get loadingtxt {
    return Intl.message(
      'Loading',
      name: 'loadingtxt',
      desc: 'Label Text of Loading'
    );
  }
  String get feedSuccessMessage {
    return Intl.message(
      'Thank You For Your Feedback',
      name: 'feedSuccessMessage',
      desc: 'When Feedback sent successfully this message will display'
    );
  }
  String get sendtxt {
    return Intl.message(
      'Send',
      name: 'sendtxt',
      desc: 'Label Text of Send'
    );
  }
  String get desctxt {
    return Intl.message(
      'Description',
      name: 'desctxt',
      desc: 'Label Text of Description'
    );
  }
  String get cmpNametxt {
    return Intl.message(
      'Company Name',
      name: 'cmpNametxt',
      desc: 'Label Text of Company Name'
    );
  }
  String get sdtxt {
    return Intl.message(
      'SD',
      name: 'sdtxt',
      desc: 'Label Text of SD'
    );
  }
  String get sendLoadingtxt {
    return Intl.message(
      'Sending',
      name: 'sendLoadingtxt',
      desc: 'Label Text of Sending Loader'
    );
  }
  String get emptyStationList {
    return Intl.message(
      'No Active Stations',
      name: 'emptyStationList',
      desc: 'When List Of Station is Empty'
    );
  }
  String get loginFailMessage {
    return Intl.message(
      'Email Or Password is wrong',
      name: 'loginFailMessage',
      desc: 'When List Of Station is Empty'
    );
  }
  String get queuingMessage {
    return Intl.message(
      'You are aproximatly in the queue make sure you are in range or will be taken out of queue',
      name: 'queuingMessage',
      desc: 'When List Of Station is Empty'
    );
  }
}
