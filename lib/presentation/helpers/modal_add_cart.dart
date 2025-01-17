part of 'helpers.dart';

void modalAddCartSuccess(BuildContext context, String image) {
  showDialog(
    context: context,
    barrierColor: Colors.white60,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFitsole(
                    text: 'Frave Shop',
                    fontSize: 22,
                    color: ColorsFrave.primaryColorFrave,
                    fontWeight: FontWeight.w500),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      Environment.baseUrl + image,
                      height: 80.0,
                    ),
                    SizedBox(width: 10.0),
                    BounceInLeft(
                        child: Icon(Icons.check_circle_outlined,
                            color: Colors.green, size: 80)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
