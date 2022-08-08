# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  output$barPlot <- renderPlotly({
    plot <- ggplot(rbind(head(happiness_sorted, 5),  tail(happiness_sorted,5)), mapping=aes(x=reorder(Country, Ladder_Score), y=Ladder_Score, text=label))+
        geom_col(aes(fill=Ladder_Score))+
        scale_fill_gradientn(colors=colors)+
        coord_flip()+
        labs(
          title="Top 5 Happiest and Unhappiest\nCountry In the World",
          y="Happiness",
          x="",
          fill="Happiness Score"
        )+
        theme_black()
      
      color = "rgba(0, 0, 0, 1)"
      
      ggplotly(plot, tooltip="text") %>% layout(
        plot_bgcolor  = color,
        paper_bgcolor = color
      )
    })
   
      
  output$corrPlot <- renderPlotly({
    
    happiness_corr <- happiness_corr %>% 
      mutate(label = glue("{id}
                      Correlation Value:  {round(value, 2)}"))
    
    
    options(repr.plot.width =20, repr.plot.height =9)
    plot2<-ggplot(happiness_corr, mapping=aes(x=id, y=value, fill=value, text=label))+
      geom_col()+
      labs(
        title="Correlation with Happiness",
        x="",
        y=""
      )+
      scale_fill_gradientn(colors=colors,
                           limits=c(-1,1))+  
      scale_y_discrete(labels=c("test,"))+
      theme_black()+
      ylim(-1,1)+
      coord_flip()
    
    color = "rgba(0, 0, 0, 1)"
    ggplotly(plot2, tooltip="text") %>% layout(
      plot_bgcolor  = color,
      paper_bgcolor = color
    )
  })
  
    output$scatterPlot <- renderPlot({
      col=input$input_col
      col2 <- gsub(" ", "_", col)
      
      colors <- c("#ffd89b", "#19547b")
      ggplot(happiness, mapping=aes(x=get(col2), y=Ladder_Score))+
        geom_point(aes(col=Ladder_Score))+
        scale_color_gradientn(colors=colors)+
        geom_smooth(method = "lm", se = FALSE, col="white")+
        labs(
          title=paste("Correlation Between", col, " and Happiness"),
          x=col,
          y="",
          col="Happiness Score"
        )+
        theme_black()
      
    })  
  
    
    output$map <- renderPlotly({

      
      plot3<- ggplot(world_map, aes(x=long, y=lat, group=group, text=label))+
        geom_polygon(aes(fill=Ladder_Score), color="black")+
        scale_fill_gradientn(colors=colors)+
        labs(
          x="",
          y="",
          fill="Happiness Score"
        )+
        theme_black()+
        theme(axis.text.x = element_blank(),
              axis.text.y = element_blank())
      
      color = "rgba(0, 0, 0, 1)"
      ggplotly(plot3, tooltip="text") %>% layout(
        plot_bgcolor  = color,
        paper_bgcolor = color,
        width = input$width,
        height= input$width/2
      )
    })
    
    
    output$table <- renderDataTable({
      
      DT::datatable(happiness,
                    #argumen/parameter agar dataframe dapat discroll
                    options = list(scrollX = TRUE))
      
    })
    

})

tryCatch({
  stop('')
},error=function(err){
  traceback()
})
