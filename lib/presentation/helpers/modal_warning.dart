part of 'helpers.dart';

void modalWarning(
  BuildContext context,
  String text,
  String errorStatus,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Colors.black,
              size: 50,
            ),
            TextFitsole(
                text: errorStatus, fontSize: 17, fontWeight: FontWeight.w400),
            TextFitsole(
              text: text,
              fontSize: 14,
              maxLines: 2,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: 150,
                decoration: BoxDecoration(
                    color: ColorsFrave.primaryColorFrave,
                    borderRadius: BorderRadius.circular(5.0)),
                child: const TextFitsole(
                    text: 'Proceed', color: Colors.white, fontSize: 17),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
