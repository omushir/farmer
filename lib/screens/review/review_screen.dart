class ReviewScreen extends StatefulWidget {
  final String farmerId;

  ReviewScreen({required this.farmerId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _ratingController = TextEditingController();
  double _rating = 0;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    try {
      await _firestore.collection('reviews').add({
        'farmerId': widget.farmerId,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'rating': _rating,
        'comment': _ratingController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update farmer's average rating
      final farmerRef = _firestore.collection('farmers').doc(widget.farmerId);
      await _firestore.runTransaction((transaction) async {
        final farmerDoc = await transaction.get(farmerRef);
        final currentRating = farmerDoc.data()?['averageRating'] ?? 0.0;
        final totalReviews = farmerDoc.data()?['totalReviews'] ?? 0;
        
        final newTotalReviews = totalReviews + 1;
        final newAverageRating = 
          ((currentRating * totalReviews) + _rating) / newTotalReviews;

        transaction.update(farmerRef, {
          'averageRating': newAverageRating,
          'totalReviews': newTotalReviews,
        });
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write Review')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
