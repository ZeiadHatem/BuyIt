import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/product.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Products products) {
    _firestore.collection(kProductCollection).add({
      kProductName: products.pName,
      kProductPrice: products.pPrice,
      kProductDescription: products.pDescription,
      kProductCategory: products.pCategory,
      kProductImageLocation: products.pLocation
    });
  }

  Stream<QuerySnapshot> loadProduct() {
    return _firestore.collection(kProductCollection).snapshots();
  }

  deleteProduct(documentId) {
    return _firestore.collection(kProductCollection).doc(documentId).delete();
  }

  updateProduct(data, documentId) {
    return _firestore
        .collection(kProductCollection)
        .doc(documentId)
        .update(data);
  }

  storeOrders(data, List<Products> product) {
    var collectionData = _firestore.collection(kOrdersCollection).doc();
    collectionData.set(data);
    for (var product in product) {
      collectionData.collection(kOrdersDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductCount: product.pCount,
        kProductImageLocation: product.pLocation,
        kProductCategory: product.pCategory
      });
    }
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(kOrdersCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore.collection(kOrdersCollection).doc(documentId).collection(kOrdersDetails).snapshots();
  }
}
