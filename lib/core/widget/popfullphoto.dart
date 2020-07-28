import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PopFullPhoto extends StatelessWidget {
  final String url;

  PopFullPhoto({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Full Photo',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: PopFullPhotoScreen(url: url),
    );
  }
}

class PopFullPhotoScreen extends StatefulWidget {
  final String url;

  PopFullPhotoScreen({Key key, this.url}) : super(key: key);

  @override
  State createState() => PopFullPhotoScreenState(url: url);
}

class PopFullPhotoScreenState extends State<PopFullPhotoScreen> {
  final String url;

  PopFullPhotoScreenState({Key key, this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}
