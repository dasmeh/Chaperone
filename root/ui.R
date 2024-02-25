# ui.R
library(shiny)

fluidPage(
  titlePanel("Chaperone Kinetics Model"),
  sidebarLayout(
    sidebarPanel(
      numericInput("kb", "Binding Rate (kb):", value = 0.1, min = 0, max = 1, step = 0.01),
      numericInput("katp", "ATP Hydrolysis Rate (katp):", value = 0.05, min = 0, max = 1, step = 0.01),
      numericInput("kf", "Folding Rate (kf):", value = 0.2, min = 0, max = 1, step = 0.01),
      numericInput("kr", "Release Rate (kr):", value = 0.3, min = 0, max = 1, step = 0.01),
      numericInput("time", "Simulation Time:", value = 100, min = 0, max = 1000, step = 10),
      actionButton("run_simulation", "Run Simulation")
    ),
    mainPanel(
      plotOutput("chaperone_plot")
    )
  )
)

