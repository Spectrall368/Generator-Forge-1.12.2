<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2020 Pylo and contributors
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
<#include "tokens.ftl">
<#include "procedures.java.ftl">
<#assign hasTextures = data.baseTexture?has_content>
<#list data.components as component>
	<#if component.getClass().getSimpleName() == "Image">
		<#assign hasTextures = true>
		<#break>
	</#if>
</#list>
package ${package}.client.screens;

@Elements${JavaModName}.ModElement.Tag public class Overlay${name} extends Elements${JavaModName}.ModElement {

	public Overlay${name} (Elements${JavaModName} instance) {
		super(instance, ${data.getModElement().getSortID()});
	}

	@Override @SideOnly(Side.CLIENT) public void init(FMLInitializationEvent event){
		MinecraftForge.EVENT_BUS.register(new GUIRenderEventClass());
	}

	public static class GUIRenderEventClass {

		@SubscribeEvent(priority = EventPriority.${data.priority}) @SideOnly(Side.CLIENT)
		<#if generator.map(data.overlayTarget, "screens") == "Ingame">
		public void eventHandler(RenderGameOverlayEvent event) {
			if (!event.isCancelable() && event.getType() == RenderGameOverlayEvent.ElementType.HELMET) {
				int posX = event.getResolution().getScaledWidth();
				int posY = event.getResolution().getScaledHeight();
		<#else>
		public void eventHandler(GuiScreenEvent.DrawScreenEvent.Post event) {
			if (event.getGui() instanceof ${generator.map(data.overlayTarget, "screens")}) {
				int w = event.getGui().width;
				int h = event.getGui().height;
		</#if>

				int posX = w / 2;
				int posY = h / 2;
	
				World world = null;
				double x = 0;
				double y = 0;
				double z = 0;
	
				EntityPlayer entity = Minecraft.getMinecraft().player;
				if (entity != null) {
					world = entity.world;
					x = entity.posX;
					y = entity.posY;
					z = entity.posZ;
				}

				<#if hasTextures>
					GlStateManager.disableDepth();
					GlStateManager.depthMask(false);
					GlStateManager.tryBlendFuncSeparate(GlStateManager.SourceFactor.SRC_ALPHA, GlStateManager.DestFactor.ONE_MINUS_SRC_ALPHA,
							GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ZERO);
					GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
					GlStateManager.disableAlpha();
				</#if>

				if (<@procedureOBJToConditionCode data.displayCondition/>) {
					<#if data.baseTexture?has_content>
						Minecraft.getMinecraft().renderEngine.bindTexture(new ResourceLocation("${modid}:textures/${data.baseTexture}"));
						Minecraft.getMinecraft().ingameGUI.drawModalRectWithCustomSizedTexture(0, 0, 0, 0, w, h, w, h);
					</#if>
	
					<#list data.components as component>
		                <#assign x = component.x - 213>
		                <#assign y = component.y - 120>
		                <#if component.getClass().getSimpleName() == "Label">
							<#if hasProcedure(component.displayCondition)>
							if (<@procedureOBJToConditionCode component.displayCondition/>)
							</#if>
							Minecraft.getMinecraft().fontRenderer.drawString("${translateTokens(JavaConventions.escapeStringForJava(component.text))}",
										posX + ${x}, posY + ${y}, ${component.color.getRGB()});
		                <#elseif component.getClass().getSimpleName() == "Image">
							<#if hasProcedure(component.displayCondition)>if (<@procedureOBJToConditionCode component.displayCondition/>) {</#if>
							Minecraft.getMinecraft().renderEngine.bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
							Minecraft.getMinecraft().ingameGUI.drawModalRectWithCustomSizedTexture(posX + ${x}, posY + ${y}, 0, 0,
								${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
								${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
							<#if hasProcedure(component.displayCondition)>}</#if>
		                </#if>
		            		</#list>
				}
	
				<#if hasTextures>
					GlStateManager.depthMask(true);
					GlStateManager.enableDepth();
					GlStateManager.enableAlpha();
					GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
				</#if>
			}
		}
	}
}
<#-- @formatter:on -->
