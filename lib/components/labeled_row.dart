import 'package:flutter/material.dart';

class LabeledRow extends StatelessWidget {
  final String label;
  final Widget body;

  const LabeledRow({Key key, this.label, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                //   border: Border.all(
                // color: Theme.of(context).primaryColor.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
