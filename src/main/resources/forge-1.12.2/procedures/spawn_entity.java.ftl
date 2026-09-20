<#assign entity = generator.map(field$entity, "entities")!"null">
<#if entity != "null" && entity != "EntityLightningBolt">
if (world instanceof WorldServer) {
	Entity entityToSpawn = new ${entity}(world);
	entityToSpawn.setLocationAndAngles(${input$x}, ${input$y}, ${input$z}, world.rand.nextFloat() * 360F, 0);

	if (entityToSpawn instanceof EntityMob)
		((EntityMob) entityToSpawn).onInitialSpawn(world.getDifficultyForLocation(new BlockPos(entityToSpawn)), null);

	world.spawnEntity(entityToSpawn);
}
</#if>