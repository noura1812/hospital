// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hospital/model/doctors.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';

class DoctorsLongCard extends StatelessWidget {
  DoctorsModel doctorsModel;
  DoctorsLongCard({
    required this.doctorsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Themes.lighbackgroundColor,
      ),
      height: SizeConfig.screenHeight * .1,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(doctorsModel.imageurl),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          Container(
            width: getProportionateScreenWidth(10),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorsModel.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    '${doctorsModel.specialty} ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Themes.grey, fontSize: 15),
                  ),
                  Text(
                    '(${doctorsModel.reviews == null ? '0' : doctorsModel.reviews!.length} reviews)',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Themes.grey, fontSize: 10),
                  )
                ],
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.star,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }
}
