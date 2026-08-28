<#include "mcitems.ftl">
if (!world.isRemote) {
	EntityItem entityToSpawn = new EntityItem(world, ${input$x}, ${input$y}, ${input$z}, ${mappedMCItemToItemStackCode(input$block, 1)});
	entityToSpawn.setPickupDelay(${opt.toInt(input$pickUpDelay!10)});
	<#if (field$despawn!"TRUE") == "FALSE">
	entityToSpawn.setNoDespawn();
	</#if>
	world.spawnEntity(entityToSpawn);
}