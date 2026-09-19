<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void whenEntityChangeEquipment(LivingEquipmentChangeEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntityLiving().posX",
				"y": "event.getEntityLiving().posY",
				"z": "event.getEntityLiving().posZ",
				"world": "event.getEntityLiving().world",
				"entity": "event.getEntityLiving()",
				"equipmentslot": "event.getSlot().getSlotIndex()",
				"olditemstack": "event.getFrom()",
				"newitemstack": "event.getTo()",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}