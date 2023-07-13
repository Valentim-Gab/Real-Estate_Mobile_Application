import 'package:flutter/material.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/services/property_service.dart';
import 'package:mobile/app/views/android/components/card_property.dart';
import 'package:mobile/app/views/android/components/settings_dialog.dart';
import 'package:mobile/app/views/android/components/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedOption = 0;
  PropertyService propertyService = PropertyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
              onPressed: () {
                openSettingsDialog(context);
              },
              icon: const Icon(
                Icons.settings,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(seconds: 0));
          setState(() {});
        },
        child: IndexedStack(
          index: _selectedOption,
          children: <Widget>[rentBody(), saleBody()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () {
          Navigator.of(context).pushNamed('/property/new');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedOption,
        onTap: (option) {
          setState(() {
            _selectedOption = option;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: 'Aluguel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Venda',
          )
        ],
      ),
    );
  }

  Widget rentBody() {
    return getListViewCustom('aluguel');
  }

  Widget saleBody() {
    return getListViewCustom('venda');
  }

  Widget getListViewCustom(String typeMarketing) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<List<Property>>(
        future: propertyService.getPropertiesMe(),
        builder: (context, snapshot) {
          final List<Property>? properties = snapshot.data
              ?.where((property) =>
                  property.typeMarketing.toLowerCase() ==
                  typeMarketing.toLowerCase())
              .toList();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData &&
              properties != null &&
              properties.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: properties.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
              itemBuilder: (context, index) {
                final Property property = properties[index];

                return getEstates(property);
              },
            );
          }

          return const Center(
            child: Text(
              'Não há propriedades cadastradas',
              style: TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }

  Widget getEstates(Property property) {
    return CardProperty(property: property);
  }
}
