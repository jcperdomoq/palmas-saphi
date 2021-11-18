import 'package:las_palmas/src/pages/plants/widgets/multi_select_dialog.dart';

class Tratamiento {
  static final case1 = [
    const MultiSelectDialogItem('C x N', 'C x N'),
    const MultiSelectDialogItem('C-2501', 'C-2501'),
    const MultiSelectDialogItem('D x C', 'D x C'),
    const MultiSelectDialogItem('D x G', 'D x G'),
    const MultiSelectDialogItem('D x N', 'D x N'),
  ];
  static final case2 = [
    const MultiSelectDialogItem('T1', 'T1'),
    const MultiSelectDialogItem('T2', 'T2'),
  ];
  static final case3 = List.generate(
      34, (i) => MultiSelectDialogItem('C-${i + 1}', 'C-${i + 1}'));
  static final case4 = [
    const MultiSelectDialogItem('F-1', 'F-1'),
    const MultiSelectDialogItem('F-4', 'F-4'),
    const MultiSelectDialogItem('F-5', 'F-5'),
    const MultiSelectDialogItem('F-6', 'F-6'),
    const MultiSelectDialogItem('F-8', 'F-8'),
    const MultiSelectDialogItem('F-11', 'F-11'),
    const MultiSelectDialogItem('F-12', 'F-12'),
    const MultiSelectDialogItem('F-13', 'F-13'),
    const MultiSelectDialogItem('F-14', 'F-14'),
  ];
  static final case5 = [
    const MultiSelectDialogItem('0.0 TM/Ha', '0.0 TM/Ha'),
    const MultiSelectDialogItem('1.0 TM/Ha', '1.0 TM/Ha'),
    const MultiSelectDialogItem('2.0 TM/Ha', '2.0 TM/Ha'),
    const MultiSelectDialogItem('3.0 TM/Ha', '3.0 TM/Ha'),
    const MultiSelectDialogItem('4.0 TM/Ha', '4.0 TM/Ha'),
  ];
  static final case6 = [
    const MultiSelectDialogItem('ELITE', 'ELITE'),
    const MultiSelectDialogItem('Millenium', 'Millenium'),
  ];
  static final case7 = [
    const MultiSelectDialogItem('Coari x LaMe', 'Coari x LaMe'),
    const MultiSelectDialogItem('Coari x Yangambi', 'Coari x Yangambi'),
    const MultiSelectDialogItem('Unipalma Eo x Eg', 'Unipalma Eo x Eg'),
    const MultiSelectDialogItem('Amazon', 'Amazon'),
  ];
  static final case8 = [
    const MultiSelectDialogItem(
        '9.0m x 9.0m MILLENIUM', '9.0m x 9.0m MILLENIUM'),
    const MultiSelectDialogItem('9.0m x 9.0m ELITE', '9.0m x 9.0m ELITE'),
    const MultiSelectDialogItem(
        '9.0m x 9.0m CHALLENGER', '9.0m x 9.0m CHALLENGER'),
    const MultiSelectDialogItem(
        '9.0m x 9.0m AVALANCHE', '9.0m x 9.0m AVALANCHE'),
    const MultiSelectDialogItem(
        '8.0m x 8.0m MILLENIUM', '8.0m x 8.0m MILLENIUM'),
    const MultiSelectDialogItem('8.0m x 8.0m ELITE', '8.0m x 8.0m ELITE'),
    const MultiSelectDialogItem(
        '8.0m x 8.0m CHALLENGER', '8.0m x 8.0m CHALLENGER'),
    const MultiSelectDialogItem(
        '8.0m x 8.0m AVALANCHE', '8.0m x 8.0m AVALANCHE'),
    const MultiSelectDialogItem(
        '8.5m x 8.5m MILLENIUM', '8.5m x 8.5m MILLENIUM'),
    const MultiSelectDialogItem('8.5m x 8.5m ELITE', '8.5m x 8.5m ELITE'),
    const MultiSelectDialogItem(
        '8.5m x 8.5m CHALLENGER', '8.5m x 8.5m CHALLENGER'),
    const MultiSelectDialogItem(
        '8.5m x 8.5m AVALANCHE', '8.5m x 8.5m AVALANCHE'),
  ];
}
