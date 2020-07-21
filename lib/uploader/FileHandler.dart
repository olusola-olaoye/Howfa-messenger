/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileHandler
{
  final File file;
  final String folder_name;
  final String file_name;
  FileHandler({this.file, this.folder_name, this.file_name});

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://howfa-cb1fe.appspot.com');

  StorageUploadTask _task;

  Future<File> compressAndReturnFile(File file, String targetPath, int quality) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: quality,
    );

    return result;
  }

  Future<String> startUpload() async
  {

    String file_path = '${folder_name}}/${file_name}.JPG';

    StorageUploadTask uploadTask = _storage.ref().child(file_path).putFile(file);

    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);


    return (await downloadUrl.ref.getDownloadURL());
  }

  Future<String> getDataURL() async
  {
    String file_path = '${folder_name}}/${file_name}.png';

    return await _storage.ref().child(file_path).getDownloadURL();
  }
}
