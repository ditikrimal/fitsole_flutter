part of 'helpers.dart';

void modalSuccess(BuildContext context, String text,
    {required VoidCallback onPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Container(
          padding: const EdgeInsets.all(15.0),
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(211, 54, 233, 66),
                size: 50,
              ),
              const SizedBox(height: 10.0),
              TextFitsole(
                  text: "Success", fontSize: 17, fontWeight: FontWeight.w400),
              const SizedBox(height: 10.0),
              TextFitsole(
                  text: text, fontSize: 14, fontWeight: FontWeight.w400),
              const SizedBox(height: 10.0),
              InkWell(
                onTap: onPressed,
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
      );
    },
  );
}
