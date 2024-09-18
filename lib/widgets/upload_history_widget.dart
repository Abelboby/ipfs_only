import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/upload_history_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uploadHistoryService = Provider.of<UploadHistoryService>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: uploadHistoryService.uploads.length,
        itemBuilder: (context, index) {
          final upload = uploadHistoryService.uploads[index];
          return ListTile(
            title: Text('CID: ${upload.cid}'),
            subtitle: Text('Uploaded: ${upload.timestamp}'),
            trailing: IconButton(
              icon: Icon(Icons.link),
              onPressed: () async {
                final url = 'https://gateway.pinata.cloud/ipfs/${upload.cid}';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
