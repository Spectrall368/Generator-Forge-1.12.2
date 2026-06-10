<@head>if (${input$entity} instanceof EntityPlayer) {
	EntityPlayer _player = (EntityPlayer) ${input$entity};</@head>
	_player.capabilities.allowFlying = ${input$condition};
<@tail>
	_player.sendPlayerAbilities();
}</@tail>