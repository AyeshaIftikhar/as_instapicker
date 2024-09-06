import 'package:flutter_test/flutter_test.dart';
import 'package:as_instapicker/as_instapicker.dart';
import 'package:as_instapicker/src/instacrop_controller.dart';

void main() {
  test('Ensure nextCropRatio() loop', () {
    final InstaCropController controller =
        InstaCropController(false, const InstaCropDelegate());

    expect(controller.aspectRatio, 1);
    expect(controller.aspectRatioString, '1:1');

    controller.nextCropRatio();

    expect(controller.aspectRatio, 4 / 5);
    expect(controller.aspectRatioString, '4:5');

    controller.nextCropRatio();

    expect(controller.aspectRatio, 1);
    expect(controller.aspectRatioString, '1:1');
  });
}
