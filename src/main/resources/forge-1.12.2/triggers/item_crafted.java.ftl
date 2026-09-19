<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure  {
	@SubscribeEvent public static void onItemCrafted(net.minecraftforge.fml.common.gameevent.PlayerEvent.ItemCraftedEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.player.posX",
			"y": "event.player.posY",
			"z": "event.player.posZ",
			"world": "event.player.world",
			"entity": "event.player",
			"itemstack": "event.crafting",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
