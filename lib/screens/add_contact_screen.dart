import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class AddContactScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AddContactScreen({super.key});

  void _addContact(BuildContext context) {
    final contactProvider =
    Provider.of<ContactProvider>(context, listen: false);

    final contact = Contact(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
    );

    // Simple validation
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Name and Phone Number are required!'),
      ));
      return;
    }

    contactProvider.addContact(contact);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addContact(context),
              child: Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}