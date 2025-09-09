import 'package:blenzo/models/history/get_history.dart';
import 'package:blenzo/services/api/reviews_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewPage extends StatefulWidget {
  final Kultum item;
  final int transactionId;

  const ReviewPage({
    super.key,
    required this.item,
    required this.transactionId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submitReview() async {
    if (_rating == 0 || _controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kindly leave your rating and comment")),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await AuthenticationApiReviews.addReviews(
        productId: widget.item.product.id,
        transactionId: widget.transactionId,
        rating: _rating.toInt(),
        review: _controller.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(
          "Review ${widget.item.product.name}",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            color: AppColor.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rate Now:",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: AppColor.text,
                ),
              ),
              SizedBox(height: 8),
              StarRating(
                rating: _rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                color: Colors.amber,
                starCount: 5,
              ),
              SizedBox(height: 24),
              Text(
                "Leave a Review:",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: AppColor.text,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Write a comment...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitReview,
                        icon: Icon(Icons.send, color: AppColor.neutral),
                        label: Text(
                          "Send",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: AppColor.neutral,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
