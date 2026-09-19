<#include "procedures.java.ftl">
@SideOnly(Side.SERVER) public class ${name}Procedure {
	public static void init(FMLInitializationEvent event) {
		execute();
	}
