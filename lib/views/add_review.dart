import 'package:blenzo/models/history/get_history.dart';
import 'package:blenzo/services/api/reviews_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewPage extends StatefulWidget {
  final Goods item;
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
  double _rating = 0; // untuk bintang ⭐
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submitReview() async {
    if (_rating == 0 || _controller.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Mohon isi rating dan komentar")));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await AuthenticationApiReviews.addReviews(
        productId: widget.item.product.id,
        transactionId: widget.transactionId,
        rating: _rating.toInt(), // API butuh int
        review: _controller.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context, true); // balik dengan status sukses
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
      appBar: AppBar(title: Text("Review ${widget.item.product.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Beri Rating:", style: TextStyle(fontSize: 16)),
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
            Text("Tulis Ulasan:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Masukkan komentar",
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
                      icon: Icon(Icons.send),
                      label: Text("Kirim"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
