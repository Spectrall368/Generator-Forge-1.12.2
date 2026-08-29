if (${input$entity} instanceof EntityMob)
	((EntityMob) ${input$entity}).getNavigator().tryMoveToXYZ(${input$x}, ${input$y}, ${input$z}, ${input$speed});