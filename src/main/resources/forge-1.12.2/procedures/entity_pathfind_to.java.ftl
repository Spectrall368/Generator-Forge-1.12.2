if (${input$entity} instanceof EntityLiving)
	((EntityLiving) ${input$entity}).getNavigator().tryMoveToXYZ(${input$x}, ${input$y}, ${input$z}, ${input$speed});