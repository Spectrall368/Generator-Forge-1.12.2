<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onExplode(ExplosionEvent.Detonate event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getExplosion().getPosition().x",
			"y": "event.getExplosion().getPosition().y",
			"z": "event.getExplosion().getPosition().z",
			"world": "event.getWorld()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}