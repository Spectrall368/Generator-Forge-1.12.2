<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityAttacked(LivingAttackEvent event) {
		if (event != null && event.getEntityLiving() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntityLiving().posX",
				"y": "event.getEntityLiving().posY",
				"z": "event.getEntityLiving().posZ",
				"amount": "event.getAmount()",
				"world": "event.getEntityLiving().world",
				"entity": "event.getEntityLiving()",
				"damagesource": "event.getSource()",
				"sourceentity": "event.getSource().getTrueSource()",
				"immediatesourceentity": "event.getSource().getImmediateSource()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}