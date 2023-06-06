import 'package:flutter/material.dart';
import 'package:hospital/model/review_model.dart';
import 'package:hospital/theme.dart';

class ReviewsList extends StatefulWidget {
  final ReviewsModel reviewsModel;
  const ReviewsList({required this.reviewsModel, super.key});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  bool _showFullText = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.reviewsModel.name,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < widget.reviewsModel.numStars
                  ? Icons.star
                  : Icons.star_border,
              color: Colors.yellow,
              size: 15,
            );
          }),
        ),
        const SizedBox(
          height: 3,
        ),
        InkWell(
          onTap: () {
            _showFullText = !_showFullText;
            setState(() {});
          },
          child: Column(
            children: [
              Text(
                widget.reviewsModel.review,
                maxLines: _showFullText ? null : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    height: 1.1, // set line height

                    fontSize: 17,
                    color: Themes.grey,
                    decorationThickness: 10),
              ),
              Text(
                _showFullText ? 'show less' : 'show more',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    height: 1.1, // set line height
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Themes.grey,
                    decorationThickness: 10),
              )
            ],
          ),
        )
      ],
    );
  }
}
