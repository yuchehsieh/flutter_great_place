import 'package:flutter/material.dart';
import 'package:great_place/providers/great_places.dart';
import 'package:great_place/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<GreatPlaces>(
              builder: (context, greatPlaces, child) =>
                  greatPlaces.items.length <= 0
                      ? child
                      : ListView.builder(
                          itemBuilder: (ctx, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                greatPlaces.items[index].image,
                              ),
                            ),
                            title: Text(greatPlaces.items[index].title),
                            subtitle:
                                Text(greatPlaces.items[index].location.address),
                            onTap: () {
                              // go to detail page
                            },
                          ),
                          itemCount: greatPlaces.items.length,
                        ),
              child: const Center(
                child: const Text('Got no places yet, start adding some!'),
              ),
            );
          }
        },
      ),
    );
  }
}
