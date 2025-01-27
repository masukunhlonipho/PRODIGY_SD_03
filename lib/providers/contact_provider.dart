import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  // Fetch contacts from local storage (SharedPreferences)
  Future<void> fetchContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? contactsString = prefs.getString('contacts');
      if (contactsString != null) {
        List<dynamic> contactsJson = json.decode(contactsString);
        _contacts = contactsJson.map((json) => Contact.fromJson(json)).toList();
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching contacts: $error');
      // Optionally, you can show a Snackbar or some UI feedback here
    }
  }

  // Save contacts to local storage (SharedPreferences)
  Future<void> _saveContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String contactsString = json.encode(_contacts.map((contact) => contact.toJson()).toList());
      prefs.setString('contacts', contactsString);
    } catch (error) {
      print('Error saving contacts: $error');
      // Optionally, show an error message to the user
    }
  }

  // Add a new contact
  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
    await _saveContacts();
    notifyListeners();
  }

  // Update an existing contact
  Future<void> updateContact(int index, Contact updatedContact) async {
    _contacts[index] = updatedContact;
    await _saveContacts();
    notifyListeners();
  }

  // Delete a contact
  Future<void> deleteContact(int index) async {
    _contacts.removeAt(index);
    await _saveContacts();
    notifyListeners();
  }
}
