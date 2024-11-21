class ProductListingScreen extends StatefulWidget {
  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  List<String> _imageUrls = [];

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final product = Product(
          id: DateTime.now().toString(),
          farmerId: FirebaseAuth.instance.currentUser!.uid,
          name: _nameController.text,
          category: _selectedCategory,
          price: double.parse(_priceController.text),
          quantity: double.parse(_quantityController.text),
          unit: _selectedUnit,
          description: _descriptionController.text,
          images: _imageUrls,
          harvestDate: _selectedHarvestDate,
          isOrganic: _isOrganic,
        );

        await _firestore.collection('products').add(product.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Products')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .where('farmerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final product = Product.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>
              );
              return ProductCard(product: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
