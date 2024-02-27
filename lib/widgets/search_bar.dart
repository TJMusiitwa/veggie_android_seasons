import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchBar(
      {super.key, required this.controller, required this.focusNode});
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: VeggieStyles.searchBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: <Widget>[
            const ExcludeSemantics(
              child: Icon(
                Icons.search,
                color: VeggieStyles.searchIconColor,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: VeggieStyles.searchText,
                cursorColor: VeggieStyles.searchCursorColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.clear();
              },
              child:
                  const Icon(Icons.clear, color: VeggieStyles.searchIconColor),
            )
          ],
        ),
      ),
    );
  }
}
