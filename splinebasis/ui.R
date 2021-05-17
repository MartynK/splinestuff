#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Visualizing basis functions for natural splines"),
    withMathJax(),
    helpText('We want to model "y" as a natural spline of "x" with 4 degrees of freedom (or intercept + 3 df). The model may be written as: 
             $$y = \\beta_{1}\\cdot b_{1}(x) + \\beta_{2}\\cdot b_{2}(x) + \\beta_{3}\\cdot b_{3}(x) + \\beta_{4}\\cdot b_{4}(x)$$ \n
    b1() is the intercept; if you specify '),
    
    helpText('$$y =  ns(x, df = 3)$$'),
    
    helpText('
    in a model, it would generally be included anyways, but strictly speaking it is part of the spline. 
    The basis functions b() are:
    $$b_{1}(x) = 1;$$ $$b_{2}(x) = x;$$ $$b_{3}(x) = R(x,knotlocation_1);$$ $$b_{4}(x) = R(x,knotlocation_2);$$
    Where $$R(a,b) = \\frac{(b-\\frac{1}{2})^{2}-\\frac{1}{12}}{4}-\\frac{(abs(a-b)-\\frac{1}{2})^{4})-\\frac{(abs(a-b)-\\frac{1}{2})^{2}}{2}+\\frac{7}{240}}{24}$$
             '),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("base_a",
                        "Location of first 'knot':",
                        min = 0,
                        max = 1,
                        value = .2),
            sliderInput("base_b",
                        "Location of second 'knot':",
                        min = 0,
                        max = 1,
                        value = .5),
            sliderInput("x_exp",
                        "example 'x':",
                        min = 0,
                        max = 1,
                        value = .6),
            checkboxInput("rescale","Rescale?",value = TRUE),
            checkboxInput("incl_b1","Include b2()?",value = TRUE),
            checkboxInput("incl_b2","Include b3()?",value = TRUE),
            checkboxInput("incl_b3","Include b4()?",value = TRUE)
            ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
            tableOutput("bftable"),
            plotOutput("knotPlot")
            )
        )
)))
