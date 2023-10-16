import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldSuggestions extends StatefulWidget {
  final List<String> list;
  final Function returnedValue;
  final Function onTap;
  final double height;
  final String labelText;
  final Color textSuggetionsColor;
  final Color suggetionsBackgroundColor;
  final Color outlineInputBorderColor;
  final IconData? icone;
  final EdgeInsets? margem;

  const TextFieldSuggestions(
      {Key? key,
        this.icone,
        this.margem,
        required this.list,
        required this.labelText,
        required this.textSuggetionsColor,
        required this.suggetionsBackgroundColor,
        required this.outlineInputBorderColor,
        required this.returnedValue,
        required this.onTap,
        required this.height})
      : super(key: key);

  @override
  _TextFieldSuggestionsState createState() => _TextFieldSuggestionsState();
}

class _TextFieldSuggestionsState extends State<TextFieldSuggestions> {
  int flag = 0;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    flag = 0;
  }

  @override
  void dispose() {
    super.dispose();
    //widget.list.clear();
    flag = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      height = widget.height;
    }

    // double height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      margin: widget.margem,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue value) {
          widget.returnedValue(capitalizeWords(value.text));
          // When the field is empty
          if (value.text.isEmpty) {
            return [];
          }
          // The logic to find out which ones should appear
          return widget.list
              .where((suggestion) => suggestion.contains(value.text));
        },
        fieldViewBuilder: (BuildContext context, textEditingController,
            FocusNode focusNode, VoidCallback onFieldSubmitted) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Color(0xFFF5B2B0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFF8CAC7),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: textEditingController,
              style: const TextStyle(
                color: Color(0xFF37513F),
                fontWeight: FontWeight.w400,
              ),
              focusNode: focusNode,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              scrollPadding: const EdgeInsets.only(bottom: 200),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFF5B2B0),
                    width: 2.0,
                  ),
                ),
                hintText: widget.labelText,
                hintStyle: const TextStyle(
                  color: Color(0xFFB4CABB),
                  fontWeight: FontWeight.bold,
                ),
                fillColor: widget.outlineInputBorderColor,
                prefixIcon: Icon(
                  widget.icone,
                  color: Color(0xFF37513F),
                ),
              ),
              onSubmitted: (String value) {
                if (value.isNotEmpty) {
                  onFieldSubmitted();
                  widget.returnedValue(capitalizeWords(textEditingController.text));
                }
                setState(() {
                  flag = 1;
                  height = 0;
                });
                FocusScope.of(context).unfocus();
              },
              onChanged: (text) {
                setState(() {
                  flag = 0;
                });
              },
              onTap: () {
                widget.onTap();
              },
            ),
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Container(
            margin: const EdgeInsets.only(right: 93),
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.white,
                child: SizedBox(
                  height: options.length == 1
                      ? 85
                      : options.length == 2
                      ? 150
                      : 200,
                  child: ListView.builder(
                    // shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                            widget.returnedValue(capitalizeWords(option));
                            FocusScope.of(context).unfocus();
                            setState(() {
                              flag = 1;
                              height = 0;
                            });
                          },
                          child: ListTile(
                            title: Text(
                              option,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Color(0xff255A46),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String capitalizeWords(String text) {
    List<String> words = text.toLowerCase().split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      String capitalizedWord = word[0].toUpperCase() + word.substring(1);
      capitalizedWords.add(capitalizedWord);
    }

    return capitalizedWords.join(' ');
  }
}