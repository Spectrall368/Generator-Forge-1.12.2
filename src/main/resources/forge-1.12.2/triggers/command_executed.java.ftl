<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onCommand(CommandEvent event) {
		Entity entity = event.getSender().getCommandSenderEntity();
		if (entity != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "entity.world",
				"entity": "entity",
				"command": "event.getCommand().getName()",
				"arguments": "event.getParameters()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}