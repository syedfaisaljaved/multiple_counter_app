import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_app/firestore/FireStoreUtils.dart';
import 'package:flutter/material.dart';

class CounterThree extends StatefulWidget {
  final Stream<DocumentSnapshot>? stream;
  const CounterThree({Key? key, this.stream}) : super(key: key);

  @override
  _CounterThreeState createState() => _CounterThreeState();
}

class _CounterThreeState extends State<CounterThree> {

  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return widget.stream != null ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(
          flex: 2,
        ),
        const Text(
          'Counter 3',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        const Text(
          'You have pushed the Counter 3 button this many times:',
        ),
        const Spacer(
          flex: 1,
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: widget.stream,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                _count = snapshot.data?.get("counter3");
              }
              return Text(
                snapshot.hasData ? _count.toString() : "",
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                ),
              );
            }),
        const Spacer(
          flex: 1,
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
            elevation: MaterialStateProperty.all(5),
          ),
          onPressed: () async {
            /// increment counter
            (await FireStoreUtils.instance.userDeviceRef).update({"counter3": _count + 1});
          },
          child: const Text(
            "Increment Me!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(flex: 1,),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
            elevation: MaterialStateProperty.all(5),
          ),
          onPressed: () async {
            /// reset counter
            (await FireStoreUtils.instance.userDeviceRef).update({"counter3": 0});
          },
          child: const Text("Reset", style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    ) : const Center(child: CircularProgressIndicator(),);
  }
}
