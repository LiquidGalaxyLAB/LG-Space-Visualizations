# 🚀 Space Visualizations for Liquid Galaxy

## 📄Table of Contents
* [📚 About](#-about)
* [📝 Requirements](#-requirements)
* [👨‍💻 Building from source](#-building-from-source)
* [🌐 Connecting to Liquid Galaxy](#-connecting-to-LG)

<a name="-about"></a>
## 📚 About

Space Visualizations for Liquid Galaxy is an application that showcases the [Mars 2020](https://science.nasa.gov/mission/mars-2020-perseverance/) NASA mission and some of the most famous Earth orbits. The application uses the [Liquid Galaxy](https://www.liquidgalaxy.eu) platform to provide immersive space exploration experiences. In the Mars mission section, users can interactively learn about the mission by visualizing 3D models, technical data, and the path of the Perseverance rover and Ingenuity drone. Users can see Mars from the perspective of the Perseverance rover with more than 220000 photos available. The photos can also be displayed on all Liquid Galaxy screens, providing a very immersive experience.

In the Earth orbit section, a list of orbits can be displayed in both the application and, with a realistic representation, on Liquid Galaxy Google Earth. Users can interact with these orbits and learn more about them.

This project has been started as a [Google Summer of Code](https://summerofcode.withgoogle.com/about) 2024 project with the Liquid Galaxy Org.
Developed by Mattia Baggini
Mentor: Victor Sanchez
Liquid Galaxy Org Director: Andreu Ibañez

<a name="-requirements"></a>
## 📝 Requirements

1. **Device Compatibility:**
   - The application requires an Android tablet running **Android 13 (API level 33)** or higher.

2. **Liquid Galaxy Integration (Optional):**
   - To fully utilize the Liquid Galaxy features, ensure that the **Liquid Galaxy core** is installed. For detailed installation instructions, please refer to the [Liquid Galaxy repository](https://github.com/LiquidGalaxyLAB/liquid-galaxy).

3. **Displaying Rover Photos on Liquid Galaxy (Optional):**
   - To enable the display of rover photos on the Liquid Galaxy screens, install the **display_images_service**. For more information and installation guidelines, visit the [display_images_service repository](https://github.com/0xbaggi/display_images_service).


<a name="-building-from-source"></a>
## 👨‍💻 Building from source

First, open a new terminal and clone the repository with the command:

```bash
git clone https://github.com/LiquidGalaxyLAB/LG-Space-Visualizations.git
```

To use the Google Maps widget, you'll need to set up an API key for the [Google Maps SDK](https://developers.google.com/maps/documentation/android-sdk/overview). Follow these steps:

1. Obtain a Google Maps API Key by following the instructions [here](https://developers.google.com/maps/documentation/android-sdk/get-api-key).
2. Once you have the API key, navigate to the `android/app/main` directory within the cloned repository.
3. Open the **AndroidManifest.xml** file in a text editor.
4. Locate the following section in the **AndroidManifest.xml** file:

```XML
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
```

Now we can run the application, follow these steps:

1. Navigate to the project directory:
   ```bash
   cd LG-Space-Visualizations
   ```
2. Install the necessary dependencies:
   ```bash
   flutter pub get
   ```
3. Launch the app:
   ```bash
   flutter run
   ```
> ❗ **Important:** Ensure you have a tablet device connected or an Android tablet emulator running before executing the `flutter run` command.

<a name="-connecting-to-LG"></a>
## 🌐 Connecting to Liquid Galaxy

1. **Open the Application**: Launch the application on your device and go to the settings page.
![usage1](https://github.com/LiquidGalaxyLAB/LG-Space-Visualizations/blob/development/assets/readme_images/usage1.png?raw=true)
2. **Enter Liquid Galaxy Details**: Insert your Liquid Galaxy information into the form and click "Connect"
![usage2](https://github.com/LiquidGalaxyLAB/LG-Space-Visualizations/blob/development/assets/readme_images/usage2.png?raw=true)
3. **Confirmation**: If a confirmation message appears, your application is successfully connected!
![usage3](https://github.com/LiquidGalaxyLAB/LG-Space-Visualizations/blob/development/assets/readme_images/usage3.png?raw=true)