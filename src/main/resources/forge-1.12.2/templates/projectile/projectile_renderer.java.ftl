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
package ${package}.client.renderer;

public class ${name}Renderer extends Render<${name}Entity> {
	private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/entities/${data.customModelTexture}");
	private final ${data.entityModel} model;

	public ${name}Renderer(RenderManager context) {
		super(context);
		model = new ${data.entityModel}();
	}

	@Override public void doRender(${name}Entity entity, double x, double y, double z, float entityYaw, float partialTicks) {
		this.bindEntityTexture(entity);
		GlStateManager.pushMatrix();
		GlStateManager.translate((float) x, (float) y, (float) z);
		GlStateManager.rotate(entityYaw, 0, 1, 0);
		GlStateManager.rotate(90f - entity.prevRotationPitch - (entity.rotationPitch - entity.prevRotationPitch) * partialTicks, 1, 0, 0);
		model.setRotationAngles(entity, 0, 0, entity.ticksExisted + partialTicks, entity.rotationYaw, entity.rotationPitch, 1);
		model.render(entity, 0, 0, 0, 0, 0, 1);
		GlStateManager.popMatrix();
	}

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return texture;
	}
}
<#-- @formatter:on -->