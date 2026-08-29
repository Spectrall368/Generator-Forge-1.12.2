<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getMinecraftServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};
	for (ItemStack itemstackiterator : world.getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generateLootForPools(world.rand, new LootContext.Builder((WorldServer) world).build())) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->