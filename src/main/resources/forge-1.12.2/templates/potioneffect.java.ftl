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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
package ${package}.potion;

<@javacompress>
public class ${name}MobEffect extends Potion {
	private static final ResourceLocation potionIcon = new ResourceLocation("${modid}:textures/mob_effect/${registryname}.png");

	public ${name}MobEffect() {
		super(${data.mobEffectCategory == "HARMFUL"}, ${data.color.getRGB()});
		setPotionName("effect.${modid}.${registryname}");
		<#list data.modifiers as modifier>
		this.registerPotionAttributeModifier(${modifier.attribute}, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				${getAttributeOperation(modifier.operation)});
		</#list>
		}

	<#if data.mobEffectCategory == "BENEFICIAL">
		@Override public boolean isBeneficial() {
			return true;
		}
	</#if>

	<#if data.isInstant>
		@Override public boolean isInstant() {
			return true;
		}
	</#if>

	<#if hasProcedure(data.onStarted) || (data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content)>
		<#if data.isInstant>
			@Override public void affectEntity(Entity source, Entity indirectSource, EntityLivingBase entity, int amplifier, double health) {
                <@startedContext/>
			}
		<#else>
			@Override public void applyAttributesModifiersToEntity(EntityLivingBase entity, AbstractAttributeMap attributeMap, int amplifier) {
				super.applyAttributesModifiersToEntity(entity, attributeMap, amplifier);
                <@startedContext/>
			}
		</#if>
	</#if>

	<#if hasProcedure(data.onActiveTick)>
		@Override public void performEffect(EntityLivingBase entity, int amplifier) {
		<@procedureCode data.onActiveTick, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "entity.world",
			"entity": "entity",
			"amplifier": "amplifier"
		}/>
		}
	</#if>

	<#if hasProcedure(data.onExpired)>
		@Override public void removeAttributesModifiersFromEntity(EntityLivingBase entity, AbstractAttributeMap attributeMapIn, int amplifier) {
			super.removeAttributesModifiersFromEntity(entity, attributeMapIn, amplifier);
		<@procedureCode data.onExpired, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "entity.world",
			"entity": "entity",
			"amplifier": "amplifier"
		}/>
		}
	</#if>

	@Override public boolean isReady(int duration, int amplifier) {
		<#if hasProcedure(data.activeTickCondition)>
			return <@procedureOBJToConditionCode data.activeTickCondition/>;
		<#else>
			return true;
		</#if>
	}

	<#if data.hasCustomRenderer()>
				<#if !data.renderStatusInInventory>
					@Override public boolean shouldRender(PotionEffect effect) {
						return false;
					}

					@Override public boolean shouldRenderInvText(PotionEffect effect) {
						return false;
					}
				</#if>

				<#if !data.renderStatusInHUD>
					@Override public boolean shouldRenderHUD(PotionEffect effect) {
						return false;
					}
				</#if>
	</#if>

	@Override @SideOnly(Side.CLIENT) public void renderInventoryEffect(PotionEffect effect, Gui gui, int x, int y, float z) {
	    Minecraft.getMinecraft().getTextureManager().bindTexture(potionIcon);
	    gui.drawModalRectWithCustomSizedTexture(x + 6, y + 7, 0, 0, 18, 18, 18, 18);
	}

	@Override @SideOnly(Side.CLIENT) public void renderHUDEffect(PotionEffect effect, Gui gui, int x, int y, float z, float alpha) {
	    Minecraft.getMinecraft().getTextureManager().bindTexture(potionIcon);
	    gui.drawModalRectWithCustomSizedTexture(x + 3, y + 3, 0, 0, 18, 18, 18, 18);
    }
}
</@javacompress>
<#-- @formatter:on -->
<#function getAttributeOperation operation>
	<#if operation == "ADD_VALUE">
		<#return "0">
	<#elseif operation == "ADD_MULTIPLIED_BASE">
		<#return "1">
	<#else>
		<#return "2">
	</#if>
</#function>
<#macro startedContext>
<#if data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content>
    entity.world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.onAddedSound}")), entity.getSoundCategory(), 1.0F, 1.0F);
</#if>
<#if hasProcedure(data.onStarted)>
    <@procedureCode data.onStarted, {
        "x": "entity.posX",
        "y": "entity.posY",
        "z": "entity.posZ",
        "world": "entity.world",
        "entity": "entity",
        "amplifier": "amplifier"
    }/>
</#if>
</#macro>