<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(Side.SERVER) public class ${name}Procedure {
	@SubscribeEvent public static void init(FMLInitializationEvent event) {
		execute();
	}
