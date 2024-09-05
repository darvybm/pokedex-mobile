# Pokédex App

<!-- Header Images -->
<div style="display: flex; justify-content: center; gap: 10px;" align="center">
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/home_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/pokedex_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

<br>

<div style="text-align: center;" align="center">
    <!-- Custom Badges -->
    <img src="https://img.shields.io/badge/Flutter-%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20-%2302568C?logo=flutter&logoColor=white" alt="Flutter"/>
    <img src="https://img.shields.io/badge/Dart-%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20-%230175C2?logo=dart&logoColor=white" alt="Dart"/>
    <img src="https://img.shields.io/badge/Multiplatform-%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20-%2300BFAE?logo=android&logoColor=white" alt="Multiplatform"/>
    <img src="https://img.shields.io/badge/REST_API-%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20-%2304C2C9?logo=api&logoColor=white" alt="REST API"/>
    <img src="https://img.shields.io/badge/PokeAPI-%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20-%23C4A63B?logo=pokeball&logoColor=white" alt="PokeAPI"/>
</div>

---

This project is a Pokédex mobile application that allows users to access detailed information about various Pokémon species using the API. The application is developed with **Flutter** and **Dart**, using [pokeapi.co](https://pokeapi.co) to obtain Pokémon data and **SQLite** for local data persistence, such as favorite Pokémon and caching API data for faster searches. These technologies ensure smooth performance and an enhanced user experience.

## Index

- [Application](#application)
- [Features](#features)
- [How to Use](#how-to-use)
- [Contributors](#contributors)
- [License](#license)
- [Contact Me](#contact-me)


## Application

**Main Menu**  
The main screen features a menu with key options such as Pokémon of the Day, Favorites List, Pokédex, and a Pokémon Gallery.

Displays a random Pokémon each day, saved using Shared Preferences.

<div>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/home_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/home_screen_2.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/home_screen_3.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

---

**Favorites List**  
Allows users to mark and easily access their favorite Pokémon.

<div>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/favoritos_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/favoritos_screen_2.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

---

**Pokédex**  
A comprehensive list of Pokémon with extensive details about each one.

<div>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/pokedex_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/pokedex_screen_2.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/pokedex_screen_3.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

---

**Gallery**  
Displays images of the available Pokémon for a rich visual experience.

<div>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/gallery_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/gallery_details_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/gallery_details_2_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

---

**Pokémon Details**  
When selecting a Pokémon, detailed information is displayed such as stats, abilities, and evolutions.

<div>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_datos_1_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_datos_2_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_moves_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/details_evoluciones_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
</div>

---

## Features

- **Data Persistence**  
  Uses SQLite to store favorite Pokémon and images from the Gallery.

- **Visual Design**  
  Interface with Cards to present information attractively, using colors representative of each Pokémon type.

- **Pagination**  
  Pokémon are loaded in blocks of 20 from the pokeapi.co API.

- **Responsive Search**  
  Find Pokémon by name or ID, with support for uppercase, lowercase, and partial names.
  <div>
    <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/find_by_id_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
    <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/screens/find_by_name_screen.jpg" style="width: 220px; height: 430px; object-fit: cover"/>
  </div>

- **Transitions and Animations**  
  Custom transitions and animations to enhance the user experience.

- **Habitat Image Generation**  
  AI-generated images to represent each Pokémon's habitat.
  
  <table>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/bug.jpg" width="130px" alt="Bug"/>
        <br />
        <sub><b>Bug</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/dark.jpg" width="130px" alt="Dark"/>
        <br />
        <sub><b>Dark</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/dragon.jpg" width="130px" alt="Dragon"/>
        <br />
        <sub><b>Dragon</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/electric.jpg" width="130px" alt="Electric"/>
        <br />
        <sub><b>Electric</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/fairy.jpg" width="130px" alt="Fairy"/>
        <br />
        <sub><b>Fairy</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/fighting.jpg" width="130px" alt="Fighting"/>
        <br />
        <sub><b>Fighting</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/fire.jpg" width="130px" alt="Fire"/>
        <br />
        <sub><b>Fire</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/flying.jpg" width="130px" alt="Flying"/>
        <br />
        <sub><b>Flying</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/ghost.jpg" width="130px" alt="Ghost"/>
        <br />
        <sub><b>Ghost</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/grass.jpg" width="130px" alt="Grass"/>
        <br />
        <sub><b>Grass</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/ground.jpg" width="130px" alt="Ground"/>
        <br />
        <sub><b>Ground</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/ice.jpg" width="130px" alt="Ice"/>
        <br />
        <sub><b>Ice</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/normal.jpg" width="130px" alt="Normal"/>
        <br />
        <sub><b>Normal</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/poison.jpg" width="130px" alt="Poison"/>
        <br />
        <sub><b>Poison</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/psychic.jpg" width="130px" alt="Psychic"/>
        <br />
        <sub><b>Psychic</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/rock.jpg" width="130px" alt="Rock"/>
        <br />
        <sub><b>Rock</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/steel.jpg" width="130px" alt="Steel"/>
        <br />
        <sub><b>Steel</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="#">
        <img src="https://github.com/darvybm/pokedex-mobile/blob/main/assets/images/backgrounds/water.jpg" width="130px" alt="Water"/>
        <br />
        <sub><b>Water</b></sub>
      </a>
    </td>
  </tr>
  </table>


- **Color Assignment with `Colors.dart` Class**  
    A small service called `color.dart` was developed, where a set of colors is defined for each Pokémon type. This allows these colors to be used later for gradients, backgrounds, and more.
  
    <table border="1" cellpadding="10" style="border-collapse: collapse; width: 100%; text-align: left;">
    <thead>
      <tr>
        <th>Tipo</th>
        <th>Color</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Bug</td>
        <td><img src="https://via.placeholder.com/20/92BD2D/92BD2D?text=+" alt="Bug Color"/> #92BD2D</td>
      </tr>
      <tr>
        <td>Dark</td>
        <td><img src="https://via.placeholder.com/20/585660/585660?text=+" alt="Dark Color"/> #585660</td>
      </tr>
      <tr>
        <td>Water</td>
        <td><img src="https://via.placeholder.com/20/539DDF/539DDF?text=+" alt="Water Color"/> #539DDF</td>
      </tr>
      <tr>
        <td>Electric</td>
        <td><img src="https://via.placeholder.com/20/F2D94E/F2D94E?text=+" alt="Electric Color"/> #F2D94E</td>
      </tr>
      <tr>
        <td>Fairy</td>
        <td><img src="https://via.placeholder.com/20/EF90E6/EF90E6?text=+" alt="Fairy Color"/> #EF90E6</td>
      </tr>
      <tr>
        <td>Fire</td>
        <td><img src="https://via.placeholder.com/20/FBA64C/FBA64C?text=+" alt="Fire Color"/> #FBA64C</td>
      </tr>
      <tr>
        <td>Fighting</td>
        <td><img src="https://via.placeholder.com/20/D3425F/D3425F?text=+" alt="Fighting Color"/> #D3425F</td>
      </tr>
      <tr>
        <td>Flying</td>
        <td><img src="https://via.placeholder.com/20/8AA5DA/8AA5DA?text=+" alt="Flying Color"/> #8AA5DA</td>
      </tr>
      <tr>
        <td>Ghost</td>
        <td><img src="https://via.placeholder.com/20/5160B7/5160B7?text=+" alt="Ghost Color"/> #5160B7</td>
      </tr>
      <tr>
        <td>Grass</td>
        <td><img src="https://via.placeholder.com/20/60BD58/60BD58?text=+" alt="Grass Color"/> #60BD58</td>
      </tr>
      <tr>
        <td>Ground</td>
        <td><img src="https://via.placeholder.com/20/DA7C4D/DA7C4D?text=+" alt="Ground Color"/> #DA7C4D</td>
      </tr>
      <tr>
        <td>Ice</td>
        <td><img src="https://via.placeholder.com/20/51C4B6/51C4B6?text=+" alt="Ice Color"/> #51C4B6</td>
      </tr>
      <tr>
        <td>Normal</td>
        <td><img src="https://via.placeholder.com/20/9FA19E/9FA19E?text=+" alt="Normal Color"/> #9FA19E</td>
      </tr>
      <tr>
        <td>Poison</td>
        <td><img src="https://via.placeholder.com/20/B763CF/B763CF?text=+" alt="Poison Color"/> #B763CF</td>
      </tr>
      <tr>
        <td>Psychic</td>
        <td><img src="https://via.placeholder.com/20/FA8582/FA8582?text=+" alt="Psychic Color"/> #FA8582</td>
      </tr>
      <tr>
        <td>Rock</td>
        <td><img src="https://via.placeholder.com/20/C9BC8A/C9BC8A?text=+" alt="Rock Color"/> #C9BC8A</td>
      </tr>
      <tr>
        <td>Steel</td>
        <td><img src="https://via.placeholder.com/20/478491/478491?text=+" alt="Steel Color"/> #478491</td>
      </tr>
      <tr>
        <td>Dragon</td>
        <td><img src="https://via.placeholder.com/20/539DDF/539DDF?text=+" alt="Dragon Color"/> #539DDF</td>
      </tr>
    </tbody>
  </table>


---

## How to Use

### Requirements

- **Dart SDK**: Ensure that you have the Dart SDK installed on your machine.
- **Flutter SDK**: Install Flutter SDK version 3.22.2.

   ```bash
   flutter --version
   ```

   Make sure the version is 3.22.2.

> [!CAUTION]  
> The app may not work with recent versions of Flutter due to some deprecations. It is recommended to use Flutter SDK version 3.22.2.

To run the application, follow these steps:

1. **Clone the Repository**

   Clone the repository to your local machine using Git:

   ```bash
   git clone https://github.com/darvybm/pokedex-mobile.git
   ```

2. **Install Dependencies**

   Navigate to the project directory and run the following command to install all the necessary dependencies:

   ```bash
   cd pokedex-mobile
   flutter pub get
   ```

3. **Configure the Project**

   Make sure your `pokeapi.co` API is set up if needed. You can modify the configurations in the `lib/services/api_service.dart` file.

4. **Run the Application**

   Run the application on an emulator or connected device with:

   ```bash
   flutter run
   ```

   You can also build a production version with:

   ```bash
   flutter build apk
   ```

## Contributors
Here are the contributors to this project:

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/darvybm">
        <img src="https://github.com/darvybm.png" width="100px;" alt="Your Name"/>
        <br />
        <sub><b>Darvy Betances</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/eduardoMR179">
        <img src="https://github.com/eduardoMR179.png" width="100px;" alt="Your Name"/>
        <br />
        <sub><b>Eduardo Martínez</b></sub>
      </a>
    </td>
  </tr>
</table>

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact Me

<p align="center">
  <a href="https://www.linkedin.com/in/darvybm" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-@darvybm-blue?style=flat&logo=linkedin&logoColor=white" alt="LinkedIn Badge"/>
  </a>
  <a href="mailto:darvybm@gmail.com" target="_blank">
    <img src="https://img.shields.io/badge/Email-Contact%20Me-orange" alt="Email Badge"/>
  </a>
</p>
