(${input$entity} instanceof EntityLivingBase && ${input$entity}.world.getScoreboard()
	.getPlayersTeam(((EntityLivingBase) ${input$entity}) instanceof EntityPlayer ? ((EntityPlayer) ${input$entity}).getGameProfile().getName() : ${input$entity}.getCachedUniqueIdString()) != null ?
		${input$entity}.world.getScoreboard().getPlayersTeam(((EntityLivingBase) ${input$entity}) instanceof EntityPlayer ? ((EntityPlayer) ${input$entity}).getGameProfile().getName() : ${input$entity}.getCachedUniqueIdString()).getName() : "")
