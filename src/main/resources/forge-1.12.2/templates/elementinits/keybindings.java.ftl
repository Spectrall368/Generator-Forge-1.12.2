<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

import org.lwjgl.input.Keyboard;

@Mod.EventBusSubscriber(Side.CLIENT) public class ${JavaModName}KeyMappings {

    <#list keybinds as keybind>
	public static final KeyBinding ${keybind.getModElement().getRegistryNameUpper()} = new KeyBinding(
			"key.${modid}.${keybind.getModElement().getRegistryName()}", Keyboard.KEY_${generator.map(keybind.triggerKey, "keybuttons")},
			"key.categories.${keybind.keyBindingCategoryKey}");
    </#list>

	<#list keybinds as keybind>
		<#if hasProcedure(keybind.onKeyReleased)>
		private static long ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = 0;
		</#if>
	</#list>

	public static void registerKeyBindings() {
		<#list keybinds as keybind>
			ClientRegistry.registerKeyBinding(${keybind.getModElement().getRegistryNameUpper()});
			${keybind.getModElement().getName()}Message.registerMessage();
		</#list>
	}

		@SubscribeEvent public static void onKeyInput(InputEvent.KeyInputEvent event) {
			if (Minecraft.getMinecraft().currentScreen == null) {
			<#list keybinds as keybind>
				<#if hasProcedure(keybind.onKeyPressed) || hasProcedure(keybind.onKeyReleased)>
					if (Keyboard.getEventKey() == ${keybind.getModElement().getRegistryNameUpper()}.getKeyCode()) {
						if(Keyboard.getEventKeyState()) {
								<#if hasProcedure(keybind.onKeyPressed)>
									${JavaModName}.PACKET_HANDLER.sendToServer(new ${keybind.getModElement().getName()}Message(0, 0));
									${keybind.getModElement().getName()}Message.pressAction(Minecraft.getMinecraft().player, 0, 0);
								</#if>

								<#if hasProcedure(keybind.onKeyReleased)>
								${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = System.currentTimeMillis();
								</#if>
						}
						<#if hasProcedure(keybind.onKeyReleased)>
						else {
							int dt = (int) (System.currentTimeMillis() - ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS);
							${JavaModName}.PACKET_HANDLER.sendToServer(new ${keybind.getModElement().getName()}Message(1, dt));
								${keybind.getModElement().getName()}Message.pressAction(Minecraft.getMinecraft().player, 1, dt);
						}
						</#if>
					}
				</#if>
			</#list>
			}
		}
}
<#-- @formatter:on -->