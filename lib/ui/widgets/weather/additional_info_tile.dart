import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../utilities/constants.dart';

class AdditionalInfoTile extends StatelessWidget {
  const AdditionalInfoTile({this.title, this.value, super.key});

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                title!,
                style: kAdditionalInfoTileTitle(context),
              ),
            ),
            Text(
              value!,
              style: kAdditionalInfoTileValue(context),
            ),
          ],
        ),
      );
}
