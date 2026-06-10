<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
package ${package}.client.renderer;
<#assign humanoid = false>
<#assign model = "ModelPlayer">
<#if data.mobModelName == "Chicken">
	<#assign rootPart = "">
	<#assign model = "ModelChicken">
<#elseif data.mobModelName == "Cod">
	<#assign rootPart = "">
	<#assign model = "CodModel">
<#elseif data.mobModelName == "Cow">
	<#assign rootPart = "">
	<#assign model = "ModelCow">
<#elseif data.mobModelName == "Creeper">
	<#assign rootPart = "">
	<#assign model = "ModelCreeper">
<#elseif data.mobModelName == "Ghast">
	<#assign rootPart = "">
	<#assign model = "ModelGhast">
<#elseif data.mobModelName == "Ocelot">
	<#assign rootPart = "0.0F">
	<#assign model = "ModelOcelot">
<#elseif data.mobModelName == "Pig">
	<#assign rootPart = "">
	<#assign model = "ModelPig">
<#elseif data.mobModelName == "Piglin">
	<#assign rootPart = "">
	<#assign model = "ModelBiped">
	<#assign humanoid = true>
<#elseif data.mobModelName == "Slime">
	<#assign rootPart = "16">
	<#assign model = "ModelSlime">
<#elseif data.mobModelName == "Salmon">
	<#assign rootPart = "">
	<#assign model = "ModelSalmon">
<#elseif data.mobModelName == "Spider">
	<#assign rootPart = "">
	<#assign model = "ModelSpider">
<#elseif data.mobModelName == "Villager">
	<#assign rootPart = "0.0F">
	<#assign model = "ModelVillager">
<#elseif data.mobModelName == "Silverfish">
	<#assign rootPart = "">
	<#assign model = "ModelSilverfish">
<#elseif data.mobModelName == "Witch">
	<#assign rootPart = "0.0F">
	<#assign model = "ModelWitch">
<#elseif !data.isBuiltInModel()>
	<#assign rootPart = "">
	<#assign model = data.mobModelName>
<#else>
	<#assign rootPart = "0.0F, false">
	<#assign model = "ModelPlayer">
	<#assign humanoid = true>
</#if>

