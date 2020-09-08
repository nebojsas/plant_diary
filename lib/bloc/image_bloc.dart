import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:plant_diary/repository/plants_repo.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  PlantsRepo plantsRepo = PlantsRepo();
  ImageBloc() : super(ImageStateInit());

  @override
  Future<void> onChange(Change<ImageState> change) async {
    print(change);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is AddImageEvent) {
      yield ImageStateUploading(0);
      print('AddImageEvent: ${event.imagePath}');
      final StorageReference reference = await plantsRepo.uploadPhoto(
          event.imagePath, event.plantId, (StorageTaskEvent storageEvent) {
        int progress = ((storageEvent.snapshot.bytesTransferred /
                    storageEvent.snapshot.totalByteCount) *
                100)
            .toInt();
        print('$progress%');
      });
      final String imageUrl = await reference.getDownloadURL();
      print('DONE! file uploaded to: $imageUrl');
      // yield ImageStateUploaded(await reference.getDownloadURL());
    }
  }

  void addImage(String imagePath, String plantId) async {
    add((AddImageEvent(imagePath, plantId)));
  }
}

abstract class ImageEvent {}

class AddImageEvent extends ImageEvent {
  final String imagePath;
  final String plantId;
  AddImageEvent(this.imagePath, this.plantId);
}

abstract class ImageState {}

class ImageStateInit extends ImageState {}

class ImageStateChosing extends ImageState {}

class ImageStateChosen extends ImageState {}

class ImageStateUploading extends ImageState {
  final int progress;

  ImageStateUploading(this.progress);
}

class ImageStateUploaded extends ImageState {
  final String imageUrl;

  ImageStateUploaded(this.imageUrl);
}
