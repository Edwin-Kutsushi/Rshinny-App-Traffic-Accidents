# Rshinny-App-Traffic-Accidents

Edwin's Accident Rshinny App: https://edwin-mutimba-rshinnyapp.shinyapps.io/EdwinMutimbaRshinnyApp/

Defining the Question
Our main objective is to come up with widgets that can be used to display the accidents visually. 

Metrics of Success
Part 1, clean the data; check validity of georaphical regions, check for duplicates, remove nulls, remove outliers.

Part 2, deploy to widgets.

Part 3, identify relationships between variables when running the app.

Part 4, publish the app and make it public.

## Understanding the Context

The accident dataset is collection of records detailing traffic accidents. The dataset includes variables such as:

Location data (e.g., latitude, longitude, state names)
Time-related data (e.g., day of the week, time of day, quarter of the year)
Route information (e.g., route categories)
Accident characteristics (e.g., day type, number of incidents, specific case IDs)

#### Key Insights for Analysis:

The purpose of analyzing this dataset is to identify patterns and trends related to traffic accidents that can inform safety measures, traffic management, and policy decisions. For example, understanding which times of day or which routes have the highest frequency of accidents can help local authorities or road safety agencies take preemptive action.

#### Overview of the R Shiny Code

The provided R Shiny code creates an interactive web application to analyze and visualize the accident dataset. This app enables users to filter data, view maps, and explore accident trends through graphs. Here’s an in-depth explanation of how the code works and its main components:

1. User Interface (UI) Structure:
The ui section defines the layout and user input elements:

Sidebar Panel:
Dropdowns and multiple-choice selectors allow users to filter the dataset by:
State(s)
Route categories
Day quarters
Day types (e.g., weekday or weekend)
Quarter of the year
Main Panel:
Displays the map (leafletOutput) to visualize accident locations.
Outputs a text summary showing the total number of accidents that match the selected filters.
Two plots:
Line plot to show accident trends by month and route category.
Bar plot to display accident counts by day of the week in descending order.
2. Server Logic:
The server function processes user input and outputs the visualizations:

Reactive Data Filtering:

The filtered_data reactive function dynamically filters the dataset based on user selections, such as state, route category, and day type.
validate ensures there is data to display; otherwise, it shows a warning message.
Map Rendering (leaflet):

Uses leaflet to create an interactive map showing accident locations with markers.
The color of the markers represents different route categories, defined by route_colors.
Plots:

Line Plot (accident_trend): Displays accident trends by month and route category. The plot arranges months from January to December and matches the colors of the route categories with those used in the map.
Bar Plot (day_type_distribution): Shows the number of accidents for each day of the week, ordered by highest to lowest count, with days arranged in their natural order (Monday to Sunday).

Table Output:
Displays accident counts grouped by state and route category for a summarized overview.
#### Key Features of the R Shiny Application:

Interactive Filtering: Users can filter the dataset by different criteria to view customized accident data.
Dynamic Mapping: The map visualizes accident locations, with color-coded markers representing different route categories.
Consistent Color Scheme: The same colors are used in both the map and line plot to represent route categories, ensuring visual consistency.
Time-Based Trends: The line plot helps identify monthly trends in accidents for different route categories, revealing potential seasonal patterns.
Comparative Analysis: The bar plot allows users to compare the number of accidents across days of the week, ordered from the highest to lowest count.
Potential Use Cases:
Traffic Management and Safety Measures: Authorities can use the insights to identify high-risk times and places and deploy resources effectively (e.g., traffic police, public awareness campaigns).
Public Awareness: Informing the public about peak accident times and high-risk routes.
Infrastructure Planning: Insights can guide infrastructure improvements or policy changes to enhance road safety.

Dataset [https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars].

Release
This is the first release. Meta Team Time Data Report Distributed under the GNU General Public License v3.0. See LICENSE for more information https://github.com/Edwin-Kutsushi/Rshinny-App-Traffic-Accidents/edit/main/README.md. 

Contribution
Contributing Fork it https://github.com/Edwin-Kutsushi/Rshinny-App-Traffic-Accidents/edit/main/README.md. Create your feature branch (git checkout -b feature/fooBar) Commit your changes (git commit -am 'Add some fooBar') Push to the branch (git push origin feature/fooBar) Create a new Pull Request