<#compress>
@SideOnly(Side.CLIENT)
public class ${name}Renderer extends Render<#if humanoid>Biped<#else>Living</#if><${name}Entity> {

	public ${name}Renderer(RenderManager context) {
		super(context, new ${model}(${rootPart}), ${data.modelShadowSize}f);

		<#if humanoid>
		this.addLayer(new LayerBipedArmor(this));
		<#elseif data.mobModelName == "Witch">
		this.addLayer(new LayerHeldItemWitch(this));
		</#if>

		<#list data.modelLayers as layer>
		this.addLayer(new LayerRenderer<${name}Entity, ${model}>(this) {
			final ResourceLocation LAYER_TEXTURE = new ResourceLocation("${modid}:textures/entities/${layer.texture}");

			<#compress>
			@Override public void doRenderLayer(${name}Entity entity, float limbSwing, float limbSwingAmount, float partialTicks, float ageInTicks, float netHeadYaw, float headPitch, float scaleFactor) {
				<#if hasProcedure(layer.condition)>
				World world = entity.world;
				double x = entity.posX;
				double y = entity.posY;
				double z = entity.posZ;
				if (<@procedureOBJToConditionCode layer.condition/>) {
				</#if>
				<#if layer.model != "Default">
					ModelBase model = new ${layer.model}();
					this.getMainModel().setModelAttributes(model);
					model.setLivingAnimations(entity, limbSwing, limbSwingAmount, partialTicks);
					model.setRotationAngles(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scaleFactor);
					<#assign model_ = "model">
				<#else>
					<#assign model_ = "this.getMainModel()">
				</#if>

				this.bindTexture(LAYER_TEXTURE);
				<#if !layer.glow>
				GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
				${model_}.render(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scaleFactor);
				<#else>
				GlStateManager.enableBlend();
				GlStateManager.disableAlpha();
				GlStateManager.blendFunc(GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ONE);
				GlStateManager.depthMask(!entity.isInvisible());
			    int i = 61680;
				int j = i % 65536;
				int k = i / 65536;
				OpenGlHelper.setLightmapTextureCoords(OpenGlHelper.lightmapTexUnit, (float) j, (float) k);
				GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
				EntityRenderer gamerenderer = Minecraft.getMinecraft().entityRenderer;
				gamerenderer.setupFogColor(true);
				${model_}.render(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch, scaleFactor);
				gamerenderer.setupFogColor(false);
				i = entity.getBrightnessForRender();
				j = i % 65536;
				k = i / 65536;
				OpenGlHelper.setLightmapTextureCoords(OpenGlHelper.lightmapTexUnit, (float) j, (float) k);
				this.setLightmap(entitylivingbaseIn);
				GlStateManager.depthMask(true);
				GlStateManager.disableBlend();
				GlStateManager.enableAlpha();
				</#if>

				<#if hasProcedure(layer.condition)>}</#if>
			}
			</#compress>
		
			@Override public boolean shouldCombineTextures() {
				return <#if layer.disableHurtOverlay>true<#else>false</#if>;
			}
		});
		</#list>
	}

	<#if data.mobModelName == "Villager" || data.breedable || (data.visualScale?? && (data.visualScale.getFixedValue() != 1 || hasProcedure(data.visualScale)))>
	@Override protected void preRenderCallback(${name}Entity entity, float f) {
		<#if hasProcedure(data.visualScale)>
			World world = entity.world;
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			float scale = (float) <@procedureOBJToNumberCode data.visualScale/>;
			GlStateManager.scale(scale, scale, scale);
		<#elseif data.visualScale?? && data.visualScale.getFixedValue() != 1>
			GlStateManager.scale(${data.visualScale.getFixedValue()}f, ${data.visualScale.getFixedValue()}f, ${data.visualScale.getFixedValue()}f);
		</#if>
		<#if data.mobModelName == "Villager">
			GlStateManager.scale(0.9375f, 0.9375f, 0.9375f);
		</#if>
		<#if data.breedable>
			GlStateManager.scale(entity.getRenderScale(), entity.getRenderScale(), entity.getRenderScale());
		</#if>
	}
	</#if>

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

	<#if data.transparentModelCondition?? && (hasProcedure(data.transparentModelCondition) || data.transparentModelCondition.getFixedValue())>
        @Override protected boolean isVisible(${name}Entity entity) {
		<#if hasProcedure(data.transparentModelCondition)>
	        World world = entity.world;
	        double x = entity.posX;
	        double y = entity.posY;
	        double z = entity.posZ;
		</#if>
		return <@procedureOBJToConditionCode data.transparentModelCondition false true/>;
	    }
    </#if>

	<#if data.isShakingCondition?? && (hasProcedure(data.isShakingCondition) || data.isShakingCondition.getFixedValue())>
        @Override protected void applyRotations(${name}Entity entity, float ageInTicks, float rotationYaw, float partialTicks) {
        	float f = entity.getSwimAnimation(partialTicks);
        	super.applyRotations(entity, ageInTicks, rotationYaw, partialTicks);
        	if (f > 0.0F) {
        		<#if hasProcedure(data.isShakingCondition)>
        		World world = entity.world;
        		double x = entity.posX;
	        	double y = entity.posY;
        		double z = entity.posZ;
        		</#if>
        		if(<@procedureOBJToConditionCode data.isShakingCondition/>)
        			GlStateManager.rotate(MathHelper.lerp(f, entity.rotationPitch, -10.0F - entity.rotationPitch), 1.0F, 0.0F, 0.0F);
        	}
        }
	</#if>
}
</#compress>
