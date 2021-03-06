import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../models/contato.dart';
import '../utils/modtxt.dart';


class Cadastro extends StatefulWidget
{
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro>
{
  final formKey = GlobalKey<FormState>();
  var _controllerTelefone = new MaskedTextController(mask: '(00) 0 0000-0000');
  var _controllerData = new MaskedTextController(mask: '00/00/0000');

  String _nome, _telefone, _data_nasc;

  void _cadastrar()
  {
    if(formKey.currentState.validate())
    {
      formKey.currentState.save();
      _nome = '${_nome[0].toUpperCase()}${_nome.substring(1)}';
      ModTxt txt = new ModTxt();
      txt.writeRegistro('$_nome,$_telefone,$_data_nasc');
      Navigator.of(context).pop(Contato(nome:_nome,telefone:_telefone,data_nasc:_data_nasc));
    }
  }

  bool validaData(String data)
  {
    var arrData = data.split('/');
    var dataValid = DateTime.parse('${arrData[2]}-${arrData[1]}-${arrData[0]}');
    if(dataValid.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)
      return false;
    if(int.parse(arrData[0]) == dataValid.day && int.parse(arrData[1]) == dataValid.month && int.parse(arrData[2]) == dataValid.year)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Cadastro'),
        ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome:'
                  ),
                validator: (input) => input.isEmpty ? 'Campo obrigatório!' : null,
                onSaved: (input) => _nome = input,
                ),
              TextFormField(
                controller: _controllerTelefone,
                decoration: InputDecoration(
                  labelText: 'Telefone:'
                  ),
                validator: (input) => input.length != 16 ? 'Quantidade de dígitos insuficiente!' : null,
                onSaved: (input) => _telefone = input,
                ),
              TextFormField(
                controller: _controllerData,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento:'
                  ),
                validator: (input) => input.length == 10 && validaData(input)? null : 'Data inválida!',
                onSaved: (input) => _data_nasc = input,
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: _cadastrar,
                    child: Text('Cadastrar'),
                    ),
                  )
                ],
                )
              ],
              ),
            ),
          ),
        ),
      );
  }

}
