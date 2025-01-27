import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import 'add_contact_screen.dart';
import 'update_contact_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch contacts when the screen is first loaded (and also upon returning to the screen)
    Future.delayed(Duration.zero, () {
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          final contacts = contactProvider.contacts;

          // Show a loading indicator while contacts are being fetched
          if (contacts.isEmpty) {
            return Center(
              child: contactProvider.contacts.isEmpty
                  ? CircularProgressIndicator() // Display progress indicator when contacts are loading
                  : Text('No contacts available. Add some!',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return InkWell(
                onTap: () async {
                  // Wait for the result from UpdateContactScreen
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateContactScreen(
                        contact: contact,
                        index: index,
                      ),
                    ),
                  );

                  // Trigger UI update if contact was updated or deleted
                  if (result == true) {
                    contactProvider
                        .fetchContacts(); // Refresh the list after an operation
                  }
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
