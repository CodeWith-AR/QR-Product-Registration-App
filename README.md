# QR Product Registration App

A Flutter-based mobile application that enables users to register products by scanning QR codes, securely manage product information, and receive expiration reminders.
The app integrates Firebase Authentication and Cloud Firestore for secure user management and cloud data storage.

---

## 📱 Features

- 🔐 Sign in with Google
- 👤 User Authentication using Firebase
- 📷 QR Code Scanner
- 📝 Manual Product Registration
- 📦 Product Management Dashboard
- 📅 Purchase & Expiry Date Tracking
- ⏰ Expiry Reminder Settings
- 🔔 Advance Notification Preferences
- ☁️ Cloud Firestore Integration
- 👤 User Profile & Settings
- 📱 Clean and Responsive Flutter UI

---

## 🛠 Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Google Sign-In
- Mobile Scanner (QR Scanner)
- Shared Preferences

---

## 📂 Project Structure

```
lib/
├── core/
├── models/
├── services/
├── repositories/
├── viewmodels/
├── views/
│   ├── auth/
│   ├── dashboard/
│   ├── scanner/
│   ├── product/
│   └── profile/
├── widgets/
└── main.dart
```

---
## 📸 App Screenshots

<table align="center">
  <tr>
    <td align="center">
      <img src="assets/images/img.png" width="220"/><br>
      <b>Splash Screen</b>
    </td>
    <td align="center">
      <img src="assets/images/img_1.png" width="220"/><br>
      <b>Login Screen</b>
    </td>
    <td align="center">
      <img src="assets/images/img_20.png" width="220"/><br>
      <b>Dashboard</b>
    </td>
  </tr>

  <tr>
    <td align="center">
      <img src="assets/images/img_3.png" width="220"/><br>
      <b>Product Registration</b>
    </td>
    <td align="center">
      <img src="assets/images/img_4.png" width="220"/><br>
      <b>Updated Dashboard</b>
    </td>
    <td align="center">
      <img src="assets/images/img_5.png" width="220"/><br>
      <b>QR Scanner</b>
    </td>
  </tr>

  <tr>
    <td align="center">
      <img src="assets/images/img_6.png" width="220"/><br>
      <b>Scan Product</b>
    </td>
    <td></td>
    <td></td>
  </tr>
</table>

---

## 🚀 Getting Started

### Clone the Repository

```bash
git clone https://github.com/CodeWith-AR/qr-product-registration-app.git
```

### Navigate to the Project

```bash
cd qr-product-registration-app
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

---

## 🔥 Firebase Setup

1. Create a Firebase project.
2. Enable **Google Authentication**.
3. Enable **Cloud Firestore**.
4. Add your Android SHA-1 fingerprint.
5. Download the `google-services.json` file.
6. Place it in:

```
android/app/google-services.json
```

---

## 📌 Future Improvements

- Push Notifications
- Email & SMS Reminders
- Product Warranty Tracking
- Product History
- Product Categories
- Multi-device Synchronization
- Dark Mode
- Product Search & Filters

---

## 👨‍💻 Author

**Muhammad Abdur Rehman**

- LinkedIn: https://www.linkedin.com/in/rehman90
- GitHub: https://github.com/CodeWith-AR

---

## 📄 License

This project is developed for educational and portfolio purposes.
