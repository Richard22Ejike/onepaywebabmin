import 'package:flutter/material.dart';

void showDialogs(BuildContext context, String title, TextEditingController controller, List<String> items, VoidCallback ontap) {
  final TextEditingController searchController = TextEditingController();
  List<String> filteredItems = List.from(items);

  showGeneralDialog(
    barrierLabel: title,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 350),
    context: context,
    pageBuilder: (context, __, ___) {
      return Material(
        color: Colors.transparent,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .7,
                margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(title,
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: (val) {
                        setState(() {
                          filteredItems = items.where((item) => item.toLowerCase().contains(val.toLowerCase())).toList();
                        });
                      },
                      style: TextStyle(
                          color: Colors.grey.shade800, fontSize: 16.0),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Search here...",
                          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
                          isDense: true,
                          prefixIcon: Icon(Icons.search)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        itemCount: filteredItems.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {

                              controller.text = filteredItems[index];
                              ontap();
                              searchController.clear();
                              Navigator.pop(context);

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, left: 10.0, right: 10.0),
                              child: Text(
                                  filteredItems[index],
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16.0)),
                            ),
                          );
                        },
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0))),
                      onPressed: () {
                        searchController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}
