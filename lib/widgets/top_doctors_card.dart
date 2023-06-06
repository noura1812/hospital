import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/screens/doctors_screen.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';

class TopDoctorsCard extends StatelessWidget {
  final DoctorsModel doctorsModel;

  const TopDoctorsCard({required this.doctorsModel, super.key});

  @override
  Widget build(BuildContext context) {
    double stars = 0;
    for (var review in doctorsModel.reviews) {
      stars += review.numStars;
    }
    stars = stars / doctorsModel.reviews.length;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DoctorsScreen.routName,
            arguments: doctorsModel);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Themes.lightBackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        width: SizeConfig.screenWidth * .41,
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 43,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(doctorsModel.imageUrl),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: getProportionateScreenWidth(15),
            ),
            Text(
              'Dr.${doctorsModel.name.substring(0, 1).toUpperCase() + doctorsModel.name.substring(1).split(' ')[0]}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: getProportionateScreenWidth(10),
            ),
            Text(
              doctorsModel.specialty,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Themes.grey, fontSize: 13),
            ),
            SizedBox(
              height: getProportionateScreenWidth(7),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 15,
                    );
                  }),
                ),
                Text(
                  ' ${doctorsModel.reviews.length > 999 ? ((doctorsModel.reviews.length) / 1000).floor() : doctorsModel.reviews.length}${doctorsModel.reviews.length > 999 ? 'k' : ''} reviews',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Themes.grey, fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
