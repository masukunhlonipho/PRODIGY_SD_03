import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import 'add_contact_screen.dart';
import 'update_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  bool _isFetching = true;
  final _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];
  final _listViewController = ScrollController();
  final _alphabetController = ScrollController();
  String _currentLetter = '';
  final alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    await Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    setState(() {
      _isFetching = false;
      _filterContacts();
    });
  }

  void _filterContacts() {
    var contacts = Provider.of<ContactProvider>(context, listen: false).contacts;
    contacts.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _filteredContacts = _searchController.text.isEmpty
          ? contacts
          : contacts.where((c) => c.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  void _scrollToLetter(String letter) {
    final index = _filteredContacts.indexWhere((c) => c.name[0].toUpperCase() == letter);
    if (index != -1) _listViewController.animateTo(index * 80.0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: [
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (_) => _filterContacts(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Contacts...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  filled: true,
                  fillColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ),
      body: Stack(
        children: [
          Consumer<ContactProvider>(
            builder: (_, contactProvider, __) => _isFetching
                ? const Center(child: CircularProgressIndicator())
                : _filteredContacts.isEmpty
                ? const Center(child: Text('No contacts available. Add some!', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  final index = (scrollNotification.metrics.pixels / 80.0).round();
                  if (index < _filteredContacts.length) {
                    final letter = _filteredContacts[index].name[0].toUpperCase();
                    if (_currentLetter != letter) setState(() => _currentLetter = letter);
                  }
                }
                return false;
              },
              child: ListView.builder(
                controller: _listViewController,
                itemCount: _filteredContacts.length,
                itemBuilder: (_, index) {
                  final contact = _filteredContacts[index];
                  return GestureDetector(
                    onTap: () async {
                      if (await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateContactScreen(contact: contact, index: index)),
                      ) == true) {
                        _fetchContacts();
                      }
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: Colors.black,
                      child: ListTile(
                        title: Text(contact.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(contact.phoneNumber, style: const TextStyle(color: Colors.white70)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 80,
            bottom: 0,
            child: SizedBox(
              width: 40,
              child: ListView.builder(
                controller: _alphabetController,
                itemCount: alphabet.length,
                itemExtent: 25.0,
                itemBuilder: (_, index) {
                  final letter = alphabet[index];
                  return GestureDetector(
                    onTap: () => _scrollToLetter(letter),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: _currentLetter == letter
                            ? Matrix4.translationValues(0.0, -5.0, 0.0) * Matrix4.diagonal3Values(1.5, 1.5, 1)
                            : Matrix4.identity(),
                        child: Text(
                          letter,
                          style: TextStyle(color: _currentLetter == letter ? Colors.white : Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddContactScreen())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}