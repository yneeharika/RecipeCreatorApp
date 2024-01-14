import 'package:flutter/material.dart';
import 'package:recipecreator/constant/constantdata.dart';
import 'dart:math' as math;
import 'package:recipecreator/widgets/button.dart';
import 'package:recipecreator/screens/homepagerepo.dart';
import 'package:recipecreator/widgets/spacer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? controller;
  FocusNode? focusNode;
  final List<String> inputTags = [];
  String response = '';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Find The Best Recipe For Cooking',
                  maxLines: 3,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        autofocus: true,
                        autocorrect: true,
                        focusNode: focusNode,
                        controller: controller,
                        onFieldSubmitted: (value) {
                          controller!.clear();
                          setState(() {
                            String inputvalue = value.trim();
                            if (inputvalue.isNotEmpty) {
                              inputTags.add(value);
                              focusNode!.requestFocus();
                            }
                          });
                          print(inputTags);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.5),
                              bottomLeft: Radius.circular(5.5),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter The Ingredients You Have...",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              String inputvalue = controller!.text.trim();
                              if (inputvalue.isNotEmpty) {
                                inputTags.add(inputvalue);
                                focusNode!.requestFocus();
                              }
                            });
                            print(inputTags);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          for (int i = 0; i < inputTags.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Chip(
                                backgroundColor: Color(
                                  (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                                ).withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    inputTags.remove(inputTags[i]);
                                    print(inputTags);
                                  });
                                },
                                label: Text(inputTags[i]),
                                deleteIcon: const Icon(Icons.close, size: 20),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              response,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      HeightSpacer(myHeight: KSpacing / 2),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: PrimaryBtn(
                          btnchild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome),
                              WidthSpacer(myWidth: KSpacing / 2),
                              Text("create recipe"),
                            ],
                          ),
                          btnFun: () async {
                            setState(() => response = 'Thinking...');
                            try {
                              var temp = await HomePageRepo().askAI(inputTags.toString());
                              setState(() => response = temp.toString());
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
