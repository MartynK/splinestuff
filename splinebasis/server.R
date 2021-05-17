#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(latex2exp)
library(ggplot2)

shinyServer(function(input, output) {

    output$knotPlot <- renderPlot({

        d <- data.frame( x= seq(0,1, length.out = 100))
        d$ra <- rep( 0, 100)
        d$rb <- rep( 0, 100)
        d$rc <- seq(0, 1,length.out=100)
        for (i in 1:100) {
            d$ra[i] <- rk( d$x[i],input$base_a)
            d$rb[i] <- rk( d$x[i],input$base_b)
        }
        min_a <- min(d$ra)
        max_a <- max(d$ra)
        dif_a <- (max_a-min_a)/20
        zero_a <- (max_a+min_a)/2
        min_b <- min(d$rb)
        max_b <- max(d$rb)
        dif_b <- (max_b-min_b)/20
        zero_b <- (max_b+min_b)/2
        y_a <- rk( input$x_exp,input$base_a)
        y_b <- rk( input$x_exp,input$base_b)
        y_c  <- input$x_exp

        if (input$rescale == TRUE) {
        #rescaling
            d$ra <- -10 + (d$ra - min_a) / dif_a
            y_a  <- -10 + (rk( input$x_exp,input$base_a) - min_a) / dif_a
            d$rb <- -10 + (d$rb - min_b) / dif_b
            y_b  <- -10 + (rk( input$x_exp,input$base_b) - min_b) / dif_b
            d$rc <- seq(-10, 10,length.out=100)
            y_c  <- -10+input$x_exp*20
        }
        
        p1 <- ggplot( d, aes ( x = x, y = ra)) +
            theme_bw() +
            geom_vline(xintercept=input$base_a,
                       color='red', size = 2) +
            geom_vline(xintercept=input$base_b,
                       color='blue', size = 2) +
            #scale_y_continuous(breaks=c()) +
            xlab("'x', relative scale") +
            ylab("")
        
        if (input$incl_b1 == TRUE) {
            p1 <- p1 +
                geom_point(x = input$x_exp,
                           y= y_c,
                           color='green',
                           size=5) +
                geom_line(aes(y=rc), color='green',size=1.5)
        }
        
        if (input$incl_b2 == TRUE) {
            p1 <- p1 +
                geom_point(x = input$x_exp,
                           y= y_a,
                           color='red',
                           size=5) +
                geom_line(color='red',size=1.5)
        }
        
        if (input$incl_b3 == TRUE) {
            p1 <- p1 +
                geom_point(x = input$x_exp,                       
                           y= y_b,
                           color='blue',
                           size=5) +
                geom_line(aes(y = rb),color = 'blue',size=1.5)
        }

        p1
    })
    
    output$bftable <- renderTable({
        d <- data.frame( x= seq(0,1, length.out = 100))
        d$ra <- rep( 0, 100)
        d$rb <- rep( 0, 100)
        for (i in 1:100) {
            d$ra[i] <- rk( d$x[i],input$base_a)
            d$rb[i] <- rk( d$x[i],input$base_b)
        }
        min_a <- min(d$ra)
        max_a <- max(d$ra)
        dif_a <- (max_a-min_a)/20
        zero_a <- (max_a+min_a)/2
        min_b <- min(d$rb)
        max_b <- max(d$rb)
        dif_b <- (max_b-min_b)/20
        zero_b <- (max_b+min_b)/2
        y_a <- rk( input$x_exp,input$base_a)
        y_b <- rk( input$x_exp,input$base_b)
        
        if (input$rescale == TRUE) {
            #rescaling
            d$ra <- -10 + (d$ra - min_a) / dif_a
            y_a <- -10 + (rk( input$x_exp,input$base_a) - min_a) / dif_a
            d$rb <- -10 + (d$rb - min_b) / dif_b
            y_b <- -10 + (rk( input$x_exp,input$base_b) - min_b) / dif_b
        }
        
       data <- data.frame( 
                   b1 = 1,
                   b2 = input$x_exp,
                   b3 = y_a,
                   b4 = y_b)
       colnames(data) <- c("b1(x)","b2(x)","b3(x)","b4(x)")
       return(data)
    })
})
