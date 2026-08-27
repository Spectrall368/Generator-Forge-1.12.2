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
package ${package}.client.renderer.item;

import net.minecraft.client.renderer.ItemRenderer;

<@javacompress>
@SideOnly(Side.CLIENT) public class ${name}ItemRenderer extends TileEntityItemStackRenderer {
	private final Supplier<ItemStack> transformSource;

	private final Map<Integer, ModelBase> models = new HashMap<>();
	private final long start;

	public ${name}ItemRenderer() {
		this.transformSource = () -> new ItemStack(${JavaModName}Items.${REGISTRYNAME});

		this.start = System.currentTimeMillis();

		<#if data.hasCustomJAVAModel()>
			<#if !data.animations?has_content>
			this.models.put(0, new ${data.customModelName.split(":")[0]}());
			</#if>
		</#if>
		<#list data.getModels() as model>
			<#if model.hasCustomJAVAModel()>
			this.models.put(${model?index + 1}, new ${model.customModelName.split(":")[0]}());
			</#if>
		</#list>
	}

	@Override public void renderByItem(ItemStack itemstack, float partialTicks) {
		ModelBase model = this.models.get(0);
		ResourceLocation texture = new ResourceLocation("${data.texture.format("%s:textures/items/%s")}.png");
		<#list data.getModels() as model>
			<#if model.hasCustomJAVAModel()>
			if (<#list model.stateMap.entrySet() as entry>
					itemstack.getItem().getPropertyGetter(new ResourceLocation("${generator.map(entry.getKey().getPrefixedName(registryname + "_"), "itemproperties")}"))
						.apply(itemstack, Minecraft.getMinecraft().world, Minecraft.getMinecraft().player) >= ${entry.getValue()?is_boolean?then(entry.getValue()?then("1", "0"), entry.getValue())}
				<#sep> && </#list>) {
				model = models.get(${model?index + 1});
				texture = new ResourceLocation("${model.texture.format("%s:textures/items/%s")}.png");
			}
			</#if>
		</#list>
		if (model == null) return;

		Minecraft.getMinecraft().getTextureManager().bindTexture(texture);
		GlStateManager.pushMatrix();
		Minecraft.getMinecraft().getRenderItem().getItemModelWithOverrides(this.transformSource.get(), null, null);
		GlStateManager.translate(0.5f, 1.5f, 0.5f);
		GlStateManager.rotate(180.0f, 0.0f, 0.0f, 1.0f);
		GlStateManager.scale(1.0f, 1.0f, -1.0f);
		model.setRotationAngles(0, 0, (System.currentTimeMillis() - start) / 50.0f, 0, 0, 1, null);
		model.render(null, 0, 0, 0, 0, 0, 0.0625F);
		GlStateManager.popMatrix();
	}
}
</@javacompress>
<#-- @formatter:on -->