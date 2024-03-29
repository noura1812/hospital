import 'package:flutter/material.dart';

import 'package:hospital/model/doctors.dart';
import 'package:hospital/screens/doctors_screen.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';

class DoctorsLongCard extends StatelessWidget {
  final DoctorsModel doctorsModel;
  const DoctorsLongCard({
    super.key,
    required this.doctorsModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DoctorsScreen.routName,
            arguments: doctorsModel);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(7)),
        padding: EdgeInsets.all(getProportionateScreenWidth(15)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Themes.lightBackgroundColor,
        ),
        height: SizeConfig.screenHeight * .114,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(doctorsModel.imageUrl),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Container(
              width: getProportionateScreenWidth(10),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (doctorsModel.name.substring(0, 1).toUpperCase() +
                      doctorsModel.name.substring(1)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '${doctorsModel.specialty} ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Themes.grey, fontSize: 13),
                    ),
                    Text(
                      '(${doctorsModel.reviews.length} reviews)',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Themes.grey, fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.star,
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
