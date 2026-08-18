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
<#include "procedures.java.ftl">
package ${package}.client.particle;
<#assign frameCount = data.getTextureTileCount()>
<@javacompress>

@SideOnly(Side.CLIENT) public class ${name}Particle extends Particle {
	@SideOnly(Side.CLIENT) public static class ${name}IParticleFactory implements IParticleFactory {
		public Particle createParticle(int particleID, World worldIn, double x, double y, double z, double xSpeed, double ySpeed, double zSpeed, int... parameters) {
			return new ${name}Particle(worldIn, x, y, z, xSpeed, ySpeed, zSpeed);
		}
	}
	
	<#if data.hasAngularVelocityOrAcceleration()>
	private float angularVelocity;
	private float angularAcceleration;
	</#if>

	<#if (data.scale.getFixedValue() != 1 || data.fixedScale)  && !hasProcedure(data.scale)>
	private final float originalScale;
	</#if>

	protected ${name}Particle(World world, double x, double y, double z, double vx, double vy, double vz) {
		super(world, x, y, z);

		this.setSize(${data.width}f, ${data.height}f);
		<#if (data.scale.getFixedValue() != 1 || data.fixedScale)  && !hasProcedure(data.scale)>
		originalScale = this.particleScale <#if data.fixedScale>= 0.15f *<#else>*=</#if> ${data.scale.getFixedValue()}f;
		</#if>

		<#if (data.maxAgeDiff > 0)>
		this.particleMaxAge = (int) Math.max(1, ${data.maxAge} + (this.rand.nextInt(${data.maxAgeDiff * 2}) - ${data.maxAgeDiff}));
		<#else>
		this.particleMaxAge = ${data.maxAge};
		</#if>

		this.particleGravity = ${data.gravity}f;
		this.canCollide = ${data.canCollide};

		this.motionX = vx * ${data.speedFactor};
		this.motionY = vy * ${data.speedFactor};
		this.motionZ = vz * ${data.speedFactor};

		<#if data.hasAngularVelocityOrAcceleration()>
		this.angularVelocity = ${data.angularVelocity}f;
		this.angularAcceleration = ${data.angularAcceleration}f;
		</#if>

		<#if data.animate>
		this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}<#if frameCount != 1>[Math.min(this.particleAge / this.particleMaxAge * ${frameCount}, ${frameCount - 1})]</#if>);
		<#else>
		this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}<#if frameCount != 1>[this.rand.nextInt(${frameCount})]</#if>);
		</#if>
	}

	@Override public int getFXLayer() {
		return 1;
	}

	<#if data.emissiveRendering>
	@Override public int getBrightnessForRender(float partialTick) {
		return 15728880;
	}
	</#if>

	<#if hasProcedure(data.scale)>
	@Override public void renderParticle(BufferBuilder buffer, Entity entity, float partialTicks, float rotationX, float rotationZ, float rotationYZ, float rotationXY, float rotationXZ) {
        particleScale = <#if data.fixedScale>0.15f<#else>originalScale</#if> * (float) <@procedureCode data.scale, {
            "x": "this.posX",
            "y": "this.posY",
            "z": "this.posZ",
            "world": "this.world",
            "age": "particleAge",
            "scale": "partialTicks"
        }/>
        super.renderParticle(buffer, entity, partialTicks, rotationX, rotationZ, rotationYZ, rotationXY, rotationXZ);
	}
	</#if>

	@Override public void onUpdate() {
		super.onUpdate();

		<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
		this.prevParticleAngle = this.particleAngle;
		this.particleAngle += this.angularVelocity;
		this.angularVelocity += this.angularAcceleration;
		</#if>

		<#if data.animate && frameCount != 1>
		if(!this.isExpired) {
			this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}[(this.particleAge / ${data.frameDuration}) % ${frameCount}]);
		}
		</#if>

		<#if hasProcedure(data.additionalExpiryCondition)>
		World world = this.world;
		if (<@procedureOBJToConditionCode data.additionalExpiryCondition/>)
			this.setExpired();
		</#if>
	}
}
</@javacompress>
<#-- @formatter:on -->
