import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:plant_diary/bloc/model/image.dart';
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
    } else if (event is DeleteImageEvent) {
      final bool success = await plantsRepo.deletePhoto(event.plantId, event.plantImageId, event.plantImageFilePath) ;
      print('Image deletion successfull: $success');
    }
  }

  void addImage(String imagePath, String plantId) async {
    add(AddImageEvent(imagePath, plantId));
  }

  void deletePhoto(String plantId, String imageId, String imageFilePath) {
    add(DeleteImageEvent(plantId, imageId, imageFilePath));
  }
}

abstract class ImageEvent {}

class AddImageEvent extends ImageEvent {
  final String imagePath;
  final String plantId;
  AddImageEvent(this.imagePath, this.plantId);
}

class DeleteImageEvent extends ImageEvent {
  final String plantId;
  final String plantImageId;
  final String plantImageFilePath;
  DeleteImageEvent(this.plantId, this.plantImageId, this.plantImageFilePath);
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
