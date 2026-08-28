<#include "mcelements.ftl">
if (world instanceof WorldServer) {
	Template template = ((WorldServer) world).getStructureTemplateManager()
		.getTemplate(world.getMinecraftServer(), new ResourceLocation("${modid}", "${field$schematic}"));
	if (template != null) {
		template.addBlocksToWorld(world,
			${toBlockPos(input$x,input$y,input$z)},
			new PlacementSettings()
				.setRotation(Rotation.<#if (field$rotation!'NONE') != "RANDOM">${field$rotation!'NONE'}<#else>func_222466_a(world.getWorld().rand)</#if>)
				.setMirror(Mirror.<#if (field$mirror!'NONE') != "RANDOM">${field$mirror!'NONE'}<#else>values()[world.getWorld().rand.nextInt(2)]</#if>)
				.setIgnoreEntities(false), 3);
	}
}