import 'package:flutter/cupertino.dart' show CupertinoSearchTextField;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/data/app_notifier.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
//import 'package:veggie_android_seasons/widgets/search_bar.dart';
import 'package:veggie_android_seasons/widgets/veggie_headline.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String terms = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Widget _createSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoSearchTextField(
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }

  Widget _buildSearchResults(List<Veggie> veggies) {
    if (veggies.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'No veggies matching your search terms were found.',
            style: VeggieStyles.headlineDescription,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: veggies.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: VeggieHeadline(
            veggie: veggies[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: VeggieStyles.scaffoldBackground,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _createSearchBox(),
                Expanded(
                  child: _buildSearchResults(ref
                      .watch(appNotifierProvider.notifier)
                      .searchVeggies(terms)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTextChanged() {
    setState(() {
      terms = controller.text;
    });
  }
}
