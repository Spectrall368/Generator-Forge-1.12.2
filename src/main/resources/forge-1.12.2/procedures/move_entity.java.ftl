{
	Entity _ent = ${input$entity};
    	_ent.setPositionAndUpdate(${input$x},${input$y},${input$z});
    	if (_ent instanceof EntityPlayerMP)
    		((EntityPlayerMP) _ent).connection.setPlayerLocation(${input$x}, ${input$y}, ${input$z}, _ent.rotationYaw, _ent.rotationPitch);
}