import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//OPERATIONS CLASS
class MyData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference meds =
      FirebaseFirestore.instance.collection('Pharmacies');

  //dynamically getting pharmacy info
  String? getPharmacyName() {
    final User? user = _auth.currentUser;
    if (user != null) {
      String userEmail = user.email!;
      List<String> pharmacies = [
        'BasicPharma',
        'MedRevive',
        'QuantumMeds',
        'TariqMedical',
        'VitalBlend',
      ];

      String lowercaseEmail = userEmail.toLowerCase();

      for (String pharmacy in pharmacies) {
        if (lowercaseEmail.contains(pharmacy.toLowerCase())) {
          return pharmacy;
        }
      }
    }
    return null;
  }

  String getBranchFromEmail() {
    final User? user = _auth.currentUser;
    String username = user!.email!.split('@').first;

    for (int i = 0; i < username.length; i++) {
      if (username.codeUnitAt(i) >= 48 && username.codeUnitAt(i) <= 57) {
        return 'Branch${username[i]}';
      }
    }

    return 'Branch1';
  }

  //CREATE (4:51AM)
  Future<void> addMedicine(
      medicineIdController,
      brandNameController,
      companyNameController,
      formulationController,
      mrpController,
      packSizeController,
      registrationNumberController) async {
    String? pharmacyName = getPharmacyName();
    String? branch = getBranchFromEmail();
    if (pharmacyName != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Pharmacies')
                .doc(pharmacyName)
                .get();

        // Determine the branch data
        Map<String, dynamic> data = snapshot.data() ?? {};
        Map<String, dynamic> branchesMap = data['branches'] ?? {};
        Map<String, dynamic> branchData =
            branchesMap[getBranchFromEmail()] ?? {};

        // Add the new medicine to medicinesMap under the appropriate branch
        Map<String, dynamic> medicinesMap = branchData['medicines'] ?? {};
        medicinesMap[medicineIdController] = {
          'Brand Name': brandNameController,
          'Company Name': companyNameController,
          'Formulation': formulationController,
          'MRP': mrpController,
          'Pack Size': packSizeController,
          'reg_no': registrationNumberController
        };

        await FirebaseFirestore.instance
            .collection('Pharmacies')
            .doc(pharmacyName)
            .update({'branches.$branch.medicines': medicinesMap});

        print('New medicine added successfully');
      } catch (e) {
        print('Error adding medicine: $e');
      }
    }
  }

  //READ (XX:XX)
  Stream<List<Map<String, dynamic>>> parseData() {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> querySnapshot =
        FirebaseFirestore.instance
            .collection('Pharmacies')
            .doc(getPharmacyName())
            .snapshots();

    return querySnapshot.map((snapshot) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data != null) {
        List<Map<String, dynamic>> parsedDataList = [];

        Map<String, dynamic> branchesMap = data['branches'] ?? {};
        Map<String, dynamic> branchData =
            branchesMap[getBranchFromEmail()] ?? {};
        Map<String, dynamic> medicinesMap = branchData['medicines'] ?? {};

        medicinesMap.forEach((medId, medData) {
          Map<String, dynamic> medicine = {
            'medId': medId,
            'regNo': medData['reg_no'],
            'companyName': medData['Company Name'],
            'Brand Name': medData['Brand Name'],
            'Formulation': medData['Formulation'],
            'Market Price': medData['MRP'],
            'Packet Size': medData['Pack Size']
          };
          parsedDataList.add(medicine);
        });

        return parsedDataList;
      }
      return [];
    });
  }

  //UPDATE KILL MEEE
  Future<void> updateMedicine(
      medicineIdController,
      brandNameController,
      companyNameController,
      formulationController,
      mrpController,
      packSizeController,
      registrationNumberController) async {
    try {
      String? pharmacyName = getPharmacyName();
      if (pharmacyName == null) {
        print('Failed to get pharmacy name');
        return;
      }
      String? branch = getBranchFromEmail();

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Pharmacies')
          .doc(pharmacyName)
          .get();

      // Determine the branch data
      Map<String, dynamic> data = snapshot.data() ?? {};
      Map<String, dynamic> branchesMap = data['branches'] ?? {};
      Map<String, dynamic> branchData = branchesMap[branch] ?? {};

      Map<String, dynamic> medicinesMap = branchData['medicines'] ?? {};
      if (medicinesMap.containsKey(medicineIdController)) {
        medicinesMap[medicineIdController] = {
          'Brand Name': brandNameController,
          'Company Name': companyNameController,
          'Formulation': formulationController,
          'MRP': mrpController,
          'Pack Size': packSizeController,
          'reg_no': registrationNumberController
        };

        await FirebaseFirestore.instance
            .collection('Pharmacies')
            .doc(pharmacyName)
            .update({'branches.$branch.medicines': medicinesMap});

        print('Medicine updated successfully');
      } else {
        print('Medicine with ID $medicineIdController does not exist');
      }
    } catch (e) {
      print('Error updating medicine: $e');
    }
  }

  //DELETE ..

  Future<void> deleteMedicine(MedID) async {
    String? pharmacyName = getPharmacyName();
    String? branch = getBranchFromEmail();
    if (pharmacyName != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Pharmacies')
                .doc(pharmacyName)
                .get();

        Map<String, dynamic> data = snapshot.data() ?? {};
        Map<String, dynamic> branchesMap = data['branches'] ?? {};
        Map<String, dynamic> branchData =
            branchesMap[getBranchFromEmail()] ?? {};
        Map<String, dynamic> medicinesMap = branchData['medicines'] ?? {};

        if (medicinesMap.containsKey(MedID)) {
          medicinesMap.remove(MedID);
        }

        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.update(
          FirebaseFirestore.instance.collection('Pharmacies').doc(pharmacyName),
          {'branches.$branch.medicines': medicinesMap},
        );

        await batch.commit();

        print('Medicine deleted successfully');
      } catch (e) {
        print('Error Deleting medicine: $e');
      }
    }
  }

  // Stream<List<Map<String, dynamic>>> parseData() {
  //   final Stream<DocumentSnapshot<Map<String, dynamic>>> querySnapshot =
  //       FirebaseFirestore.instance
  //           .collection('Pharmacies')
  //           .doc(getPharmacyName(user.email))
  //           .snapshots();

  //   return querySnapshot.map((snapshot) {
  //     final Map<String, dynamic>? data = snapshot.data();
  //     if (data != null) {
  //       List<Map<String, dynamic>> parsedDataList = [];

  //       Map<String, dynamic> branchesMap = data['branches'] ?? {};

  //       branchesMap.forEach((branchKey, branchData) {
  //         Map<String, dynamic> medicinesMap = branchData['medicines'] ?? {};

  //         medicinesMap.forEach((medId, medData) {
  //           Map<String, dynamic> medicine = {
  //             'medId': medId,
  //             'regNo': medData['reg_no'],
  //             'companyName': medData['Company Name'],
  //             'Brand Name': medData['Brand Name'],
  //             'Formulation': medData['Formulation'],
  //             'Market Price': medData['MRP'],
  //           };
  //           parsedDataList.add(medicine);
  //         });
  //       });

  //       return parsedDataList;
  //     } else {
  //       return [];
  //     }
  //   });
  // }
}
