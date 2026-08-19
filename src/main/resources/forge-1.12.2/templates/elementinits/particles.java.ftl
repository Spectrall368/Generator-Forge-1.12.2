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
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

@Mod.EventBusSubscriber(Side.CLIENT) public class ${JavaModName}Particles {
	private static final Class<?>[] particlesParams = { String.class, int.class, boolean.class };

	<#list particles as particle>
	<#assign frameCount = particle.getTextureTileCount()>
    public static EnumParticleTypes ${particle.getModElement().getRegistryNameUpper()};
	public static <#if frameCount != 1>final</#if> TextureAtlasSprite<#if frameCount != 1>[]</#if> ${particle.getModElement().getRegistryNameUpper()}_TEX<#if frameCount != 1> = new TextureAtlasSprite[${frameCount}]</#if>;
	</#list>

	public static void load() {
	    int size = EnumParticleTypes.values().length;

		<#list particles as particle>
		${particle.getModElement().getRegistryNameUpper()} = registerParticle(makeParticle("${particle.getModElement().getRegistryNameUpper()}", "${particle.getModElement().getRegistryName()}", size++, ${particle.alwaysShow}), new ${particle.getModElement().getName()}Particle.${particle.getModElement().getName()}IParticleFactory());
		</#list>
	}

	private static EnumParticleTypes makeParticle(String enumName, String particleName, int index, boolean shouldIgnoreRange) {
		return EnumHelper.addEnum(EnumParticleTypes.class, enumName, particlesParams, ${JavaModName}.MODID + ':' + particleName, index, shouldIgnoreRange);
	}

	private static EnumParticleTypes registerParticle(EnumParticleTypes particle, IParticleFactory factory) {
		EnumParticleTypes.PARTICLES.put(particle.getParticleID(), particle);
        EnumParticleTypes.BY_NAME.put(particle.getParticleName(), particle);
		Minecraft.getMinecraft().effectRenderer.registerParticle(particle.getParticleID(), factory);
        return particle;
	}

	@SubscribeEvent @SideOnly(Side.CLIENT)
	public static void onTextureStitch(TextureStitchEvent.Pre event) {
        TextureMap map = event.getMap();

		<#list particles as particle>
		<#assign frameCount = particle.getTextureTileCount()>
        <#if frameCount == 1>
	    ${particle.getModElement().getRegistryNameUpper()}_TEX = map.registerSprite(new ResourceLocation(${JavaModName}.MODID, "particle/${particle.getModElement().getRegistryName()}"));
        <#else>
        for (int i = 0; i < ${frameCount}; i++)
            ${particle.getModElement().getRegistryNameUpper()}_TEX[i] = map.registerSprite(new ResourceLocation(${JavaModName}.MODID, "particle/${particle.getModElement().getRegistryName()}_" + (i + 1)));
        </#if>
		</#list>
	}
}
<#-- @formatter:on -->
