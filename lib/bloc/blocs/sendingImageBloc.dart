import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app_2_2/Models/sendingImageModel.dart';
import 'package:my_app_2_2/bloc/event/sendingImageEvent.dart';

class SendingImageBloc
    extends Bloc<SendingImageEvent, List<SendingImageModel>> {
  @override
  List<SendingImageModel> get initialState => List<SendingImageModel>();

  @override
  Stream<List<SendingImageModel>> mapEventToState(
      SendingImageEvent event) async* {
    print('got to bloc');
    switch (event.eventType) {
      case EventType.add:
        print('got to bloc swich add');
        List<SendingImageModel> newState = List.from(state);
        if (event.sendingImage != null) {
          newState.add(event.sendingImage);
        }
        yield newState;
        break;

      case EventType.delete:
        List<SendingImageModel> newState = List.from(state);
        newState.remove(event.sendingImageId);
        yield newState;
        break;

      default:
        throw Exception('Event Not Found');
    }
  }
}
