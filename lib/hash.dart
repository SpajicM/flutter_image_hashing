import 'package:image/image.dart' as imageLib;

abstract class Hash {

  int compare(imageLib.Image img1, imageLib.Image img2) {
    String hash1 = calculate(img1);
    String hash2 = calculate(img2);
    int distance = 0;

    for (int i = 0; i < hash1.length; i++) {
      if (hash1[i] != hash2[i]) {
        distance++;
      }
    }

    return distance;
  }

  String calculate(imageLib.Image img);
}