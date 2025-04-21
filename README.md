# CoffeeOrderApp

# Pages
- Launch Screen
- Login Screen
- Home Screen
- Favorites Screen
- Cart Screen
- Detail Screen

# Compatibility
- Compatible with iPhone.
- Compatible with portrait-oriented iPhone.

# Architecture
MVVM (Model-View-ViewModel) Architecture
This project is built using the MVVM (Model-View-ViewModel) architecture. MVVM is a design pattern that helps organize code by separating the user interface (View) from the business logic (Model), improving testability and code readability.

Model: Represents the data layer of the application. It handles data structures, API calls, or database operations.

View: The user interface that displays data and captures user interactions.

ViewModel: Acts as a bridge between the Model and the View. It processes data, prepares it for display, and communicates with the View through data binding.

This structure provides a modular and maintainable codebase by clearly separating UI logic from application logic.

# Features
- Used Mock Json
- List
- Filter By Category
- Search Bar
- Favorites
- My Card
- Responsive UI
- Localizable (Turkish + English)

# Technologies
- Programmatic UI (SnapKit)
- MVVM
- Generic Network Layer
- Error Handling
- Tabbar
- Page Control
- Animations
- Protocol Oriented Programming (POP)
- Notification Center
- Delegate
- Callback Closures
- Combine
- Core Data
- User Defaults
- Key Chain
- Depedency Injection
- Singelton
- Manuel Caching Image Mechanism (CacheManager)
- Localizable
- Unit Tests

# 3rd Party Libraries
> <a href="https://github.com/SnapKit/SnapKit.git">SnapKit</a>

# Installing SnapKit using Swift Package Manager (SPM)
To integrate SnapKit into the project using Swift Package Manager, follow these steps:
Open the project in Xcode.
From the top menu, go to File -> Add Packages.
In the search bar, type the following URL to add SnapKit:
```bash
(https://github.com/SnapKit/SnapKit)
```
Select the version you want to install (the latest version is recommended) and click Add Package.
Once added, SnapKit will be available for use in the project.
Now you can import SnapKit in your files where needed:
```bash
import SnapKit
```
This allows you to start using SnapKit for creating responsive layouts in your project.


# UIs
<img src="https://github.com/user-attachments/assets/9a8636a7-bb55-4726-a6b1-f09b1fa733c3" alt="splash" width="150">
<img src="https://github.com/user-attachments/assets/646d44e2-7d0e-43f1-a952-d330fe52dcc4" alt="login" width="150">
<img src="https://github.com/user-attachments/assets/32147567-7269-4454-b5e2-5a670aea5bbc" alt="home" width="150">
<img src="https://github.com/user-attachments/assets/9d3dd093-d210-43e5-ba31-7ab6d42096b7" alt="detail" width="150">
<img src="https://github.com/user-attachments/assets/ac2bd96e-aa5f-4906-b161-32ccf30ed49b" alt="favorite" width="150">
<img src="https://github.com/user-attachments/assets/462b4548-35e0-4c55-b17b-b8f44901bfb8" alt="search" width="150">
<img src="https://github.com/user-attachments/assets/d147c16b-41c1-41bd-ac17-ac15fc3a14df" alt="filter" width="150">
<img src="https://github.com/user-attachments/assets/4ef82c3e-5e19-4c46-97a3-e88ffa025f81" alt="cart" width="150">
<img src="https://github.com/user-attachments/assets/16d2b69b-72b2-43a5-9b2c-42a18bf2287d" alt="cartItemDelete" width="150">
<img src="https://github.com/user-attachments/assets/4db3068b-84ee-4890-9ac8-44249f1618d4" alt="orderSuccess" width="150">


# Demo
https://github.com/user-attachments/assets/84c70774-6033-4c3a-8b36-8061e7c46374

# Installation
1. Clone the Repository
Clone the project to your local machine using the following command in your terminal:
```bash
git clone https://github.com/MineRala/CoffeeOrderApp.git
```
2. Install Dependencies
To install the third-party dependencies used in the project, run the following command:
```bash
swift package resolve
```
3. Open and Run the Project in Xcode
Open the project in Xcode and run it by pressing Cmd + R.






