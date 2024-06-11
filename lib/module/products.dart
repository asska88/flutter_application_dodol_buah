import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;


  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      });

      factory Product.fromFirestore(DocumentSnapshot doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; 
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price']?.toDouble() ?? 0.0,
          description: data['description'] ?? '',
        );
      }
}

// final List<Products> products = [
//   Products(
//       id: 1,
//       name: 'pineapple',
//       image: 'assets/images/pineapple.png',
//       price: 50.000,
//       description:
//           'Nanas (Ananas comosus) adalah buah tropis yang berasal dari Amerika Selatan dan telah dibudidayakan di berbagai wilayah tropis di seluruh dunia. Buah ini dikenal karena rasanya yang unik, perpaduan antara manis dan asam, serta aromanya yang khas'),
//   Products(
//       id: 2,
//       name: 'orange wokam',
//       image: 'assets/images/orange.png',
//       price: 30.000,
//       description:
//           'Jeruk wokam adalah jenis jeruk mandarin yang berasal dari Papua Nugini. Jeruk ini memiliki ciri khas kulit yang tipis dan mudah dikupas, dengan warna oranye cerah yang menarik. Daging buahnya berwarna oranye terang, bertekstur lembut, dan memiliki rasa manis yang menyegarkan dengan sedikit rasa asam.'),
//   Products(
//       id: 3,
//       name: 'avocado',
//       image: 'assets/images/avocado.png',
//       price: 30.000,
//       description:
//           'Alpukat (Persea americana) adalah buah yang unik dan lezat yang berasal dari Amerika Tengah dan Meksiko. Buah ini dikenal karena teksturnya yang lembut seperti mentega dan rasanya yang kaya. Alpukat memiliki kulit berwarna hijau tua hingga ungu kehitaman, tergantung varietasnya. Daging buahnya berwarna hijau muda hingga kuning pucat, dengan biji besar di tengahnya.'),
//   Products(
//       id: 4,
//       name: 'apple fuji',
//       image: 'assets/images/apple.png',
//       price: 29.000,
//       description:
//           'Apel Fuji adalah jenis apel yang dikembangkan di Jepang pada akhir tahun 1930-an. Apel ini merupakan hasil persilangan antara apel Red Delicious dan Ralls Janet. Apel Fuji memiliki rasa yang manis dan renyah, dengan sedikit rasa asam.'),
//   Products(
//       id: 5,
//       name: 'pineapple',
//       image: 'assets/images/pineapple.png',
//       price: 50.000,
//       description:
//           'Nanas (Ananas comosus) adalah buah tropis yang berasal dari Amerika Selatan dan telah dibudidayakan di berbagai wilayah tropis di seluruh dunia. Buah ini dikenal karena rasanya yang unik, perpaduan antara manis dan asam, serta aromanya yang khas'),
//   Products(
//       id: 6,
//       name: 'pineapple',
//       image: 'assets/images/pineapple.png',
//       price: 50.000,
//       description:
//           'Nanas (Ananas comosus) adalah buah tropis yang berasal dari Amerika Selatan dan telah dibudidayakan di berbagai wilayah tropis di seluruh dunia. Buah ini dikenal karena rasanya yang unik, perpaduan antara manis dan asam, serta aromanya yang khas'),
//   Products(
//       id: 7,
//       name: 'orange wokam',
//       image: 'assets/images/orange.png',
//       price: 30.000,
//       description:
//           'Jeruk wokam adalah jenis jeruk mandarin yang berasal dari Papua Nugini. Jeruk ini memiliki ciri khas kulit yang tipis dan mudah dikupas, dengan warna oranye cerah yang menarik. Daging buahnya berwarna oranye terang, bertekstur lembut, dan memiliki rasa manis yang menyegarkan dengan sedikit rasa asam.'),
//   Products(
//       id: 8,
//       name: 'avocado',
//       image: 'assets/images/avocado.png',
//       price: 30.000,
//       description:
//           'Alpukat (Persea americana) adalah buah yang unik dan lezat yang berasal dari Amerika Tengah dan Meksiko. Buah ini dikenal karena teksturnya yang lembut seperti mentega dan rasanya yang kaya. Alpukat memiliki kulit berwarna hijau tua hingga ungu kehitaman, tergantung varietasnya. Daging buahnya berwarna hijau muda hingga kuning pucat, dengan biji besar di tengahnya.'),
//   Products(
//       id: 9,
//       name: 'apple fuji',
//       image: 'assets/images/apple.png',
//       price: 29.000,
//       description:
//           'Apel Fuji adalah jenis apel yang dikembangkan di Jepang pada akhir tahun 1930-an. Apel ini merupakan hasil persilangan antara apel Red Delicious dan Ralls Janet. Apel Fuji memiliki rasa yang manis dan renyah, dengan sedikit rasa asam.'),
//   Products(
//       id: 10,
//       name: 'pineapple',
//       image: 'assets/images/pineapple.png',
//       price: 50.000,
//       description:
//           'Nanas (Ananas comosus) adalah buah tropis yang berasal dari Amerika Selatan dan telah dibudidayakan di berbagai wilayah tropis di seluruh dunia. Buah ini dikenal karena rasanya yang unik, perpaduan antara manis dan asam, serta aromanya yang khas'),
// ];
