part of 'widgets.dart';

class TextFitsole extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final double? letterSpacing;
  final bool isTitle;
  final bool isUnderline;

  const TextFitsole({
    Key? key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.maxLines = 1,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.letterSpacing,
    this.isTitle = false,
    this.isUnderline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont(isTitle ? 'Poppins' : 'Roboto',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          decoration:
              isUnderline ? TextDecoration.underline : TextDecoration.none),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
