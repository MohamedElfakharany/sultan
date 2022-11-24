// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sultan/models/patient_models/home_appointments_model/home_result_model.dart';
import 'package:sultan/models/patient_models/lab_appointments_model/lab_result_model.dart';
import 'package:sultan/shared/components/cached_network_image.dart';
import 'package:sultan/shared/constants/colors.dart';
import 'package:sultan/shared/constants/general_constants.dart';
import 'package:sultan/shared/network/local/const_shared.dart';

class ResultsScreenCard extends StatelessWidget {
  ResultsScreenCard({Key? key, this.labResultsModel,required this.index, this.homeResultsModel}) : super(key: key);
  LabResultsModel? labResultsModel;
  HomeResultsModel? homeResultsModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 5.0),
      child: Container(
        height: 110.0,
        width: 110.0,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius:
          BorderRadius.circular(radius),
          border: Border.all(
            width: 1,
            color: greyLightColor,
          ),
        ),
        alignment:
        AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(
            vertical: 0, horizontal: 4),
        child: Stack(
          alignment:
          AlignmentDirectional.topEnd,
          children: [
            Row(
              children: [
                horizontalMicroSpace,
                CachedNetworkImageNormal(
                  imageUrl: imageTest,
                  width: 80,
                  height: 80,
                ),
                horizontalSmallSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Text(
                        '# ${labResultsModel?.data?[index].id ?? homeResultsModel?.data?[index].id}',
                        style:
                        titleSmallStyle,
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                      Text(
                        '${labResultsModel?.data?[index].countResult ?? homeResultsModel?.data?[index].countResult}',
                        style:
                        subTitleSmallStyle2,
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                      Text(
                        '${labResultsModel?.data?[index].date?.date ?? homeResultsModel?.data?[index].date?.date}',
                        style:
                        titleSmallStyle2,
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsDetailsCart extends StatelessWidget {
   ResultsDetailsCart({Key? key, this.labResultsDataFileModel, this.homeResultsDataFileModel}) : super(key: key);
  LabResultsDataFileModel? labResultsDataFileModel;
  HomeResultsDataFileModel? homeResultsDataFileModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      width: 110.0,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          width: 1,
          color: greyLightColor,
        ),
      ),
      alignment: AlignmentDirectional.center,
      padding:
      const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Row(
        children: [
          horizontalMicroSpace,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/images/pdf.jpg'),
          ),
          horizontalSmallSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '# ${labResultsDataFileModel?.id ?? homeResultsDataFileModel?.id}',
                      style: titleSmallStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    horizontalMediumSpace,
                    Text(
                      '${labResultsDataFileModel?.date?.date  ?? homeResultsDataFileModel?.date?.date}',
                      style: subTitleSmallStyle2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Text(
                  '${labResultsDataFileModel?.title ?? homeResultsDataFileModel?.title ?? ''}',
                  style: subTitleSmallStyle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (labResultsDataFileModel?.notes != null || homeResultsDataFileModel?.notes != null)
                Text(
                  '${labResultsDataFileModel?.notes ?? homeResultsDataFileModel?.notes ?? ''}',
                  style: subTitleSmallStyle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
