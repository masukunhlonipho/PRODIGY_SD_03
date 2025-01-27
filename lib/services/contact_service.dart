import '../models/contact.dart';


class ContactService {
  final List<Contact> _contacts = [
    Contact(name: 'John Doe', phoneNumber: '1234567890', email: 'john@example.com'),
    Contact(name: 'Jane Smith', phoneNumber: '9876543210', email: 'jane@example.com'),
    Contact(name: 'Snip', phoneNumber: '123456789', email: ''),
  ];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
  }

  void deleteContact(Contact contact) {
    _contacts.remove(contact);
  }

  void updateContact(int index, Contact contact) {
    _contacts[index] = contact;
  }
}
