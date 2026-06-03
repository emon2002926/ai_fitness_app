// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
//
//
// class MathText extends StatelessWidget {
//   final String data;
//   final Color color;
//   final double fontSize;
//   final FontWeight fontWeight;
//   final TextStyle Function({TextStyle? textStyle})? googleFontFamily;
//
//   const MathText({
//     super.key,
//     required this.data,
//     this.color = Colors.black87,
//     this.fontSize = 15,
//     this.fontWeight = FontWeight.normal,
//     this.googleFontFamily,
//   });
//
//   TextStyle get _baseStyle {
//     final base = TextStyle(
//       color: color,
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//     );
//     if (googleFontFamily != null) {
//       return googleFontFamily!(textStyle: base);
//     }
//     return base;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final maxWidth = MediaQuery.of(context).size.width * 0.72;
//     final spans = _buildSpans(maxWidth);
//
//     return SelectableText.rich(
//       TextSpan(
//         style: _baseStyle,
//         children: spans,
//       ),
//     );
//   }
//
//   List<InlineSpan> _buildSpans(double maxWidth) {
//     final List<InlineSpan> spans = [];
//
//     final regex = RegExp(
//       r'\$\$(.+?)\$\$|\\\[(.+?)\\\]|\$(.+?)\$|\\\((.+?)\\\)',
//       dotAll: true,
//     );
//     int lastEnd = 0;
//
//     for (final match in regex.allMatches(data)) {
//       if (match.start > lastEnd) {
//         spans.add(TextSpan(
//           text: data.substring(lastEnd, match.start),
//           style: _baseStyle,
//         ));
//       }
//
//       final latex = match.group(1) ??
//           match.group(2) ??
//           match.group(3) ??
//           match.group(4) ??
//           '';
//       final isBlock = match.group(1) != null || match.group(2) != null;
//
//       spans.add(WidgetSpan(
//         alignment: PlaceholderAlignment.middle,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 2,
//             vertical: isBlock ? 6 : 0,
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: maxWidth),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               child: Math.tex(
//                 latex,
//                 textStyle: _baseStyle,
//                 onErrorFallback: (err) => Text(latex, style: _baseStyle),
//               ),
//             ),
//           ),
//         ),
//       ));
//
//       lastEnd = match.end;
//     }
//
//     if (lastEnd < data.length) {
//       spans.add(TextSpan(
//         text: data.substring(lastEnd),
//         style: _baseStyle,
//       ));
//     }
//
//     return spans;
//   }
// }