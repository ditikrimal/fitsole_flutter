part of 'helpers.dart';

void modalLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black45,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.all(15.0),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                  radius: 20,
                  child: Image(
                    image: AssetImage(
                      'assets/fraved_logo_circle.png',
                    ),
                  )),
              CircularProgressIndicator(
                color: Colors.black,
              ),
              SizedBox(height: 10.0),
            ],
          )),
    ),
  );
}
