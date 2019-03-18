import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=26bc59ff';

void main(){
  runApp(MaterialApp(
    title: 'Conversor de Moedas',
    home:Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));
}

Future<Map>  getData() async{
  http.Response response = await http.get(request);
  return  json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  final _realController = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController = TextEditingController();

  void realChanged(String text){
    double real = double.parse(text);
    _dolarController.text = (real/dolar).toStringAsFixed(2);
    _euroController.text=(real/euro).toStringAsFixed(2);
  }

  void dolarChanged(String text){
    double dolar = double.parse(text);
    _realController.text = (dolar*this.dolar).toStringAsFixed(2);
    _euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);
  }

  void euroChanged(String text){
    double euro = double.parse(text);
    _realController.text = (euro*this.euro).toStringAsFixed(2);
    _dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }

  double dolar;
  double euro;

  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('\$ Conversor \$'),
          centerTitle: true,
        ),
        body:FutureBuilder<Map>(
          future:getData(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando dados",
                          style: TextStyle(
                            color: Colors.amber, 
                            fontSize: 25.0
                          ),
                          textAlign: TextAlign.center,
                          )
                );
                default:
                  if(snapshot.hasError){
                     return Center(
                          child: Text("Erro ao carregar os dados",
                          style: TextStyle(
                            color: Colors.amber, 
                            fontSize: 25.0
                          ),
                          textAlign: TextAlign.center,
                          )
                );  
                  }else{
                    dolar =   snapshot.data["results"]["currencies"]['USD']['buy'];
                    euro  = snapshot.data["results"]["currencies"]['EUR']['buy'];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,size:150,color: Colors.amber),
                          builderTextField("Reais", "R\$", _realController, realChanged),
                          Divider(),
                          builderTextField("Dolares",'USD', _dolarController, dolarChanged),
                          Divider(),
                          builderTextField('Euros','€',_euroController, euroChanged)
                        ],
                      ),
                    );
                  }
            }
        }
    ));
  }

}

Widget builderTextField(String label,String prefix,TextEditingController c,Function f){
  return TextField(
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border:OutlineInputBorder(),
          prefixText: prefix
      ),
      style: TextStyle(color: Colors.amber,fontSize: 25.0),
      textAlign: TextAlign.center,
      controller: c,
      onChanged: f,
      keyboardType: TextInputType.number,
  );
}


