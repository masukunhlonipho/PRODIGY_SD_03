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

    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Name and Phone Number are required!'),
      ));
      return;
    }

    contactProvider.updateContact(widget.index, updatedContact);
    Navigator.pop(context, true);
  }

  void _deleteContact(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider.deleteContact(widget.index);
    Navigator.pop(context, true); // Close screen after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
        leading: BackButton(
          color: Colors.white,
        ),
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
        content: Text('Are you sure you want to delete this contact?',
            style: TextStyle(color: Colors.red, fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(context);
              Navigator.of(ctx).pop();
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
