<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getMinecraftServer() != null) {
	for (ItemStack itemstackiterator : world.getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generateLootForPools(world.rand, new LootContext.Builder((WorldServer) world).build())) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->