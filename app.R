# Load necessary libraries
library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(ggplot2)
library(forcats)

# Load and transform the dataset
accident_data <- read.csv("accident_clean1.csv")

# Dynamically create a color palette for each unique route category
unique_routes <- unique(accident_data$route_category)
route_colors <- colorFactor(palette = rainbow(length(unique_routes)), domain = unique_routes)

# Define UI for the application
ui <- fluidPage(
  titlePanel("2022 Accidents Map - Interactive Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        "state", "Select State(s):",
        choices = unique(accident_data$statename),
        selected = unique(accident_data$statename)[1],
        multiple = TRUE
      ),
      
      selectizeInput(
        "route", "Select Route Category(ies):",
        choices = unique_routes,
        selected = unique_routes[1],
        multiple = TRUE
      ),
      
      selectInput(
        "day_quarter", "Select a Day Quarter:",
        choices = unique(accident_data$day_quarter),
        selected = unique(accident_data$day_quarter)[1]
      ),
      
      checkboxGroupInput(
        "day_type_selection", "Select Day Type:",
        choices = c("Weekday", "Weekend"),
        selected = c("Weekday", "Weekend")
      ),
      
      checkboxGroupInput(
        "quarter_year_selection", "Select Quarter of Year:",
        choices = c("FQ1_Year", "SQ2_Year", "TQ3_Year"),
        selected = c("FQ1_Year", "SQ2_Year", "TQ3_Year")
      ),
      
      # Display accident count by route and state
      tableOutput("accident_count_by_state_route")
    ),
    
    mainPanel(
      leafletOutput("accidentMap"),
      textOutput("accident_count"),
      plotOutput("accident_trend"),    # Updated line plot widget for each route category
      plotOutput("day_type_distribution")  # Bar plot widget for day type distribution
    )
  )
)

# Define server logic required to draw the map
server <- function(input, output, session) {
  # Reactive expression to filter the dataset based on user input
  filtered_data <- reactive({
    data <- accident_data %>%
      filter(
        statename %in% input$state,
        route_category %in% input$route,
        day_quarter == input$day_quarter,
        day_type %in% input$day_type_selection,
        quarter_year %in% input$quarter_year_selection
      )
    
    # Validate to ensure data is not empty
    validate(
      need(nrow(data) > 0, "No accidents match the selected filters.")
    )
    
    data
  })
  
  # Render the leaflet map
  output$accidentMap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -98.5795, lat = 39.8283, zoom = 4)  # Default view of USA
  })
  
  # Update the map with filtered data
  observe({
    data <- filtered_data()
    
    leafletProxy("accidentMap", data = data) %>%
      clearMarkers() %>%
      addCircleMarkers(
        lng = data$longitud, lat = data$latitude,
        radius = 5,
        color = ~route_colors(route_category),  # Apply color based on route_category using dynamic palette
        stroke = FALSE, fillOpacity = 0.5,
        popup = ~paste0(
          "Case: ", st_case, "<br>",
          "Route: ", route_category, "<br>",
          "Day Quarter: ", day_quarter, "<br>",
          "Day Type: ", day_type, "<br>",
          "Quarter of Year: ", quarter_year
        )
      )
  })
  
  # Display the number of accidents that match the filter
  output$accident_count <- renderText({
    data <- filtered_data()
    paste("Number of Accidents:", nrow(data))
  })
  
  # Display accident count by state and route category in a table
  output$accident_count_by_state_route <- renderTable({
    filtered_data() %>%
      group_by(statename, route_category) %>%
      summarise(accident_count = n()) %>%
      arrange(statename, desc(accident_count))
  })
  
  # Render a line plot for accident trends by month and route category
  output$accident_trend <- renderPlot({
    data <- filtered_data()
    data$monthname <- factor(data$monthname, levels = month.name)  # Arrange months in calendar order
    data %>%
      group_by(monthname, route_category) %>%
      summarise(accident_count = n()) %>%
      ggplot(aes(x = monthname, y = accident_count, color = route_category, group = route_category)) +
      geom_line() +
      scale_color_manual(values = route_colors(unique_routes)) +  # Use same colors as map
      labs(title = "Accident Trend by Month and Route Category", x = "Month", y = "Number of Accidents", color = "Route Category") +
      theme_minimal()
  })
  
  # Render a bar plot for day of the week distribution of accidents
  output$day_type_distribution <- renderPlot({
    data <- filtered_data()
    data$day_weekname <- factor(data$day_weekname, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))  # Arrange days in week order
    data %>%
      group_by(day_weekname) %>%
      summarise(accident_count = n()) %>%
      arrange(desc(accident_count)) %>%
      ggplot(aes(x = fct_reorder(day_weekname, accident_count, .desc = TRUE), y = accident_count, fill = day_weekname)) +
      geom_bar(stat = "identity") +
      labs(title = "Accidents by Day of the Week (Highest to Lowest)", x = "Day of the Week", y = "Number of Accidents") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
