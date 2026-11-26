# Thadayam - Bus Route Navigation System

## Overview

The Bus Route Mapping module is a Flutter-based application component that visualizes bus routes using Google Maps. It retrieves bus stop information from Firebase Firestore, displays source, destination, and intermediate stops, and draws road-based routes using the Google Maps Directions API.

The module also calculates the total route distance and simulates bus movement based on predefined timing schedules without requiring real-time GPS tracking.

## Features

- **Google Maps Integration:** Displays an interactive Google Map within the Flutter application.
- **Road-Based Route Mapping:** Uses Google Maps Directions API to draw routes along actual roads instead of straight-line connections.
- **Source and Destination Markers:** Displays a common custom image marker for the starting and ending locations.
- **Intermediate Bus Stops:** Displays circular markers for all intermediate stops.
- **Bus Movement Simulation:** Simulates bus movement along the mapped route using predefined schedules, without GPS tracking.
- **Distance Calculation:** Calculates the total distance between consecutive stops using the Haversine formula.
- **Route Visualization:** Displays a thin blue polyline following the road network.
- **Stop Information:** Shows stop names and scheduled timings through marker information windows.
- **Firebase Integration:** Retrieves route and stop information from Cloud Firestore.

## Technology Stack

| Component | Technology |
|---|---|
| Frontend | Flutter |
| Programming Language | Dart |
| Map Integration | Google Maps Flutter |
| Route Generation | Google Maps Directions API |
| Database | Firebase Cloud Firestore |
| HTTP Requests | HTTP Package |
| Distance Calculation | Haversine Formula |
| Bus Movement | Dart Timer and Route Interpolation |

## System Architecture

```text
       Firebase Firestore
               |
               v
       Retrieve Bus Stops
               |
               v
       Prepare Coordinates
               |
               v
       Google Directions API
               |
               v
       Receive Encoded Polyline
               |
               v
       Decode Polyline
               |
               v
       Display Road-Based Route
               |
       +-------+--------+
       |                |
       v                v
  Stop Markers     Distance Calculation
       |                |
       v                v
  Bus Movement      Total KM Display
  Simulation
```

## Firebase Data Integration

The module uses information retrieved from Firebase Firestore.

### Collections

- `busStops`: Stores bus stop names, coordinates, and bus stand information.
- `Routes`: Stores route information and ordered bus stop IDs.
- `Schedules`: Stores bus details and scheduled arrival times at individual stops.

### Stop Data Format

```json
{
  "name": "Thuckalay Bus Stand",
  "lat": 8.249,
  "lng": 77.305,
  "is_busstand": true
}
```

*Note: The coordinates above are illustrative. Use the actual coordinates stored in Firebase.*

## Google Maps API Configuration

The module requires a Google Maps API key.

### Required APIs

1. Maps SDK for Android
2. Directions API

For iOS deployment, enable Maps SDK for iOS as well.

### Setup

1. Open [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select a Google Cloud project.
3. Enable the required Google Maps APIs.
4. Configure a billing account.
5. Generate an API key.
6. Configure appropriate API key restrictions.
7. Add the Maps SDK key to the Android manifest.

Android configuration:

`android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

The Directions API key must also be configured securely for route requests. Avoid committing unrestricted API keys to public repositories.

## Installation and Dependencies

Add the following dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  google_maps_flutter: ^latest
  http: ^latest
  firebase_core: ^latest
  cloud_firestore: ^latest
```

Use compatible package versions for your Flutter SDK.

Run:

```bash
flutter pub get
```

## Route Mapping Workflow

1. Retrieve the ordered list of bus stops from Firebase.
2. Extract latitude and longitude for each stop.
3. Identify the first stop as the source and the last stop as the destination.
4. Pass intermediate stops as waypoints to the Directions API.
5. Receive the encoded road route.
6. Decode the polyline into geographical coordinates.
7. Display the decoded points as a Google Maps polyline.
8. Add markers for source, destination, and intermediate stops.

## Bus Movement Simulation

The bus movement is simulated using predefined schedule timings.

- A timer periodically updates the bus position.
- The current time is compared with consecutive stop timings.
- The bus position is interpolated between route coordinates.
- The bus marker is updated on the map.

**Important:** This is schedule-based simulated movement, not actual GPS tracking. For accurate road-following bus animation, the position should be interpolated along the decoded Directions API route points using cumulative distance and elapsed schedule time.

## Distance Calculation

The Haversine formula is used to calculate the geographical distance between consecutive bus stops.

The total distance is calculated by adding the distances between all consecutive stops.

The result is displayed in kilometres on the map.

**Note:** The Haversine calculation gives approximate straight-line distances between stops. For actual road distance, use the distance values returned by the Directions API.

## Expected Output

The map displays:

- Source and destination using custom image markers.
- Intermediate stops using circular markers.
- A thin blue road-following polyline.
- A moving bus marker based on the predefined schedule.
- Total route distance in kilometres.
- Stop names and scheduled timings when markers are selected.

## Limitations

- Bus movement is simulated and does not represent actual vehicle location.
- Schedule-based movement depends on the accuracy of predefined timings.
- Directions API requires valid API configuration and billing.
- Route accuracy depends on the availability of road data from Google Maps.
- Network connectivity is required to retrieve road routes.

## Future Enhancements

- Real-time GPS-based bus tracking.
- Estimated arrival time (ETA) calculation.
- Traffic-aware route estimation.
- Bus arrival notifications.
- Route optimization and alternative route suggestions.
- Offline route information caching.

## Conclusion

The Bus Route Mapping module provides an interactive visualization of public transportation routes using Flutter, Firebase, and Google Maps. By combining road-based route generation, stop identification, distance calculation, and schedule-based bus movement simulation, it provides users with a clearer understanding of bus journeys and their routes.
