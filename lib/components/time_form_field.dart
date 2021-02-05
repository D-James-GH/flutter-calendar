import 'package:flutter/material.dart';

class TimeFormField extends FormField<TimeOfDay> {
  final ValueChanged onChanged;

  TimeFormField({
    Key key,
    @required TimeOfDay initialValue,
    FormFieldSetter<TimeOfDay> onSaved,
    FormFieldValidator validator,
    this.onChanged,
  }) : super(
            key: key,
            onSaved: onSaved,
            initialValue: initialValue,
            validator: validator,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<TimeOfDay> state) {
              return (state as _TimeFormFieldState)._constructWidget();
            });
  @override
  FormFieldState<TimeOfDay> createState() {
    return _TimeFormFieldState();
  }
}

class _TimeFormFieldState extends FormFieldState<TimeOfDay> {
  TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialValue;
  }

  Widget _constructWidget() {
    return RaisedButton(
      child: Text(_time.format(context)),
      onPressed: () => _selectTime(),
    );
  }

  Future _selectTime() async {
    final TimeOfDay selectedTimeRTL = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
    );
    if (selectedTimeRTL != null) {
      _time = selectedTimeRTL;
      this.didChange(selectedTimeRTL);
    }
  }
}
