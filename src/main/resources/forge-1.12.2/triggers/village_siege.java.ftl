<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onVillageSiege(VillageSiegeEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAttemptedSpawnPos().x",
			"y": "event.getAttemptedSpawnPos().y",
			"z": "event.getAttemptedSpawnPos().z",
			"world": "event.getWorld()",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}