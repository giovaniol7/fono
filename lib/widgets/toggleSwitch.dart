import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

toggleSwitch2(index, label1, label2, icon1, icon2, toggle) {
  return ToggleSwitch(
    minWidth: 150.0,
    initialLabelIndex: index,
    cornerRadius: 20.0,
    activeFgColor: Colors.white,
    inactiveBgColor: Colors.grey,
    inactiveFgColor: Colors.white,
    totalSwitches: 2,
    labels: [label1, label2],
    icons: [icon1, icon2],
    radiusStyle: true,
    activeBgColors: [
      [Colors.green.shade400],
      [Colors.pink.shade400]
    ],
    onToggle: toggle,
  );
}

toggleSwitch3(index, label1, label2, label3, icon1, icon2, icon3, toggle){
  return ToggleSwitch(
    minWidth: 150.0,
    initialLabelIndex: index,
    cornerRadius: 20.0,
    activeFgColor: Colors.white,
    inactiveBgColor: Colors.grey,
    inactiveFgColor: Colors.white,
    totalSwitches: 3,
    labels: [label1, label2, label3],
    icons: [icon1, icon2, icon3],
    radiusStyle: true,
    activeBgColors: [
      [Colors.green],
      [Colors.blue],
      [Colors.red]
    ],
    onToggle: toggle,
  );
}
