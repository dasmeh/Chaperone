# server.R
library(deSolve)
library(ggplot2)

chaperone_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dC <- -kb * C * U + kr * CFc
    dCU <- kb * C * U - katp * CU
    dCUc <- katp * CU - kf * CUc
    dCFc <- kf * CUc - kr * CFc
    dF <- kr * CFc
    dU <- 0  # Derivative of U (constant)
    return(list(c(dC, dCU, dCUc, dCFc, dF, dU)))
  })
}

shinyServer(function(input, output) {
  chaperone_solution <- reactive({
    initial_state <- c(C = 1, CU = 0, CUc = 0, CFc = 0, F = 0, U = 1)
    times <- seq(0, input$time, by = 0.1)
    parameters <- c(kb = input$kb, katp = input$katp, kf = input$kf, kr = input$kr)
    solution <- ode(y = initial_state, times = times, func = chaperone_model, parms = parameters)
    solution_df <- as.data.frame(solution)
    solution_df$time <- times
    return(solution_df)
  })
  
  output$chaperone_plot <- renderPlot({
    ggplot(chaperone_solution(), aes(x = time)) +
      geom_line(aes(y = C, color = "Chaperone (C)")) +
      geom_line(aes(y = CU, color = "Bound Complex (CU)")) +
      geom_line(aes(y = CUc, color = "Closed Complex (CU_c)")) +
      geom_line(aes(y = CFc, color = "Closed Complex with Folded Protein (CF_c)")) +
      geom_line(aes(y = F, color = "Folded Protein (F)")) +
      labs(title = "Concentration Changes Over Time",
           x = "Time",
           y = "Concentration") +
      scale_color_manual(values = c("Chaperone (C)" = "blue",
                                    "Bound Complex (CU)" = "green",
                                    "Closed Complex (CU_c)" = "orange",
                                    "Closed Complex with Folded Protein (CF_c)" = "red",
                                    "Folded Protein (F)" = "purple"))
  })
})

