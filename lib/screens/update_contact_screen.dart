import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class UpdateContactScreen extends StatefulWidget {
  final Contact contact;
  final int index;

  const UpdateContactScreen({super.key, required this.contact, required this.index});

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phoneNumber);
    _emailController = TextEditingController(text: widget.contact.email);
  }

  void _updateContact(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);

    final updatedContact = Contact(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
    );

    contactProvider.updateContact(widget.index, updatedContact);
    Navigator.pop(context, true); // Go back to the contact list with an update status
  }

  void _deleteContact(BuildContext context) {
    try {
      final contactProvider = Provider.of<ContactProvider>(context, listen: false);
      contactProvider.deleteContact(widget.index);
      Navigator.of(context).pop(); // Close the confirmation dialog
      Navigator.of(context).pop(true); // Close the UpdateContactScreen with a deletion status
    } catch (e) {
      print('Error deleting contact: $e');
      // Here you might want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
        actions: [
          TextButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
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
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateContact(context),
              child: Text('Update Contact'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Close dialog
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(context);
              Navigator.of(ctx).pop(); // Close dialog
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
