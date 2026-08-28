<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world instanceof WorldServer) {
	Entity entityToSpawn = new ${generator.map(field$entity, "entities", 0)}(world);
	entityToSpawn.setLocationAndAngles(${input$x}, ${input$y}, ${input$z}, ${opt.toFloat(input$yaw)}, ${opt.toFloat(input$pitch)});
	<#if input$yaw != "/*@int*/0">
		entityToSpawn.setRenderYawOffset(${opt.toFloat(input$yaw)});
		entityToSpawn.setRotationYawHead(${opt.toFloat(input$yaw)});
	</#if>

	if (entityToSpawn instanceof EntityMob)
		((EntityMob) entityToSpawn).onInitialSpawn(world.getDifficultyForLocation(new BlockPos(entityToSpawn)), null);

	world.spawnEntity(entityToSpawn);
}
</#if>