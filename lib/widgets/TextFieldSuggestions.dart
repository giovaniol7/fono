import 'package:flutter/material.dart';
import '../controllers/estilos.dart';

class TextFieldSuggestions extends StatefulWidget {
  final String tipo;
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
        required this.tipo,
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
    flag = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      height = widget.height;
    }

    width = MediaQuery.of(context).size.width;
    return Container(
      margin: widget.margem,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: cores('corBorda')),
          color: cores('branco'),
          boxShadow: [BoxShadow(offset: Offset(0, 3), color: cores('corSombra'), blurRadius: 5)]),
      child: LayoutBuilder(
        builder: (context, constraints) => RawAutocomplete<String>(
          optionsBuilder: (TextEditingValue value) {
            widget.returnedValue(widget.tipo == 'paciente' ? capitalizeWords(value.text) : value.text);
            if (value.text.isEmpty) {
              return [];
            }

            // Filtrar sugestões
            List<String> suggestions = widget.list.where((suggestion) {
              return suggestion.toLowerCase().startsWith(value.text.toLowerCase());
            }).toList();

            // Ordenar sugestões por relevância
            suggestions.sort((a, b) {
              if (a.toLowerCase().startsWith(value.text.toLowerCase())) {
                return -1;
              } else if (b.toLowerCase().startsWith(value.text.toLowerCase())) {
                return 1;
              } else {
                return 0;
              }
            });

            return suggestions;
          },
          fieldViewBuilder: (BuildContext context, textEditingController, FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: cores('corBorda')),
                color: cores('branco'),
                boxShadow: [BoxShadow(color: cores('corSombra'), blurRadius: 5, offset: Offset(0, 3))],
              ),
              child: Form(
                child: TextFormField(
                  controller: textEditingController,
                  style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 18),
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: cores('corBorda'), width: 2.0),
                    ),
                    labelText: widget.labelText,
                    labelStyle:
                    TextStyle(color: cores('corDetalhe'), fontSize: 18, fontWeight: FontWeight.w500),
                    fillColor: widget.outlineInputBorderColor,
                    prefixIcon: Icon(widget.icone, color: cores('corSimbolo')),
                  ),
                  onFieldSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      onFieldSubmitted();
                      widget.returnedValue(widget.tipo == 'paciente'
                          ? capitalizeWords(textEditingController.text)
                          : textEditingController.text);
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
              ),
            );
          },
          optionsViewBuilder:
              (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
            return Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 2,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: cores('corCaixaPadrao'),
                  child: SizedBox(
                    height: options.length == 1
                        ? 100
                        : options.length == 2
                        ? 150
                        : 200,
                    width: constraints.biggest.width,
                    child: ListView.builder(
                        itemCount: options.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              widget.returnedValue(
                                  widget.tipo == 'paciente' ? capitalizeWords(option) : option);
                              FocusScope.of(context).unfocus();
                              setState(() {
                                flag = 1;
                                height = 0;
                              });
                            },
                            child: ListTile(
                              title: Text(option,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.normal)),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String capitalizeWords(String text) {
    List<String> words = text.toLowerCase().split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        if (word == "da" ||
            word == "de" ||
            word == "di" ||
            word == "do" ||
            word == "du" ||
            word == "das" ||
            word == "des" ||
            word == "dis" ||
            word == "dos" ||
            word == "dus") {
          capitalizedWords.add(word);
        } else {
          String capitalizedWord = word[0].toUpperCase() + word.substring(1);
          capitalizedWords.add(capitalizedWord);
        }
      }
    }
    return capitalizedWords.join(' ');
  }
}
