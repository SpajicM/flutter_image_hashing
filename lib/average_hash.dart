import 'package:image/image.dart' as imageLib;
import 'hash.dart';

class AverageHash extends Hash {

  String calculate(imageLib.Image img) {
    var resizedImg = imageLib.copyResize(img, 8);
    var grayImg = imageLib.grayscale(resizedImg);

    var pixels = new List();
    var hash = new List();

    for (int x = 0; x < grayImg.height; x++) {
      for (int y = 0; y < grayImg.width; y++) {
        pixels.add(grayImg.getPixel(x, y));
      }
    }

    int sum = 0;
    for (int e in pixels) {
      sum += e;
    }

    int averageColor = (sum / pixels.length).floor();
    for (int e in pixels) {
      e > averageColor ? hash.add(1) : hash.add(0);
    }

    return hash.toString();
  }
}
