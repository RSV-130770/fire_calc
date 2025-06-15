import 'package:flutter/material.dart';
import 'package:string_equation/string_equation.dart';
import 'History.dart';
//import 'sql.dart';
import 'fire.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState  extends State<MyHomePage>  {
  String _entered = '';
  double ttt=0;
  final List<String> _buttons=['(',')','/','*','7','8','9','-','4',
    '5','6','+','1','2','3','.'];
  String _result = '';
  String _history='';
  bool ex=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        spacing:10,
        children: <Widget>[
          SizedBox(
              height: 175,
              // Width of the container
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Text(_history)
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(_entered, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(_result, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          Row(
            spacing:10,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onLongPress: (){_history='';},
                onPressed: () {
                  setState(() {
                    if (_result.isNotEmpty) {
                      _history += '$_result\n';
                      _entered = '$ttt';
                    }
                    else {_entered ='';}
                    _result='';
                  });
                },
                child: Text('C'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_entered.isNotEmpty) {
                      _entered = _entered.substring(0,_entered.length - 1);
                      _result='';
                    }
                  });
                },
                child: Icon(
                  Icons.arrow_back,
                  size:10,
                  color: Colors.black,
                ),
              ),

            ],
          ),
          for(int j=0;j<4;j++)
            Row(
              spacing:10,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = j*4; i < (j+1)*4; i++)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _entered += _buttons[i];
                      });
                    },
                    child: Text(_buttons[i]),
                  ),
              ],
            ),
          Row(
            spacing:10,
            mainAxisSize: MainAxisSize.min,
            children: [

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _entered +='0';
                  });
                },
                child: Text('0'),
              ),

              ElevatedButton(
                onPressed: () {
                  ttt=ConditionEquation().evaluateExpression(_entered);
                  setState(() {
                    _result ='$_entered=$ttt';
                  });
                  addRecord(_result);
                },
                child: Text('='),
              ),
            ],
          ),
          Row(
            spacing:10,
            mainAxisSize: MainAxisSize.min,
            children: [

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ttt=ConditionEquation().evaluateExpression(_entered);
                    ttt*=1.609343502101154;
                    _result ='$_entered miles=$ttt km';
                    addRecord(_result);
                  });
                },
                child: Text('miles-> km'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ttt=ConditionEquation().evaluateExpression(_entered);
                    ttt /= 1.609343502101154;
                    _result ='$_entered km=$ttt miles';
                    addRecord(_result);
                  });
                },
                child: Text('km->miles'),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(onPressed: () {Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      );
      }, child: Text('history'),),
    );
  }
}

