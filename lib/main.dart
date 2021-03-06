import 'dart:async';
import 'dart:ui';
import 'package:final_personal_spellbook/dnd_spell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.green,
          scaffoldBackgroundColor: Color.fromRGBO(255, 229, 204, 10),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Allows the app to take in inputs from a touch screen and a mouse, enables use on both phones and web browsers.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _newSpellTextField = TextEditingController();

  List<DnDSpell> mySpells = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

  }

  // This is what gets the information from the API, taking a String input, which will be the name that is applied to the URL.
  // Returns a DnDSpell object
  Future<DnDSpell> getDnDSpell(String name) async {
    Uri url = Uri.parse("https://www.dnd5eapi.co/api/spells/" + name);
    print("getDnDSpell() about to get data");
    final response = await http.get(url);
    if(response.statusCode == 200) {
      print("getDnDSpell() response OK recived");
      String strDnDSpell = response.body;
      print("getDnDSpell() about to return");
      return dnDSpellFromJson(strDnDSpell);
    }
  }

  // Creates and returns the ListTile that displays the spell to the user.
  // Takes in an Integer, being the index that the user is on.
  ListTile selectedSpell(int index) {
    return ListTile(
      title: Text(mySpells[index].name, style: TextStyle(fontSize: 32), textAlign: TextAlign.center,),
      subtitle: SingleChildScrollView(
        child: Column(
          children: [
            Text("${mySpells[index].level}rd level ${mySpells[index].school.name}"),
            Text("Casting Time: ${mySpells[index].castingTime}"),
            Text("Range: ${mySpells[index].range}"),
            Text("Components: ${mySpells[index].components}"),
            Text("Duration: ${mySpells[index].duration}"),
            Text(mySpells[index].getFullDesc()),
            SizedBox(height: 10,),
            Text("At Higher Levels: ${mySpells[index].getHigherLevel()}"),
            ElevatedButton(onPressed: () async {
              setState(() {
                print(index);
                mySpells.removeAt(index);
                //mySpells.clear();
                print('remove called');
                print(mySpells.length);
              });
            },
              child: Text(
                "Remove Spell",
                style: TextStyle(fontSize: 20),
              ),
            ),
          SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  // This is the TextField that the user enters the spell they want to search
  Widget spellTextField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.7,
      child: TextField(
        controller: _newSpellTextField,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Use - istead of spaces",
          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }

  // The button that the user clicks to add the spell.
  // Calls the getDnDSpell() method
  Widget addSpellBtn() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          getDnDSpell(_newSpellTextField.text).then( (newDnDSpell) {
            print('initState ---- new spell has arrived in the future');
            setState(() {
              mySpells.add(newDnDSpell);
              loading = false;
            });
            print('initState ---- updated spells');
          }
          );
          _newSpellTextField.clear();
        },
        child: Text(
          "Add Spell",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Personal Spell Book"),
          leading: Icon(Icons.book_outlined),
        ),

        body:
        Column(
          children: [
            // Used to be Expanded
            Container(
              child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    spellTextField(),
                    SizedBox(width: 10,),
                    addSpellBtn()
                  ],
                )
            ),
            Expanded(
              child: PageView.builder(
                itemCount: mySpells.length,
                itemBuilder: (context, index){
                  return selectedSpell(index);
                },
              ),
            ),
          ],
        )
    );
  }



}
