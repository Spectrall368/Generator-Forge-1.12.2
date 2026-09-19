<#include "procedures.java.ftl">
@SideOnly(Side.CLIENT) public class ${name}Procedure {
	public static void init(FMLInitializationEvent event) {
		execute();
	}