import 'package:my_app_2_2/Models/sendingImageModel.dart';

enum EventType { add, delete }

class SendingImageEvent {
  SendingImageModel sendingImage;
  int sendingImageIndex;
  int sendingImageId;
  EventType eventType;

  SendingImageEvent.add({SendingImageModel sendingImage, int sendingImageId}) {
    this.eventType = EventType.add;
    this.sendingImage = sendingImage;
    this.sendingImageId = sendingImageId;
  }

  SendingImageEvent.delete(int index) {
    this.eventType = EventType.delete;
    this.sendingImageId = index;
  }
}
