<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerCriticalHit(CriticalHitEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntityPlayer().posX",
			"y": "event.getEntityPlayer().posY",
			"z": "event.getEntityPlayer().posZ",
			"world": "event.getEntityPlayer().world",
			"entity": "event.getTarget()",
			"sourceentity": "event.getEntityPlayer()",
			"damagemodifier": "event.getDamageModifier()",
			"isvanillacritical": "event.isVanillaCritical()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}