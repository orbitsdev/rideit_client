import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/model/prediction_place.dart';

class Search extends StatefulWidget {
  final BuildContext passcontext;
  final Function setisSearchingLocation;
  final Function selectedLocationFromSearch;
  const Search(
      {required this.passcontext,
      required this.setisSearchingLocation,
      required this.selectedLocationFromSearch});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var mapxcontroller = Get.put(Mapcontroller());
  var searchcontroller = FloatingSearchBarController();

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildFloatingSearchBar();
  }

  bool isSearchFocus = false;
  void setSearchFocus(bool value) {
    setState(() {
      isSearchFocus = value;
    });
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var isfocus = false;
    return FloatingSearchBar(
      controller: searchcontroller,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 200),
      onFocusChanged: (_) {
        if (isSearchFocus == false) {
          setSearchFocus(true);
          widget.setisSearchingLocation(isSearchFocus);
        } else {
          setSearchFocus(false);
          widget.setisSearchingLocation(isSearchFocus);
          mapxcontroller.placeprediction.clear();
        }
      },
      onQueryChanged: (query) {
        if (query.isEmpty || query == '') {
          mapxcontroller.placeprediction.clear();
        }
        mapxcontroller.searchPlace(query);

        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.

      transition: SlideFadeFloatingSearchBarTransition(),
      onSubmitted: (query) {
        mapxcontroller.searchPlace(query);
        searchcontroller.close();
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {
              print('press');
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            elevation: 4,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (mapxcontroller.isfetching.value) {}
                    return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        padding: EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: mapxcontroller.placeprediction.length,
                        itemBuilder: (context, index) {
                          return bulidPredictionTile(
                              mapxcontroller.placeprediction[index]);
                        });
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bulidPredictionTile(PredictionPlace predictionplace) {
    return Material(
      child: InkWell(
        onTap: () {
          mapxcontroller.placeDetails(predictionplace.placeId as String);
          widget.selectedLocationFromSearch(mapxcontroller.markerPositon);

          setState(() {
            searchcontroller.close();
            mapxcontroller.placeprediction.clear();
          });
        },
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 14,
                  ),
                  FaIcon(FontAwesomeIcons.mapMarker),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${predictionplace.maintext}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "${predictionplace.secondrarytext}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
