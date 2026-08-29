if ((${input$entity} instanceof EntityTameable) && (${input$sourceentity} instanceof EntityPlayer)) {
	((EntityTameable) ${input$entity}).setTamed(true);
	((EntityTameable) ${input$entity}).setTamedBy((EntityPlayer) ${input$sourceentity});
}